import 'package:feshta/widgets/categories.dart';
import 'package:feshta/entity_slider.dart';
import 'package:feshta/models/event_categories.dart';
import 'package:feshta/providers/artist_provider.dart';
import 'package:feshta/providers/user_provider.dart';
import 'package:feshta/widgets/event_detail_widget.dart.dart';
import 'package:feshta/widgets/popular_events_widget.dart';
import 'package:feshta/providers/event_provider.dart';
import 'package:feshta/providers/host_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/events.dart';

class MyHomePage extends StatefulWidget {
  static const String homePageRoute = '/home';
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Event> events = [];
  //List<EventCategories> categories = [];
  bool _isInit = true;
  bool _isSearch = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<EventProvider>(context, listen: false).fetchEvents();
        await Provider.of<HostProvider>(context, listen: false).fetchHosts();
        await Provider.of<ArtistProvider>(context, listen: false)
            .fetchArtists();
        await Provider.of<EventProvider>(context, listen: false)
            .fetchTrendingEvents();
        await Provider.of<HostProvider>(context, listen: false)
            .fetchTrendingHosts();
        await Provider.of<ArtistProvider>(context, listen: false)
            .fetchTrendingArtists();
        await Provider.of<EventProvider>(context, listen: false)
            .fetchCategories();
        await Provider.of<HostProvider>(context, listen: false)
            .fetchMostLikedHosts();
        await Provider.of<ArtistProvider>(context, listen: false)
            .fetchMostLikedArtists();
        await Provider.of<ArtistProvider>(context, listen: false)
            .fetchRecentlyPreformingArtists();
      },
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const PageScrollPhysics(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 7),
                        child: Text(
                          "${Provider.of<EventProvider>(context, listen: false).GetMonth(DateTime.now().toString())} ${DateTime.now().day.toString()}, ${DateTime.now().year.toString()}",
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text("Discover Events",
                            style: GoogleFonts.poppins(
                                fontSize: 33,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff4F2EAC))),
                      )
                    ],
                  ),
                ],
              ),
              _searchBar(),
              const SizedBox(
                height: 15,
              ),
              _isSearch ? Container() : _popularEvents(),
              _isSearch
                  ? Container()
                  : const SizedBox(
                      height: 15,
                    ),
              _isSearch ? Container() : _buildCategoriesList(context),
              //_entityDisplayer("trending"),
              _isSearch ? Container() : _buildHostSlider(),
              _isSearch ? Container() : _buildArtistSlider(),
              _isSearch ? _buildSearchList() : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black38.withAlpha(7),
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              onTap: () {
                setState(() {
                  _isSearch = true;
                  events =
                      Provider.of<EventProvider>(context, listen: false).events;
                });
              },
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: GoogleFonts.poppins(
                    color: const Color(0xff4F2EAC).withAlpha(120)),
                border: InputBorder.none,
              ),
              onChanged: (String keyword) {
                if (keyword.isEmpty) {
                  setState(() {
                    events = Provider.of<EventProvider>(context, listen: false)
                        .events;
                  });
                } else {
                  setState(() {
                    events = Provider.of<EventProvider>(context, listen: false)
                        .events
                        .where((element) => element.name
                            .toLowerCase()
                            .contains(keyword.toLowerCase()))
                        .toList();
                  });
                }
              },
            ),
          ),
          IconButton(
            onPressed: () {
              if (_isSearch) {
                setState(() {
                  _isSearch = false;
                  events = [];
                });
              } else {
                Navigator.pushNamed(context, '/filterPage');
              }
            },
            icon: Icon(
              _isSearch ? Icons.close : FontAwesomeIcons.slidersH,
              color: const Color(0xff4F2EAC).withAlpha(100),
            ),
          )
        ],
      ),
    );
  }

  Widget _popularEvents() {
    return Provider.of<EventProvider>(context).trendingEvents.isEmpty
        ? Container()
        : SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text("POPULAR EVENTS",
                          style: GoogleFonts.poppins(
                              color: const Color(0xff4F2EAC),
                              fontWeight: FontWeight.w700,
                              fontSize: 17)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/seeall',
                            arguments: 'eventsTrending'),
                        child: Text("More",
                            style: GoogleFonts.poppins(
                                color: const Color(0xff4F2EAC),
                                fontWeight: FontWeight.w300,
                                fontSize: 13)),
                      ),
                    ),
                  ],
                ),
                Consumer<EventProvider>(
                  builder: (ctx, eventProvider, _) => Container(
                    height: 220,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount: eventProvider.trendingEvents.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) => PopularEventsWidget(
                        eventName: eventProvider.trendingEvents[index].name,
                        image: eventProvider.trendingEvents[index].image,
                        id: eventProvider.trendingEvents[index].id,
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }

  Widget _buildCategoriesList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text("Categories",
                  style: GoogleFonts.poppins(
                      color: const Color(0xff4F2EAC),
                      fontWeight: FontWeight.w700,
                      fontSize: 20)),
            )
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/categories');
          },
          child: Container(
            height: 110,
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount:
                  Provider.of<EventProvider>(context).eventCategories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) => CategoriesWidget(
                id: Provider.of<EventProvider>(context)
                    .eventCategories[index]
                    .id,
                name: Provider.of<EventProvider>(context)
                    .eventCategories[index]
                    .name,
                image: Provider.of<EventProvider>(context)
                    .eventCategories[index]
                    .image,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildHostSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Host',
                  style: GoogleFonts.poppins(
                      color: const Color(0xff4F2EAC),
                      fontWeight: FontWeight.w700,
                      fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () =>
                    Navigator.pushNamed(context, '/seeall', arguments: 'hosts'),
                child: Text("More",
                    style: GoogleFonts.poppins(
                        color: const Color(0xff4F2EAC),
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ),
            ),
          ],
        ),
        Consumer<HostProvider>(
          builder: (context, hostProvider, _) => Container(
            height: 180,
            width: double.infinity,
            child: ListView.builder(
              itemCount: hostProvider.hosts.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemBuilder: (ctx, index) => EntitySliderWidget(
                id: hostProvider.hosts[index].id,
                name: hostProvider.hosts[index].name,
                image: hostProvider.hosts[index].logo,
                width: 150,
                entityType: 'host',
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildArtistSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Artist',
                  style: GoogleFonts.poppins(
                      color: const Color(0xff4F2EAC),
                      fontWeight: FontWeight.w700,
                      fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/seeall',
                    arguments: 'artists'),
                child: Text("More",
                    style: GoogleFonts.poppins(
                        color: const Color(0xff4F2EAC),
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ),
            ),
          ],
        ),
        Consumer<ArtistProvider>(
          builder: (context, artistProvider, _) => Container(
            height: 180,
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: artistProvider.artists.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) => EntitySliderWidget(
                id: artistProvider.artists[index].id,
                name: artistProvider.artists[index].name,
                image: artistProvider.artists[index].image,
                width: 150,
                entityType: 'artist',
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSearchList() {
    return ListView.builder(
      physics: const PageScrollPhysics(),
      itemCount: events.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventsDetailWidget(id: events[index].id),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
          child: Card(
            child: Image(
              image: NetworkImage(events[index].image),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
