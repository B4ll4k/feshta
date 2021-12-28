import 'package:feshta/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:share_plus/share_plus.dart';

import '../entity_slider.dart';
import '../models/artists.dart';
import '../models/events.dart';
import '../models/hosts.dart';
import '../providers/artist_provider.dart';
import '../providers/event_provider.dart';
import '../providers/host_provider.dart';

class HostDetailWidget extends StatelessWidget {
  final String id;
  List<Event> events = [];
  Host? host;
  List<Artist> artists = [];
  HostDetailWidget({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    host = Provider.of<HostProvider>(context, listen: false)
        .hosts
        .firstWhereOrNull((element) => element.id == id);
    final allArtists =
        Provider.of<ArtistProvider>(context, listen: false).artists;
    for (var artistId in host!.artistsId) {
      var artist =
          allArtists.firstWhereOrNull((element) => element.id == artistId);
      if (artist != null) {
        artists.add(artist);
      }
    }
    final allEvents = Provider.of<EventProvider>(context, listen: false).events;
    for (var eventId in host!.eventsId) {
      var event =
          allEvents.firstWhereOrNull((element) => element.id == eventId);
      if (event != null) {
        events.add(event);
      }
    }
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageStack(context),
        Padding(
          padding: const EdgeInsets.only(
              top: 15.0, bottom: 15.0, left: 10, right: 5.0),
          child: Text(
            host!.name,
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
        ),
        _buildLocation(context),
        const SizedBox(
          height: 17,
        ),
        _buldDescription(context),
        const SizedBox(
          height: 15,
        ),
        _buildArtistSlider(),
        _buildEventSlider(),
      ],
    );
  }

  Widget _buildImageStack(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 350,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(host!.logo), fit: BoxFit.cover)),
        ),
        Positioned(
          top: 30,
          left: 10,
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(FontAwesomeIcons.arrowLeft),
            color: Colors.white,
            iconSize: 20,
          ),
        ),
        Provider.of<UserProvider>(context).isAuth
            ? Positioned(
                top: 30,
                right: 45,
                child: IconButton(
                  onPressed: () {},
                  icon: host!.isFavorite
                      ? const Icon(Icons.favorite)
                      : const Icon(Icons.favorite_border),
                  color: Colors.white,
                  iconSize: 30,
                ),
              )
            : Container(),
        Positioned(
          top: 28,
          right: 5,
          child: IconButton(
            icon: const Icon(Icons.ios_share),
            onPressed: () {
              Share.share(
                  'Check this cool event organizer out at https://feshta.com/host/$id',
                  subject: 'Feshta');
            },
            color: Colors.white,
            iconSize: 30,
          ),
        )
      ],
    );
  }

  Widget _buldDescription(BuildContext context) {
    return host == null || host!.description.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Description',
                  style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  host!.description,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          );
  }

  Widget _buildLocation(BuildContext context) {
    return host == null || host!.address.isEmpty
        ? Container()
        : Row(
            children: [
              const SizedBox(
                width: 7,
              ),
              Icon(
                Icons.location_on,
                color: Theme.of(context).primaryColor,
                size: 30,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                host!.address.length > 30
                    ? host!.address.substring(0, 30) +
                        '\n' +
                        host!.address.substring(30)
                    : host!.address,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          );
  }

  Widget _buildArtistSlider() {
    return artists.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Associated Artists',
                        style: GoogleFonts.poppins(
                            color: const Color(0xff4F2EAC),
                            fontWeight: FontWeight.w700,
                            fontSize: 20)),
                  ),
                ],
              ),
              Container(
                height: 230,
                margin: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: artists.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) => EntitySliderWidget(
                    id: artists[index].id,
                    name: artists[index].name,
                    image: artists[index].image,
                    entityType: 'artist',
                    width: 150,
                  ),
                ),
              ),
            ],
          );
  }

  Widget _buildEventSlider() {
    return events.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Upcoming Events',
                        style: GoogleFonts.poppins(
                            color: const Color(0xff4F2EAC),
                            fontWeight: FontWeight.w700,
                            fontSize: 20)),
                  ),
                ],
              ),
              Container(
                height: 230,
                margin: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: events.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) => EntitySliderWidget(
                    id: events[index].id,
                    name: events[index].name,
                    image: events[index].image,
                    entityType: 'event',
                    width: 150,
                  ),
                ),
              ),
            ],
          );
  }
}
