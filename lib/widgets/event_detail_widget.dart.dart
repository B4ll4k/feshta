import 'package:feshta/models/artists.dart';
import 'package:feshta/models/events.dart';
import 'package:feshta/models/hosts.dart';
import 'package:feshta/providers/artist_provider.dart';
import 'package:feshta/providers/cart_provider.dart';
import 'package:feshta/providers/event_provider.dart';
import 'package:feshta/providers/host_provider.dart';
import 'package:feshta/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../entity_slider.dart';

class EventsDetailWidget extends StatefulWidget {
  final String id;

  EventsDetailWidget({Key? key, required this.id}) : super(key: key);

  @override
  State<EventsDetailWidget> createState() => _EventsDetailWidgetState();
}

class _EventsDetailWidgetState extends State<EventsDetailWidget> {
  bool _isLoadingBookBtn = false;
  Event? event;

  Host? host;

  List<Artist> artists = [];

  IconData favIcon = Icons.favorite_border;

  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    event = Provider.of<EventProvider>(context)
        .events
        .firstWhere((element) => element.id == widget.id);
    if (event != null) {
      if (event!.isFavorite) {
        favIcon = Icons.favorite;
        isFavorite = true;
      }
    }
    host = Provider.of<HostProvider>(context, listen: false)
        .hosts
        .firstWhereOrNull((element) => element.id == event!.hostIds[0]);
    final allArtists =
        Provider.of<ArtistProvider>(context, listen: false).artists;
    for (var artistId in event!.artistsId) {
      var artist =
          allArtists.firstWhereOrNull((element) => element.id == artistId);
      if (artist != null) {
        artists.add(artist);
      }
    }
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: _buildBody(context),
      ),
      // bottomNavigationBar:
      //     Provider.of<UserProvider>(context, listen: false).isAuth
      //         ? Container(
      //             width: double.infinity,
      //             height: 40,
      //             decoration:
      //                 BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
      //             child: ElevatedButton(
      //               style: ButtonStyle(
      //                   backgroundColor: MaterialStateProperty.resolveWith(
      //                       (states) => Theme.of(context).primaryColor)),
      //               child: const Text(
      //                 'Book',
      //                 style: TextStyle(color: Colors.white),
      //               ),
      //               onPressed: () {},
      //             ))
      //         : Container(),
      floatingActionButton: Provider.of<UserProvider>(context).isAuth
          ? _isLoadingBookBtn
              ? const CircularProgressIndicator()
              : FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      _isLoadingBookBtn = true;
                    });
                    Provider.of<CartProvider>(context, listen: false)
                        .addToCart(event!.id)
                        .then((value) => setState(() {
                              _isLoadingBookBtn = false;
                            }));

                    Navigator.pushNamed(context, '/cartPage');
                  },
                  label: const Text(
                    'Book',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  icon: const Icon(
                    Icons.book,
                    color: Colors.white,
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                )
          : Container(),
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
            event!.name,
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
        ),
        _buildHostInfo(context),
        const SizedBox(
          height: 18.0,
        ),
        _buildDate(context),
        const SizedBox(
          height: 17.0,
        ),
        _buildLocation(context),
        const SizedBox(
          height: 17,
        ),
        _buildPrice(context),
        _buldDescription(context),
        _buildInfo(context),
        _buildOffer(context),
        const SizedBox(
          height: 15,
        ),
        _buildArtistSlider(),
        const SizedBox(
          height: 25,
        )
      ],
    );
  }

  Widget _buildHostInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(width: 6.0),
            CircleAvatar(
              radius: 30.0,
              foregroundColor: Colors.grey.withOpacity(0.1),
              backgroundColor: Colors.grey.withOpacity(0.1),
              backgroundImage: NetworkImage(host!.logo),
            ),
            const SizedBox(
              width: 3.0,
            ),
            Text(
              host!.name,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        Provider.of<UserProvider>(context, listen: false).isAuth
            ? Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(
                    host!.isFavorite ? 'Following' : 'Follow',
                    style: const TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Container(),
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
                  image: NetworkImage(event!.image), fit: BoxFit.cover)),
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
        Provider.of<UserProvider>(context, listen: false).isAuth
            ? Positioned(
                top: 30,
                right: 45,
                child: IconButton(
                  onPressed: () {
                    try {
                      Provider.of<EventProvider>(context, listen: false)
                          .manageFavorite(widget.id);
                      setState(() {
                        isFavorite = !isFavorite;
                        if (isFavorite) {
                          favIcon = Icons.favorite;
                        } else {
                          favIcon = Icons.favorite_border;
                        }
                      });
                    } catch (e) {
                      _showErrorDialog(context, e.toString());
                    }
                  },
                  icon: Icon(favIcon),
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
                  'Check this cool event out at https://feshta.com/event/${widget.id}',
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
    return event == null || event!.description.isEmpty
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
                  event!.description,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          );
  }

  Widget _buildDate(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 10.0,
        ),
        Icon(
          Icons.calendar_today,
          color: Theme.of(context).primaryColor,
          size: 25,
        ),
        const SizedBox(
          width: 10.0,
        ),
        Text(
          "${Provider.of<EventProvider>(context, listen: false).GetMonth(event!.start.toString())} ${event!.start.day.toString()}, ${event!.start.year.toString()}",
          style: const TextStyle(
              color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w700),
        )
      ],
    );
  }

  Widget _buildLocation(BuildContext context) {
    return event == null || event!.location.isEmpty
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
                event!.location.length > 30
                    ? event!.location.substring(0, 30) +
                        '\n' +
                        event!.location.substring(30)
                    : event!.location,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          );
  }

  Widget _buildPrice(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 9,
        ),
        Icon(
          Icons.monetization_on,
          color: Theme.of(context).primaryColor,
          size: 30,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Text(
          event == null || event!.price == '0' ? 'Free' : event!.price,
          style: const TextStyle(
              color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w700),
        )
      ],
    );
  }

  Widget _buildInfo(BuildContext context) {
    return event != null && event!.info.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Info',
                  style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  event!.info,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          )
        : Container();
  }

  Widget _buildOffer(BuildContext context) {
    return event != null && event!.offer.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Offer',
                  style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  event!.offer,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              )
            ],
          )
        : Container();
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
                    child: Text('Artist',
                        style: GoogleFonts.poppins(
                            color: const Color(0xff4F2EAC),
                            fontWeight: FontWeight.w700,
                            fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text("More",
                        style: GoogleFonts.poppins(
                            color: const Color(0xff4F2EAC),
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ),
                ],
              ),
              Container(
                height: 300,
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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
