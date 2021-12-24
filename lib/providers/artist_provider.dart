import 'dart:convert';

import 'package:feshta/models/env.dart';
import 'package:feshta/models/https_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

import '../models/artists.dart';

class ArtistProvider with ChangeNotifier {
  List<Artist> _artists;
  String _token;
  bool _isFavoriteFetched;

  ArtistProvider(this._artists, this._token, this._isFavoriteFetched);

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

  List<Artist> get artists {
    return [..._artists];
  }

  List<Artist> get mostLikedArtists {
    return [..._artists.where((element) => element.isMostLiked == true)];
  }

  List<Artist> get recentlyPerformingArtists {
    return [
      ..._artists.where((element) => element.isRecentlyPerforming == true)
    ];
  }

  List<Artist> get trendingArtists {
    return [..._artists.where((element) => element.isTrending == true)];
  }

  Future<bool> fetchArtists() async {
    List<dynamic> events = [];
    List<dynamic> hosts = [];
    try {
      final response = await http
          .post(Uri.parse(EnviromentVariables.baseUrl + 'artists-show/'));
      final responseData = jsonDecode(response.body) as List<dynamic>;
      _artists = [];
      for (var artist in responseData) {
        _artists.add(Artist(
          id: artist['id'].toString(),
          image: artist['image'] ??
              'https://www.pngkit.com/png/detail/869-8690434_jazz-jazz-music-clip-art.png',
          name: artist['name'] ?? 'J Doe',
          description: artist['description'] ?? '',
          eventsId: [],
          hostsId: [],
        ));
        events = artist['event'] ?? [];
        hosts = artist['host'] ?? [];
        for (var i = 0; i < (events.length + hosts.length); i++) {
          if (i >= events.length && i >= hosts.length) {
            break;
          }
          if (i < events.length) {
            String eventId =
                (events[i] as Map<String, dynamic>)['event_id'].toString();
            _artists[_artists.length - 1].eventsId.add(eventId);
          }
          if (i < hosts.length) {
            String hostId = (hosts[i] as Map<String, dynamic>)['id'].toString();
            _artists[_artists.length - 1].hostsId.add(hostId);
          }
        }
        events = [];
        hosts = [];
      }
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchRecentlyPreformingArtists() async {
    try {
      final response = await http
          .post(Uri.parse(EnviromentVariables.baseUrl + 'artists-performing/'));
      final responseData = json.decode(response.body);

      for (var artistData in responseData) {
        var artist = _artists.firstWhereOrNull(
            (element) => element.id == artistData['id'].toString());
        if (artist != null) {
          artist.isRecentlyPerforming = true;
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> fetchMostLikedArtists() async {
    try {
      final response = await http
          .post(Uri.parse(EnviromentVariables.baseUrl + 'artists-liked/'));
      final responseData = json.decode(response.body);

      for (var artistData in responseData) {
        var artist = _artists.firstWhereOrNull(
            (element) => element.id == artistData['id'].toString());
        if (artist != null) {
          artist.isMostLiked = true;
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> fetchTrendingArtists() async {
    try {
      final response = await http
          .post(Uri.parse(EnviromentVariables.baseUrl + 'artists-trending/'));
      final responseData = json.decode(response.body);

      for (var artistData in responseData) {
        var artist = _artists.firstWhereOrNull(
            (element) => element.id == artistData['id'].toString());
        if (artist != null) {
          artist.isTrending = true;
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
          Uri.parse(EnviromentVariables.baseUrl + 'api/user-artists/'),
          headers: headers);
      final responseData = json.decode(response.body) as List<dynamic>;
      if (responseData.isEmpty) {
        return;
      }
      for (var artistData in responseData) {
        final a = artistData as Map<String, dynamic>;
        final artist = _artists
            .firstWhereOrNull((element) => element.id == a['id'].toString());
        if (artist != null) {
          artist.isFavorite = true;
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> manageFavorite(String artistId) async {
    try {
      final response = await http.post(
          Uri.parse(
              EnviromentVariables.baseUrl + 'api/$artistId/favorite-user/'),
          headers: headers);
      final responseData = jsonDecode(response.body) as List<dynamic>;
      if (responseData[0]) {
        final responseMsg = responseData[0] as Map<String, dynamic>;
        if (responseMsg['msg']) {
          if (responseMsg['msg'] == 'favorite added') {
            final artist = _artists
                .firstWhereOrNull((element) => element.isFavorite = true);
            if (artist != null) {
              artist.isFavorite = true;
            } else {
              throw HttpException(
                  'Sorry, an error occurred during this operation!');
            }
          } else if (responseMsg['msg'] == 'favorite removed') {
            final artist = _artists
                .firstWhereOrNull((element) => element.isFavorite = false);
            if (artist != null) {
              artist.isFavorite = false;
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
