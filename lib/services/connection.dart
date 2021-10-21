import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/events.dart';
import '../models/artists.dart';
import '../models/hosts.dart';

class ApiConnection {
  void getEvents(Uri url, List<Event> events) {
    http.post(url).then((http.Response response) => {
          //print(response.body)
          for (var item in json.decode(response.body))
            {
              events.add(Event(
                  id: item['id'],
                  image: item['image'],
                  name: item['name'],
                  total: item['total']))
            }
        });
    //print(events);
  }
}
