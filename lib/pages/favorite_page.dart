import 'package:feshta/providers/artist_provider.dart';
import 'package:feshta/providers/event_provider.dart';
import 'package:feshta/providers/host_provider.dart';
import 'package:feshta/widgets/artists_favorite_widet.dart';
import 'package:feshta/widgets/events_favorite_widget.dart';
import 'package:feshta/widgets/hosts_favorite_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  static const String route = '/favoritePage';
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('Favorites'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Events',
                icon: Icon(Icons.event_note_sharp),
              ),
              Tab(
                text: 'Hosts',
                icon: Icon(Icons.houseboat),
              ),
              Tab(
                text: 'Artists',
                icon: Icon(Icons.mic_external_on),
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            EventsFavoriteWidget(),
            HostsFavoriteWidget(),
            ArtistsFavoriteWidget(),
          ],
        ),
      ),
    );
  }
}
