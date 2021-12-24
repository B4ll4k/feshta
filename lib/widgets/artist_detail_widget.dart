import 'package:collection/collection.dart';
import 'package:feshta/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../entity_slider.dart';
import '../models/artists.dart';
import '../models/events.dart';
import '../models/hosts.dart';
import '../providers/artist_provider.dart';
import '../providers/event_provider.dart';
import '../providers/host_provider.dart';

class ArtistDetailWidget extends StatelessWidget {
  final String id;
  Artist? artist;
  List<Host> hosts = [];
  List<Event> events = [];

  ArtistDetailWidget({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    artist = Provider.of<ArtistProvider>(context, listen: false)
        .artists
        .firstWhere((element) => element.id == id);
    final allHosts = Provider.of<HostProvider>(context, listen: false).hosts;
    for (var hostId in artist!.hostsId) {
      var host = allHosts.firstWhereOrNull((element) => element.id == hostId);
      if (host != null) {
        hosts.add(host);
      }
    }

    final allEvents = Provider.of<EventProvider>(context, listen: false).events;
    for (var eventId in artist!.hostsId) {
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
            artist!.name,
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
        ),
        _buldDescription(context),
        const SizedBox(
          height: 15.0,
        ),
        _buildHostSlider(),
        const SizedBox(
          height: 15.0,
        ),
        _buildEventSlider(),
        const SizedBox(
          height: 25,
        ),
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
                  image: NetworkImage(artist!.image), fit: BoxFit.cover)),
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
                  icon: artist!.isFavorite
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
                  'Check this cool artist out at https://feshta.com/artist/$id',
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
    return artist == null || artist!.description.isEmpty
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
                  artist!.description,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          );
  }

  Widget _buildHostSlider() {
    return hosts.isEmpty
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Associated Hosts',
                        style: GoogleFonts.poppins(
                            color: const Color(0xff4F2EAC),
                            fontWeight: FontWeight.w700,
                            fontSize: 20)),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(8.0),
                height: 230,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: hosts.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) => EntitySliderWidget(
                    id: hosts[index].id,
                    name: hosts[index].name,
                    image: hosts[index].logo,
                    entityType: 'host',
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
              ListView.builder(
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
            ],
          );
  }
}
