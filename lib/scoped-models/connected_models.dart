import 'dart:convert';
import 'dart:html';

import 'package:feshta/models/events.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

mixin ConnectedModel on Model {
  final String BASE_URI = 'https://feshta.com/';
  final bool _isLoggedIn = false;
}

mixin EventModel on ConnectedModel {
  List<Event> events = [];

  // Future fetchEvents(){
  //   http.post(Uri)
  // }
}

mixin HostModel on ConnectedModel {}

mixin ArtistModel on ConnectedModel {}

mixin UserModel on ConnectedModel {
  bool get isLoggedIn {
    return _isLoggedIn;
  }

  Future login(String email, String password) {
    final Map<String, dynamic> user = {'username': email, 'password': password};
    return http
        .post(Uri.parse(BASE_URI + '/api/login_check'), body: jsonEncode(user))
        .then((http.Response response) {
      if (response.statusCode == HttpStatus.accepted) {
        print(response.body);
      } else {
        print(response.body);
      }
    });
  }
}
