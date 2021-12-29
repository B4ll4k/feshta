import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:feshta/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../providers/artist_provider.dart';
import '../providers/host_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool? _isConnected;
  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) => {_checkConnection(context)});
    super.initState();
  }

  Future _checkConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 30), onTimeout: () async {
        return Future.delayed(Duration.zero).then((value) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(minutes: 15),
              content: const Text('Failed to estasblish connection!'),
              action: SnackBarAction(
                label: 'Retry',
                onPressed: () async {
                  await _checkConnection(context);
                },
              ),
            ),
          );
          List<InternetAddress> temp = [];
          temp.add(InternetAddress.fromRawAddress(Uint8List.fromList([])));
          return Future.value(temp);
        });
      });
      print('w');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _isConnected = true;
      } else {
        _isConnected = false;
      }
      if (_isConnected!) {
        await _initiateObjects(context);
        Navigator.pushReplacementNamed(context, '/tabPage');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: const Duration(minutes: 15),
            content: const Text('Failed to estasblish connection!'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: () async {
                await _checkConnection(context);
              },
            ),
          ),
        );
      }
    } on SocketException catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(minutes: 15),
          content: const Text('Failed to estasblish connection!'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () async {
              await _checkConnection(context);
            },
          ),
        ),
      );
      _isConnected = false;
      print('not connected');
    }
  }

  Future _initiateObjects(BuildContext context) async {
    await Provider.of<UserProvider>(context, listen: false).tryAutoLogIn();
    await Provider.of<EventProvider>(context, listen: false).fetchEvents();
    await Provider.of<HostProvider>(context, listen: false).fetchHosts();
    await Provider.of<ArtistProvider>(context, listen: false).fetchArtists();
    await Provider.of<EventProvider>(context, listen: false)
        .fetchTrendingEvents();
    await Provider.of<HostProvider>(context, listen: false)
        .fetchTrendingHosts();
    await Provider.of<ArtistProvider>(context, listen: false)
        .fetchTrendingArtists();
    await Provider.of<EventProvider>(context, listen: false).fetchCategories();
    await Provider.of<HostProvider>(context, listen: false)
        .fetchMostLikedHosts();
    await Provider.of<ArtistProvider>(context, listen: false)
        .fetchMostLikedArtists();
    await Provider.of<ArtistProvider>(context, listen: false)
        .fetchRecentlyPreformingArtists();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
              image: AssetImage('assets/images/icon.png'),
              fit: BoxFit.cover,
              height: 150,
              width: 150,
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
