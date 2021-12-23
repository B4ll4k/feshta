import 'dart:async';
import 'dart:convert';

import 'package:feshta/models/https_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/env.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  String? _token;
  Timer? _authTimer;

  bool get isAuth {
    if (_token == null) {
      return false;
    }
    return !JwtDecoder.isExpired(_token!);
  }

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $_token",
      };

  User get user {
    return _user!;
  }

  String? get token {
    return _token;
  }

  Future<void> login(String email, String password) async {
    final Map<String, dynamic> user = {'username': email, 'password': password};
    try {
      final response = await http.post(
        Uri.parse(EnviromentVariables.baseUrl + 'api/login_check'),
        body: json.encode(user),
        headers: {'Content-Type': 'application/json'},
      );
      final responseMap = json.decode(response.body) as Map<String, dynamic>;
      print(responseMap);
      if (responseMap['code'] != null) {
        throw HttpException(responseMap['message']);
      }
      if (responseMap['token'] != null) {
        _token = responseMap['token'];
        var user = await fetchUserProfile();
        print(user);
        _user = User(
            email: email,
            firstName: user['firstName'] ?? '',
            lastName: user['lastName'] ?? '',
            tel: user['tel'] ?? '');
        _autoLogOut();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'firstName': _user!.firstName,
          'lastName': _user!.lastName,
          'tel': _user!.tel,
          'email': _user!.email,
          'token': _token
        });
        prefs.setString('userData', userData);
      } else {
        throw HttpException('Something went wrong!');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final response = await http.post(
          Uri.parse(EnviromentVariables.baseUrl + 'api/info'),
          headers: headers);
      print(response.body);
      final responseData = jsonDecode(response.body) as List<dynamic>;

      final responseMap = responseData[0] as Map<String, dynamic>;

      return responseMap;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final userData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    var tokenFromStorage = userData['token'].toString();
    if (JwtDecoder.isExpired(tokenFromStorage)) {
      return false;
    }
    _user = User(
        email: userData['email'].toString(),
        firstName: userData['firstName'].toString(),
        lastName: userData['lastName'].toString(),
        tel: userData['tel'].toString());
    _token = tokenFromStorage;
    return true;
  }

  void logOut() async {
    _token = null;
    _user = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    DateTime expiryDate = JwtDecoder.getExpirationDate(_token!);
    final timeToExpiry = expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }

  Future<void> signup(String email, String password, String phoneNum) async {
    // don't forget to call autologOut after finishing this method
    final Map<String, dynamic> user = {
      'email': email,
      'password': password,
      'firstName': '',
      'lastName': '',
      'tel': phoneNum,
    };
    print(jsonEncode(user));
    try {
      final response = await http.post(
        Uri.parse(EnviromentVariables.baseUrl + 'app-register/'),
        body: json.encode(user),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.body);
      final res = (json.decode(response.body) as List<dynamic>);
      final responseBody = res[0] as Map<String, dynamic>;
      if (responseBody['status'].toString().compareTo('ok') != 0) {
        String error = responseBody['status'];
        throw HttpException(error);
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> verifyCode(String code, String phoneNo) async {
    final body = {'code': code, 'tel': phoneNo};
    try {
      final response = await http.post(
          Uri.parse(EnviromentVariables.baseUrl + 'verifytel/'),
          body: jsonEncode(body));
      print(response.body);
      final responseData = json.decode(response.body) as List<dynamic>;
      final responseMap = responseData[0] as Map<String, dynamic>;
      if (responseMap['status'] == null || responseMap['status'] != 'ok') {
        throw HttpException('Wrong Code');
      }
      print(response);
    } catch (e) {
      print(e);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProfile(String firstName, String lastName, String password,
      String newPassword, bool isFirstTime, String email) async {
    final body = {
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'newPassword': newPassword
    };
    try {
      final response = await http.post(
          Uri.parse(EnviromentVariables.baseUrl + 'api/update'),
          body: jsonEncode(body),
          headers: headers);
      print(response.body);
      final responseData = json.decode(response.body) as List<dynamic>;
      final responseMap = responseData[0] as Map<String, dynamic>;
      if (responseMap['msg'] == null ||
          responseMap['msg'] != 'Password Updated') {
        throw HttpException('Please check your input!');
      }
      if (isFirstTime) {
        await login(email, password);
      }
      user.firstName = firstName;
      user.lastName = lastName;
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
      rethrow;
    }
  }
}
