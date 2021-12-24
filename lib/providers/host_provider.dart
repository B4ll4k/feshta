import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

import '../models/env.dart';
import '../models/hosts.dart';
import '../models/https_exception.dart';

class HostProvider with ChangeNotifier {
  List<Host> _hosts;
  String _token;
  bool _isFavoriteFetched = false;

  HostProvider(this._hosts, this._token, this._isFavoriteFetched);

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $_token",
      };

  set tokenSetter(String token) {
    _token = token;
  }

  set isFavoriteFetchedSetter(bool isFavoriteFetched) {
    _isFavoriteFetched = isFavoriteFetched;
  }

  bool get isFavoriteFetched {
    return _isFavoriteFetched;
  }

  List<Host> get hosts {
    return [..._hosts];
  }

  List<Host> get sponsoredHosts {
    return _hosts.where((element) => element.isSponsored == true).toList();
  }

  List<Host> get favoriteHosts {
    return [..._hosts.where((element) => element.isFavorite == true).toList()];
  }

  List<Host> get trendingHosts {
    return [..._hosts.where((element) => element.isTrending == true)];
  }

  List<Host> get mostLikedHosts {
    return [..._hosts.where((element) => element.isMostLiked == true)];
  }

  Future<bool> fetchHosts() async {
    List<dynamic> events = [];
    List<dynamic> artists = [];
    try {
      final response = await http
          .post(Uri.parse(EnviromentVariables.baseUrl + 'hosts-show/'));
      final hostData = json.decode(response.body) as List<dynamic>;
      _hosts = [];
      for (var host in hostData) {
        _hosts.add(
          Host(
            id: host['id'].toString(),
            name: host['name'] ?? 'Host Name',
            logo: host['logo'] ?? '',
            description: host['description'] ?? '',
            address: host['address'] ??
                'https://ih1.redbubble.net/image.565018999.2851/st,small,507x507-pad,600x600,f8f8f8.u1.jpg',
            artistsId: [],
            eventsId: [],
            isSponsored: host['isSponsored'] ?? false,
          ),
        );
        if (host['event'] != null) {
          events = host['event'];
        }
        if (host['artist'] != null) {
          artists = host['artist'];
        }
        for (var i = 0; i < events.length; i++) {
          String eventId =
              (events[i] as Map<String, dynamic>)['event_id'].toString();
          _hosts[(_hosts.length - 1)].eventsId.add(eventId);
        }
        for (var i = 0; i < artists.length; i++) {
          String artistId =
              (artists[i] as Map<String, dynamic>)['artist_id'].toString();
          _hosts[_hosts.length - 1].artistsId.add(artistId);
        }
        artists = [];
        events = [];
      }
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchTrendingHosts() async {
    try {
      final response = await http
          .post(Uri.parse(EnviromentVariables.baseUrl + 'hosts-trending/'));
      final responseData = json.decode(response.body) as List<dynamic>;

      for (var hostData in responseData) {
        var host = _hosts.firstWhereOrNull((element) =>
            element.id == (hostData as Map<String, dynamic>)['id'].toString());
        if (host != null) {
          host.isTrending = true;
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> fetchMostLikedHosts() async {
    try {
      final response = await http
          .post(Uri.parse(EnviromentVariables.baseUrl + 'hosts-liked/'));
      final responseData = json.decode(response.body);
      for (var hostData in responseData) {
        var host = _hosts.firstWhereOrNull(
            (element) => element.id == hostData['id'].toString());
        if (host != null) {
          host.isMostLiked = true;
        }
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
          Uri.parse(EnviromentVariables.baseUrl + 'api/user-hosts/'),
          headers: headers);
      final responseData = json.decode(response.body) as List<dynamic>;
      if (responseData.isEmpty) {
        return;
      }
      for (var hostData in responseData) {
        final h = hostData as Map<String, dynamic>;
        final host = _hosts
            .firstWhereOrNull((element) => element.id == h['id'].toString());
        if (host != null) {
          host.isFavorite = true;
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> manageFavorite(String hostId) async {
    try {
      final response = await http.post(
          Uri.parse(EnviromentVariables.baseUrl + 'api/$hostId/favorite-user/'),
          headers: headers);
      final responseData = jsonDecode(response.body) as List<dynamic>;
      if (responseData[0]) {
        final responseMsg = responseData[0] as Map<String, dynamic>;
        if (responseMsg['msg']) {
          if (responseMsg['msg'] == 'favorite added') {
            final host =
                hosts.firstWhereOrNull((element) => element.id == hostId);
            if (host != null) {
              host.isFavorite = true;
            } else {
              throw HttpException(
                  'Sorry, an error occurred during this operation!');
            }
          } else if (responseMsg['msg'] == 'favorite removed') {
            final host =
                hosts.firstWhereOrNull((element) => element.id == hostId);
            if (host != null) {
              host.isFavorite = true;
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
}
