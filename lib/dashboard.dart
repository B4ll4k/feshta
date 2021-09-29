import 'package:feshta/categories.dart';
import 'package:feshta/entity_slider.dart';
import 'package:feshta/popular_events_widget.dart';
import 'package:feshta/services/connection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    ApiConnection apiConnection = new ApiConnection();
    apiConnection.getEvents(
        Uri.parse('https://event-corner.ken-techno.com/events-trending/'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10),
                        child: Text(
                          "July 9, 2021",
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
                                color: Color(0xff4F2EAC))),
                      )
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 15.0, right: 20),
                  //   child: Column(children: [
                  //     CircleAvatar(
                  //       radius: 25,
                  //       backgroundImage: NetworkImage(
                  //           "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80"),
                  //     ),
                  //   ]),
                  // ),
                ],
              ),
              _searchBar(),
              SizedBox(
                height: 15,
              ),
              _PopularEvents(),
              SizedBox(
                height: 15,
              ),
              _categories(),
              _entityDisplayer("trending"),
              _entityDisplayer("Host"),
              _entityDisplayer("Artist")
            ],
          ),
        ),
      ),
    );
  }
}

Container _searchBar() {
  return Container(
    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.black38.withAlpha(7),
      borderRadius: BorderRadius.all(
        Radius.circular(20),
      ),
    ),
    child: Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              hintStyle:
                  GoogleFonts.poppins(color: Color(0xff4F2EAC).withAlpha(120)),
              border: InputBorder.none,
            ),
            onChanged: (String keyword) {},
          ),
        ),
        Icon(
          FontAwesomeIcons.slidersH,
          color: Color(0xff4F2EAC).withAlpha(100),
        )
      ],
    ),
  );
}

Column _PopularEvents() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("POPULAR EVENTS",
                style: GoogleFonts.poppins(
                    color: Color(0xff4F2EAC),
                    fontWeight: FontWeight.w700,
                    fontSize: 17)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("More",
                style: GoogleFonts.poppins(
                    color: Color(0xff4F2EAC),
                    fontWeight: FontWeight.w300,
                    fontSize: 13)),
          ),
        ],
      ),
      Container(
        height: 220,
        width: double.infinity,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            popularEventsWidget(
              eventType: "Concert",
              eventName: "Jano Tour",
              image: "pexels-wolfgang-2747449",
            ),
            popularEventsWidget(
              eventType: "Concert",
              eventName: "Teddy Afro",
              image: "pexels-josh-sorenson-976866",
            ),
            popularEventsWidget(
              eventType: "Concert",
              eventName: "Betty G",
              image: "pexels-teddy-yang-2263436",
            ),
          ],
        ),
      )
    ],
  );
}

Column _forYou() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("FOR YOU",
                style: GoogleFonts.poppins(
                    color: Color(0xff4F2EAC),
                    fontWeight: FontWeight.w700,
                    fontSize: 17)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("More",
                style: GoogleFonts.poppins(
                    color: Color(0xff4F2EAC),
                    fontWeight: FontWeight.w300,
                    fontSize: 13)),
          ),
        ],
      ),
      Container(
        height: 130,
        width: double.infinity,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1557672172-298e090bd0f1?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80'))),
      ),
    ],
  );
}

Column _categories() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Categories",
                style: GoogleFonts.poppins(
                    color: Color(0xff4F2EAC),
                    fontWeight: FontWeight.w700,
                    fontSize: 20)),
          )
        ],
      ),
      Container(
        height: 110,
        width: double.infinity,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CategoriesWidget(
              id: '1',
              name: "Concert",
              image: "pexels-wolfgang-2747449",
            ),
            CategoriesWidget(
              id: '2',
              name: "Art",
              image: "pexels-josh-sorenson-976866",
            ),
            CategoriesWidget(
              id: '3',
              name: "Food",
              image: "pexels-teddy-yang-2263436",
            )
          ],
        ),
      )
    ],
  );
}

Column _entityDisplayer(String component) {
  String text = "";
  switch (component.toLowerCase()) {
    case "trending":
      {
        text = "Trending Events";
        break;
      }
    case "host":
      {
        text = "Hosts";
        break;
      }
    case "artist":
      {
        text = "Artists";
        break;
      }
    default:
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(text,
                style: GoogleFonts.poppins(
                    color: Color(0xff4F2EAC),
                    fontWeight: FontWeight.w700,
                    fontSize: 20)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("More",
                style: GoogleFonts.poppins(
                    color: Color(0xff4F2EAC),
                    fontWeight: FontWeight.w600,
                    fontSize: 14)),
          ),
        ],
      ),
      Container(
        height: 180,
        width: double.infinity,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            EntitySliderWidget(
              id: '1',
              name: "Concert",
              image: "pexels-josh-sorenson-976866",
              width: 150,
            ),
            EntitySliderWidget(
              id: '2',
              name: "Art",
              image: "pexels-teddy-yang-2263436",
              width: 150,
            ),
            EntitySliderWidget(
              id: '3',
              name: "Food",
              image: "pexels-wolfgang-2747449",
              width: 150,
            )
          ],
        ),
      )
    ],
  );
}
