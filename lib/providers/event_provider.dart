import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

import '../models/events.dart';
import '../models/env.dart';
import '../models/https_exception.dart';
import '../models/event_categories.dart';

class EventProvider with ChangeNotifier {
  bool _isFavoriteFetched;
  String _token;
  List<Event> _events;
  List<String> _dates;
  List<EventCategories> _eventCategories;
  List<Event> filteredEvents = [];

  EventProvider(this._events, this._dates, this._eventCategories, this._token,
      this._isFavoriteFetched);

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $_token",
      };

  List<Event> get events {
    return [..._events];
  }

  List<Event> get trendingEvents {
    return [...events.where((event) => event.isTrending == true).toList()];
  }

  List<String> get dates {
    return [..._dates];
  }

  List<EventCategories> get eventCategories {
    return [..._eventCategories];
  }

  List<Event> get favorites {
    return [..._events.where((element) => element.isFavorite == true)];
  }

  List<Event> get sponsoredEvents {
    return [..._events.where((element) => element.isSponsored == true)];
  }

  set tokenSetter(String token) {
    _token = token;
  }

  set isFavoriteFetchedSetter(bool isFavoriteFetched) {
    _isFavoriteFetched = isFavoriteFetched;
  }

  bool get isFavoriteFetched {
    return _isFavoriteFetched;
  }

  Future<bool> fetchEvents() async {
    //
    //error handling missing if there is no events returned
    //
    List<dynamic> hosts = [];
    List<dynamic> artists = [];
    List<dynamic> categories = [];
    try {
      final response = await http
          .post(Uri.parse(EnviromentVariables.baseUrl + 'events-show/'));
      final eventsData = json.decode(response.body) as Map<String, dynamic>;
      if (eventsData.isEmpty) {
        return true;
      }
      _events = [];
      _dates = [];
      eventsData.forEach((date, eventData) {
        for (var e in eventData) {
          var event = Event(
            id: e['id'].toString(),
            image: e['image'] ??
                'https://jcoss.org/wp-content/uploads/2015/05/event.jpg',
            name: e['name'] ?? 'Event Name',
            start: DateTime.parse(e['start']),
            end: DateTime.parse(e['final']),
            categoryIds: [],
            description: e['description'] ?? '',
            hostIds: [],
            info: e['info'] ?? '',
            isBooked: e['booking'] == '0' ? false : true,
            isSponsored: e['isSponsored'] == '0' ? false : true,
            location: e['location'] ?? '',
            offer: e['offer'] ?? '',
            price: e['price'] ?? '0',
            artistsId: [],
          );
          if (!_events.contains(event)) {
            _events.add(event);
          }
          if (!_dates.contains(date)) {
            _dates.add(date);
          }
          hosts = e['hostId'] ?? [];
          artists = e['artistId'] ?? [];
          categories = e['categoryId'] ?? [];
          for (var i = 0;
              i < (hosts.length + artists.length + categories.length);
              i++) {
            if (i >= hosts.length &&
                i >= artists.length &&
                i >= categories.length) {
              break;
            }
            if (i < hosts.length) {
              String hostId =
                  (hosts[i] as Map<String, dynamic>)['host_id'].toString();
              _events[_events.length - 1].hostIds.add(hostId);
            }
            if (i < artists.length) {
              String artistId =
                  (artists[i] as Map<String, dynamic>)['id'].toString();
              _events[_events.length - 1].artistsId.add(artistId);
            }
            if (i < categories.length) {
              String categoryId =
                  (categories[i] as Map<String, dynamic>)['id'].toString();
              _events[_events.length - 1].categoryIds.add(categoryId);
            }
          }
          artists = hosts = categories = [];
        }
      });

      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<bool> fetchTrendingEvents() async {
    //
    //error handling missing if there is no events returned
    //
    try {
      final response = await http
          .post(Uri.parse(EnviromentVariables.baseUrl + 'events-trending/'));
      final eventsData = json.decode(response.body) as List<dynamic>;
      if (eventsData[0]['id'] == null) {
        return false;
      }
      for (var e in eventsData) {
        for (var event in _events) {
          event.id == e['id']
              ? event.isTrending = true
              : event.isTrending = false;
        }
      }
      //print(json.decode(response.body));
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await http
          .get(Uri.parse(EnviromentVariables.baseUrl + 'categories-show/'));
      final resposeData = jsonDecode(response.body) as List<dynamic>;
      _eventCategories = [];
      for (var item in resposeData) {
        var cat = item as Map<String, dynamic>;
        _eventCategories.add(
          EventCategories(
              id: cat['id'].toString(),
              name: cat['name'],
              description: cat['description'],
              image: cat['image']),
        );
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> fetchFavorites() async {
    try {
      final response = await http.post(
          Uri.parse(EnviromentVariables.baseUrl + 'api/user-events/'),
          headers: headers);
      final responseData = jsonDecode(response.body) as List<dynamic>;
      if (responseData.isEmpty) {
        return;
      }
      for (var eventData in responseData) {
        final e = eventData as Map<String, dynamic>;
        for (var event in _events) {}
        final event = _events
            .firstWhereOrNull((element) => element.id == e['id'].toString());
        if (event != null) {
          event.isFavorite = true;
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> manageFavorite(String eventId) async {
    try {
      final response = await http.post(
          Uri.parse(
              EnviromentVariables.baseUrl + 'api/$eventId/favorite-user/'),
          headers: headers);
      final responseData = jsonDecode(response.body) as List<dynamic>;
      print(responseData);
      if (responseData[0] != null) {
        final responseMsg = responseData[0] as Map<String, dynamic>;
        if (responseMsg['msg'] != null) {
          if (responseMsg['msg'] == 'favorite added') {
            final event = _events
                .firstWhereOrNull((element) => element.isFavorite = true);
            if (event != null) {
              event.isFavorite = true;
            } else {
              throw HttpException(
                  'Sorry, an error occurred during this operation!');
            }
          } else if (responseMsg['msg'] == 'favorite removed') {
            final event =
                _events.firstWhereOrNull((element) => element.id == eventId);
            if (event != null) {
              event.isFavorite = false;
            } else {
              throw HttpException(
                  'Sorry, an error occurred during this operation!');
            }
          }
          notifyListeners();
        } else {
          throw HttpException(
              'Sorry, an error occurred during this operation!');
        }
      } else {
        throw HttpException('Sorry, an error occurred during this operation!');
      }
    } catch (e) {
      print(e);
      throw HttpException('Sorry, an error occurred during this operation!');
    }
  }

  void filterEvents(List<int> categoriesIndex, DateTime? date,
      int? priceRangeIndex, String location) {
    if (location.isEmpty &&
        priceRangeIndex == null &&
        date == null &&
        categoriesIndex.isEmpty) {
      filteredEvents = events;
      notifyListeners();
      return;
    }
    int countOfOperations = 0;
    List<Event> filteredEventsWithCategory = [];
    List<Event> filteredEventsWithDate = [];
    List<Event> filteredEventsWithPrice = [];
    List<Event> filteredEventsWithLocation = [];
    List<Event> filteredEventsAll = [];
    if (categoriesIndex.isNotEmpty) {
      countOfOperations += 1;
      for (var categoryIndex in categoriesIndex) {
        for (var event in events) {
          if (event.categoryIds.contains(eventCategories[categoryIndex].id)) {
            filteredEventsWithCategory.add(event);
          }
        }
      }
    }
    if (date != null) {
      countOfOperations += 1;
      for (var event in events) {
        if (event.start.isAtSameMomentAs(date)) {
          filteredEventsWithDate.add(event);
        }
      }
    }
    if (priceRangeIndex != null) {
      countOfOperations += 1;
      switch (priceRangeIndex) {
        case 0:
          {
            filteredEventsWithPrice = filterWithPrice(1, 500);
            break;
          }
        case 1:
          {
            filteredEventsWithPrice = filterWithPrice(501, 1000);
            break;
          }
        case 2:
          {
            filteredEventsWithPrice = filterWithPrice(1001, 1500);
            break;
          }
        case 3:
          {
            filteredEventsWithPrice = filterWithPrice(1501, 2000);
            break;
          }
        case 4:
          {
            filteredEventsWithPrice = filterWithPrice(2001, 2500);
            break;
          }
        case 5:
          {
            filteredEventsWithPrice = filterWithPrice(2501, 100000);
            break;
          }
        default:
      }
    }

    if (location.isNotEmpty) {
      countOfOperations += 1;
      for (var event in events) {
        if (event.location == location) {
          filteredEventsWithLocation.add(event);
        }
      }
    }
    List<Event> tempAll = [];
    tempAll.addAll(filteredEventsWithCategory);
    tempAll.addAll(filteredEventsWithDate);
    tempAll.addAll(filteredEventsWithLocation);
    tempAll.addAll(filteredEventsWithPrice);

    for (var event in tempAll) {
      int count =
          tempAll.where((element) => element.id == event.id).toList().length;
      if (count == countOfOperations) {
        filteredEventsAll.add(event);
      }
    }
    filteredEvents = filteredEventsAll;
    notifyListeners();
  }

  List<Event> filterWithPrice(double startPrice, double endPrice) {
    List<Event> filteredEvents = [];
    for (var event in events) {
      if (double.parse(event.price) >= startPrice &&
          double.parse(event.price) <= endPrice) {
        filteredEvents.add(event);
      }
    }
    return filteredEvents;
  }

  String GetDay(String dateString) {
    String day = '';
    var date = DateTime.parse(dateString);
    switch (date.weekday) {
      case 1:
        day = "MON";
        break;
      case 2:
        day = "TUE";
        break;
      case 3:
        day = "WED";
        break;
      case 4:
        day = "THU";
        break;
      case 5:
        day = "FRI";
        break;
      case 6:
        day = "SAT";
        break;
      case 7:
        day = "SUN";
        break;
    }
    //print(day);
    return day;
  }

  String GetMonth(String dateString) {
    String month = '';
    var date = DateTime.parse(dateString);
    switch (date.month) {
      case 1:
        month = "JAN";
        break;
      case 2:
        month = "FEB";
        break;
      case 3:
        month = "MAR";
        break;
      case 4:
        month = "APR";
        break;
      case 5:
        month = "MAY";
        break;
      case 6:
        month = "JUN";
        break;
      case 7:
        month = "JUL";
        break;
      case 8:
        month = "AUG";
        break;
      case 9:
        month = "SEP";
        break;
      case 10:
        month = "OCT";
        break;
      case 11:
        month = "NOV";
        break;
      case 12:
        month = "DEC";
        break;
    }
    return month;
  }

  String GetDayNum(String date) {
    int day = DateTime.parse(date).day;
    return day < 10 ? '0' + day.toString() : day.toString();
  }
}
