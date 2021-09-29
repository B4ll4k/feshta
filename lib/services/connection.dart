import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/events.dart';
import '../models/artists.dart';
import '../models/hosts.dart';

class ApiConnection {
  void getEvents(Uri url) {
    http.post(url).then((http.Response response) => {print(response.body)});
  }
}
