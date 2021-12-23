import 'package:feshta/providers/artist_provider.dart';
import 'package:feshta/providers/host_provider.dart';
import 'package:feshta/widgets/artist_detail_widget.dart';
import 'package:feshta/widgets/event_detail_widget.dart.dart';
import 'package:feshta/widgets/host_detail_widget.dart';

import '../models/hosts.dart';
import '../models/artists.dart';
import '../models/events.dart';
import '../providers/event_provider.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SeeAllType { event, host, artist }

class SeeAllPage extends StatelessWidget {
  static const String seeAllPageRoute = '/seeall';
  SeeAllPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String queryParams = ModalRoute.of(context)!.settings.arguments.toString();
    print(queryParams);
    SeeAllType seeAllType = SeeAllType.event;
    List<Event> events = [];
    List<Host> hosts = [];
    List<Artist> artists = [];
    //print(queryParams.split('/')[0]);
    switch (queryParams.split('/')[0]) {
      case 'eventsWithDate':
        {
          print('inside switch');
          DateTime dateTime = DateTime.parse(queryParams.split('/')[1]);
          events = Provider.of<EventProvider>(context)
              .events
              .where((event) => event.start.isAtSameMomentAs(dateTime))
              .toList();
          break;
        }
      case 'eventsTrending':
        {
          events = Provider.of<EventProvider>(context).trendingEvents;
          break;
        }
      case 'hosts':
        {
          seeAllType = SeeAllType.host;
          hosts = Provider.of<HostProvider>(context).hosts;
          break;
        }
      case 'hostsTrending':
        {
          seeAllType = SeeAllType.host;
          hosts = Provider.of<HostProvider>(context).trendingHosts;
          break;
        }
      case 'mostLikedHosts':
        {
          seeAllType = SeeAllType.host;
          hosts = Provider.of<HostProvider>(context).mostLikedHosts;
          break;
        }
      case 'sponsoredHosts':
        {
          seeAllType = SeeAllType.host;
          hosts = Provider.of<HostProvider>(context).sponsoredHosts;
          break;
        }
      case 'artists':
        {
          seeAllType = SeeAllType.artist;
          artists = Provider.of<ArtistProvider>(context).artists;
          break;
        }
      case 'artistsTrending':
        {
          seeAllType = SeeAllType.artist;
          artists = Provider.of<ArtistProvider>(context).trendingArtists;
          break;
        }
      case 'mostLikedArtists':
        {
          seeAllType = SeeAllType.artist;
          artists = Provider.of<ArtistProvider>(context).mostLikedArtists;
          break;
        }
      case 'recentArtists':
        {
          seeAllType = SeeAllType.artist;
          artists =
              Provider.of<ArtistProvider>(context).recentlyPerformingArtists;
          break;
        }
      default:
        {}
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('See All Page'),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: seeAllType == SeeAllType.event
            ? events.length
            : (seeAllType == SeeAllType.artist ? artists.length : hosts.length),
        itemBuilder: (ctx, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: SeeAllCard(
              seeAllType == SeeAllType.event
                  ? events[index]
                  : (seeAllType == SeeAllType.artist
                      ? artists[index]
                      : hosts[index]),
              seeAllType),
        ),
      ),
    );
  }
}

class SeeAllCard extends StatelessWidget {
  final SeeAllType _seeAllType;
  Event? event;
  Host? host;
  Artist? artist;
  SeeAllCard(
    Object object,
    this._seeAllType, {
    Key? key,
  }) : super(key: key) {
    switch (_seeAllType) {
      case SeeAllType.event:
        {
          event = object as Event;
          break;
        }
      case SeeAllType.host:
        {
          host = object as Host;
          break;
        }
      case SeeAllType.artist:
        {
          artist = object as Artist;
          break;
        }
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_seeAllType == SeeAllType.event) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventsDetailWidget(id: event!.id),
            ),
          );
        } else if (_seeAllType == SeeAllType.host) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HostDetailWidget(id: host!.id),
            ),
          );
        } else if (_seeAllType == SeeAllType.artist) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtistDetailWidget(id: artist!.id),
            ),
          );
        }
      },
      child: Container(
        width: double.infinity,
        height: 250,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
        child: Card(
          child: Image(
            image: NetworkImage(_seeAllType == SeeAllType.host
                ? host!.logo
                : (_seeAllType == SeeAllType.event
                    ? event!.image
                    : artist!.image)),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
