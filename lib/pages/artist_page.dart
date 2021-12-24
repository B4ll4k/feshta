import 'package:feshta/entity_slider.dart';
import 'package:feshta/providers/artist_provider.dart';
import 'package:feshta/providers/event_provider.dart';
import 'package:feshta/widgets/artist_detail_widget.dart';
import 'package:feshta/widgets/artists_favorite_widet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/artists.dart';
import '../providers/artist_provider.dart';

class ArtistPage extends StatefulWidget {
  ArtistPage({Key? key}) : super(key: key);

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  bool _isSearch = false;
  List<Artist> artists = [];
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<ArtistProvider>(context, listen: false)
            .fetchArtists();
        await Provider.of<ArtistProvider>(context, listen: false)
            .fetchTrendingArtists();
        await Provider.of<ArtistProvider>(context, listen: false)
            .fetchMostLikedArtists();
        await Provider.of<ArtistProvider>(context, listen: false)
            .fetchRecentlyPreformingArtists();
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(
                  height: 15,
                ),
                _isSearch ? _buildSearchBar() : Container(),
                _isSearch
                    ? const SizedBox(
                        height: 10,
                      )
                    : Container(),
                _isSearch ? _buildSearchList() : Container(),
                // _entityDisplayer("sponsored"),
                // const SizedBox(
                //   height: 15,
                // ),
                _isSearch
                    ? Container()
                    : _buildArtistEntityDisplayer("Trending Artists"),
                _isSearch
                    ? Container()
                    : const SizedBox(
                        height: 15,
                      ),
                _isSearch
                    ? Container()
                    : _buildArtistEntityDisplayer("Recent Artists"),
                _isSearch
                    ? Container()
                    : const SizedBox(
                        height: 15,
                      ),
                _isSearch
                    ? Container()
                    : _buildArtistEntityDisplayer("Most Liked"),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10),
              child: Text(
                "${Provider.of<EventProvider>(context, listen: false).GetMonth(DateTime.now().toString())} ${DateTime.now().day.toString()}, ${DateTime.now().year.toString()}",
                style: GoogleFonts.poppins(
                    color: Colors.grey, fontWeight: FontWeight.w700),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Artists",
                  style: GoogleFonts.poppins(
                      fontSize: 33,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff4F2EAC))),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 14.0),
          child: IconButton(
            onPressed: () {
              setState(() {
                if (_isSearch) {
                  _isSearch = false;
                  artists = [];
                } else {
                  _isSearch = true;
                  artists = Provider.of<ArtistProvider>(context, listen: false)
                      .artists;
                }
              });
            },
            icon: _isSearch
                ? const Icon(
                    Icons.close,
                    size: 40,
                    color: Color(0xff4F2EAC),
                  )
                : const Icon(
                    Icons.search,
                    size: 40,
                    color: Color(0xff4F2EAC),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildArtistEntityDisplayer(String text) {
    return Consumer<ArtistProvider>(
      builder: (context, artistProvider, _) => text == 'Trending Artists'
          ? artistProvider.trendingArtists.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHostTypeRow(text),
                    Container(
                      height: 180,
                      width: double.infinity,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: artistProvider.trendingArtists.length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return EntitySliderWidget(
                              id: artistProvider.trendingArtists[index].id,
                              name: artistProvider.trendingArtists[index].name,
                              image:
                                  artistProvider.trendingArtists[index].image,
                              width: 150,
                              entityType: 'artist',
                            );
                          }),
                    ),
                  ],
                )
              : Container()
          : (text == 'Recent Artists'
              ? artistProvider.recentlyPerformingArtists.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHostTypeRow(text),
                        Container(
                          height: 180,
                          width: double.infinity,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: artistProvider
                                  .recentlyPerformingArtists.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return EntitySliderWidget(
                                  id: artistProvider
                                      .recentlyPerformingArtists[index].id,
                                  name: artistProvider
                                      .recentlyPerformingArtists[index].name,
                                  image: artistProvider
                                      .recentlyPerformingArtists[index].image,
                                  width: 150,
                                  entityType: 'artist',
                                );
                              }),
                        ),
                      ],
                    )
                  : Container()
              : (text == 'Most Liked')
                  ? artistProvider.mostLikedArtists.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHostTypeRow(text),
                            Container(
                              height: 180,
                              width: double.infinity,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount:
                                      artistProvider.mostLikedArtists.length,
                                  shrinkWrap: true,
                                  itemBuilder: (ctx, index) {
                                    return EntitySliderWidget(
                                      id: artistProvider
                                          .mostLikedArtists[index].id,
                                      name: artistProvider
                                          .mostLikedArtists[index].name,
                                      image: artistProvider
                                          .mostLikedArtists[index].image,
                                      width: 150,
                                      entityType: 'artist',
                                    );
                                  }),
                            ),
                          ],
                        )
                      : Container()
                  : Container()),
    );
  }

  Widget _buildHostTypeRow(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(text,
              style: GoogleFonts.poppins(
                  color: const Color(0xff4F2EAC),
                  fontWeight: FontWeight.w700,
                  fontSize: 20)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () {
              if (text.toLowerCase() == 'trending artists') {
                Navigator.pushNamed(context, '/seeall',
                    arguments: 'artistsTrending');
              } else if (text.toLowerCase() == 'most liked') {
                Navigator.pushNamed(context, '/seeall',
                    arguments: 'mostLikedArtists');
              } else if (text.toLowerCase() == 'recent artists') {
                Navigator.pushNamed(context, '/seeall',
                    arguments: 'recentArtists');
              }
            },
            child: Text("More",
                style: GoogleFonts.poppins(
                    color: const Color(0xff4F2EAC),
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
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
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: GoogleFonts.poppins(
                    color: const Color(0xff4F2EAC).withAlpha(120)),
                border: InputBorder.none,
              ),
              onChanged: (String keyword) {
                if (keyword.isEmpty) {
                  setState(() {
                    artists =
                        Provider.of<ArtistProvider>(context, listen: false)
                            .artists;
                  });
                } else {
                  setState(() {
                    artists =
                        Provider.of<ArtistProvider>(context, listen: false)
                            .artists
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
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: const Color(0xff4F2EAC).withAlpha(100),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchList() {
    return ListView.builder(
      physics: const PageScrollPhysics(),
      itemCount: artists.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => (ArtistDetailWidget(id: artists[index].id)),
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
              image: NetworkImage(artists[index].image),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
