import 'package:feshta/entity_slider.dart';
import 'package:feshta/providers/event_provider.dart';
import 'package:feshta/providers/host_provider.dart';
import 'package:feshta/widgets/host_detail_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/hosts.dart';

class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  _HostPageState createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
  List<Host> hosts = [];
  bool _isSearch = false;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<HostProvider>(context, listen: false).fetchHosts();
        await Provider.of<HostProvider>(context, listen: false)
            .fetchTrendingHosts();
        await Provider.of<HostProvider>(context, listen: false)
            .fetchMostLikedHosts();
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                header(),
                // _searchBar(),
                // SizedBox(
                //   height: 15,
                // ),
                // _PopularEvents(),
                // SizedBox(
                //   height: 15,
                // ),
                // _categories(),
                _isSearch
                    ? const SizedBox(
                        height: 10,
                      )
                    : Container(),
                _isSearch ? _buildSearchBar() : Container(),
                _isSearch
                    ? Container()
                    : const SizedBox(
                        height: 15,
                      ),
                _isSearch
                    ? Container()
                    : _hostEntityDisplayer("Sponsored Hosts"),
                const SizedBox(
                  height: 15,
                ),
                _isSearch ? Container() : _hostEntityDisplayer("Popular Hosts"),
                _isSearch
                    ? Container()
                    : const SizedBox(
                        height: 15,
                      ),
                // _hostEntityDisplayer("Recent Hosts"),
                // const SizedBox(
                //   height: 15,
                // ),
                _isSearch ? Container() : _hostEntityDisplayer("Most Liked"),
                _isSearch
                    ? Container()
                    : const SizedBox(
                        height: 15,
                      ),
                _isSearch ? _buildSearchList() : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _hostEntityDisplayer(String text) {
    return Consumer<HostProvider>(
      builder: (context, hostProvider, _) => text == 'Sponsored Hosts'
          ? hostProvider.sponsoredHosts.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHostTypeRow(text),
                    Container(
                      height: 180,
                      width: double.infinity,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: hostProvider.sponsoredHosts.length,
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return EntitySliderWidget(
                              id: hostProvider.sponsoredHosts[index].id,
                              name: hostProvider.sponsoredHosts[index].name,
                              image: hostProvider.sponsoredHosts[index].logo,
                              width: 150,
                              entityType: 'host',
                            );
                          }),
                    ),
                  ],
                )
              : Container()
          : (text == 'Popular Hosts'
              ? hostProvider.trendingHosts.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHostTypeRow(text),
                        Container(
                          height: 180,
                          width: double.infinity,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: hostProvider.trendingHosts.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return EntitySliderWidget(
                                  id: hostProvider.trendingHosts[index].id,
                                  name: hostProvider.trendingHosts[index].name,
                                  image: hostProvider.trendingHosts[index].logo,
                                  width: 150,
                                  entityType: 'host',
                                );
                              }),
                        ),
                      ],
                    )
                  : Container()
              : (text == 'Recent Hosts')
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHostTypeRow(text),
                        Container(
                          height: 180,
                          width: double.infinity,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: hostProvider.hosts.length,
                              shrinkWrap: true,
                              itemBuilder: (ctx, index) {
                                return EntitySliderWidget(
                                  id: hostProvider.hosts[index].id,
                                  name: hostProvider.hosts[index].name,
                                  image: hostProvider.hosts[index].logo,
                                  width: 150,
                                  entityType: 'host',
                                );
                              }),
                        ),
                      ],
                    )
                  : hostProvider.mostLikedHosts.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHostTypeRow(text),
                            Container(
                              height: 180,
                              width: double.infinity,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: hostProvider.mostLikedHosts.length,
                                  shrinkWrap: true,
                                  itemBuilder: (ctx, index) {
                                    return EntitySliderWidget(
                                      id: hostProvider.mostLikedHosts[index].id,
                                      name: hostProvider
                                          .mostLikedHosts[index].name,
                                      image: hostProvider
                                          .mostLikedHosts[index].logo,
                                      width: 150,
                                      entityType: 'host',
                                    );
                                  }),
                            ),
                          ],
                        )
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
              if (text.toLowerCase() == 'popular hosts') {
                Navigator.pushNamed(context, '/seeall',
                    arguments: 'hostsTrending');
              } else if (text.toLowerCase() == 'most liked') {
                Navigator.pushNamed(context, '/seeall',
                    arguments: 'mostLikedHosts');
              } else if (text.toLowerCase() == 'sponsored hosts') {
                Navigator.pushNamed(context, '/seeall',
                    arguments: 'sponsoredHosts');
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

  Widget header() {
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
              child: Text("Hosts",
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
                  hosts = [];
                } else {
                  _isSearch = true;
                  hosts =
                      Provider.of<HostProvider>(context, listen: false).hosts;
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
                    hosts =
                        Provider.of<HostProvider>(context, listen: false).hosts;
                  });
                } else {
                  setState(() {
                    hosts = Provider.of<HostProvider>(context, listen: false)
                        .hosts
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
      itemCount: hosts.length,
      shrinkWrap: true,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HostDetailWidget(id: hosts[index].id),
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
              image: NetworkImage(hosts[index].logo),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
