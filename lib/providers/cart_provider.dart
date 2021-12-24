import 'dart:convert';

import 'package:feshta/models/env.dart';
import 'package:feshta/models/https_exception.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

import '../models/cart.dart';
import 'package:flutter/cupertino.dart';

class CartProvider with ChangeNotifier {
  List<Cart> _carts;
  bool _isCartFetched;
  String token;

  CartProvider(this._carts, this.token, this._isCartFetched);

  List<Cart> get carts {
    return _carts;
  }

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };

  set tokenSetter(String token) {
    this.token = token;
  }

  set isCartFetchedSetter(bool isCartFetched) {
    _isCartFetched = isCartFetched;
  }

  bool get isCartFetched {
    return _isCartFetched;
  }

  Future<void> fetchCarts() async {
    try {
      final response = await http.post(
          Uri.parse(EnviromentVariables.baseUrl + 'api/cart'),
          headers: headers);
      final responseData = jsonDecode(response.body) as List<dynamic>;
      _carts = [];
      print(responseData);
      for (var cartData in responseData) {
        final cart = cartData as Map<String, dynamic>;
        _carts.add(Cart(
          orderId: cart['OrderId'].toString(),
          ticketId: cart['Ticketid'],
          eventId: cart['Eventid'],
          name: cart['Name'],
          description: cart['Description'],
          image: cart['Image'],
          quantity: int.parse(cart['Quantity'].toString()),
          price: double.parse(cart['price'].toString()),
          total: double.parse(cart['Total'].toString()),
        ));
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addToCart(String eventId) async {
    final bodyMap = {'quantity': 1};
    try {
      final response = await http.post(
          Uri.parse(EnviromentVariables.baseUrl + 'api/$eventId/addcart'),
          body: jsonEncode(bodyMap),
          headers: headers);
      final responseData = jsonDecode(response.body) as List<dynamic>;
      print(responseData);
      final responseMap = responseData[0] as Map<String, dynamic>;
      if (responseMap['msg'] != null &&
          responseMap['msg'] == 'Event added to cart') {
        await fetchCarts();
      } else {
        throw HttpException('Something went wrong!');
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
      rethrow;
    }
  }

  void modifyQuantityCart(String ticketId, bool increase) {
    // final bodyMap = {'ticketId': int.parse(ticketId), 'quantity': quantity};
    // try {
    //   final response = await http.post(
    //       Uri.parse(EnviromentVariables.baseUrl + 'api/modifycart'),
    //       body: jsonEncode(bodyMap));
    //   final responseData = jsonDecode(response.body) as List<dynamic>;
    //   final responseMsg = responseData[0] as Map<String, dynamic>;
    //   if (responseMsg['msg']) {
    //   } else {
    //     throw HttpException('Something went wrong!');
    //   }
    // } catch (e) {
    //   print(e);
    //   rethrow;
    // }

    var order =
        _carts.firstWhereOrNull((element) => element.ticketId == ticketId);
    if (order != null) {
      if (increase) {
        order.quantity = order.quantity + 1;
        order.total = order.total + order.price;
      } else {
        if (order.quantity > 1) {
          order.quantity = order.quantity - 1;
          order.total = order.total - order.price;
        }
      }
    }
    notifyListeners();
  }

  Future<void> checkOut() async {
    List<Map<String, dynamic>> modification = [];
    for (var cart in carts) {
      var mod = {
        'ticketId': int.parse(cart.ticketId),
        'quantity': cart.quantity
      };
      modification.add(mod);
    }
    Map<String, dynamic> modificationMap = {'modification': modification};
    final body = jsonEncode(modificationMap);
    try {
      final response = await http.post(
          Uri.parse(EnviromentVariables.baseUrl + 'api/modifyallcart'),
          body: body,
          headers: headers);
      print(response.body);
      final responseData = jsonDecode(response.body) as List<dynamic>;
      final responseMap = responseData[0] as Map<String, dynamic>;
      if (responseMap['msg']) {
      } else {
        throw HttpException('Something went wrong!');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  double totalPrice() {
    double totalPrice = 0;

    for (var cart in _carts) {
      totalPrice = totalPrice + cart.total;
    }
    notifyListeners();
    return totalPrice;
  }

  Future<void> removeOrder(String ticketId) async {
    final bodyMap = {'ticketId': int.parse(ticketId)};
    try {
      final respose = await http.post(
          Uri.parse(EnviromentVariables.baseUrl + 'api/removecart'),
          body: jsonEncode(bodyMap),
          headers: headers);
      final responseData = jsonDecode(respose.body) as List<dynamic>;
      final responseMsg = responseData[0] as Map<String, dynamic>;
      if (responseMsg['msg']) {
        _carts.removeWhere((element) => element.ticketId == ticketId);
        totalPrice();
      } else {
        throw HttpException('Sorry, something went wrong!');
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
      rethrow;
    }
  }
}
