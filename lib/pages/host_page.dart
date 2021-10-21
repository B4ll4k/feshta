import 'package:feshta/entity_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HostPage extends StatefulWidget {
  const HostPage({Key? key}) : super(key: key);

  @override
  _HostPageState createState() => _HostPageState();
}

class _HostPageState extends State<HostPage> {
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
                        child: Text("Hosts",
                            style: GoogleFonts.poppins(
                                fontSize: 33,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff4F2EAC))),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, right: 20),
                    child: Column(children: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white),
                            shadowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.white10)),
                        onPressed: () {},
                        child: Icon(
                          Icons.search,
                          size: 40,
                          color: Color(0xff4F2EAC),
                        ),
                      ),
                      // CircleAvatar(
                      //   radius: 25,
                      //   backgroundImage: NetworkImage(
                      //       "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80"),
                      // ),
                    ]),
                  ),
                ],
              ),
              // _searchBar(),
              // SizedBox(
              //   height: 15,
              // ),
              // _PopularEvents(),
              // SizedBox(
              //   height: 15,
              // ),
              // _categories(),
              SizedBox(
                height: 15,
              ),
              _entityDisplayer("sponsored"),
              SizedBox(
                height: 15,
              ),
              _entityDisplayer("popular"),
              SizedBox(
                height: 15,
              ),
              _entityDisplayer("recent"),
              SizedBox(
                height: 15,
              ),
              _entityDisplayer("liked")
            ],
          ),
        ),
      ),
    );
  }
}

Column _entityDisplayer(String componentName) {
  String text = "";
  switch (componentName.toLowerCase()) {
    case "sponsored":
      {
        text = "Sponsored Hosts";
        break;
      }
    case "popular":
      {
        text = "Popular Hosts";
        break;
      }
    case "recent":
      {
        text = "Recent Hosts";
        break;
      }
    case "liked":
      {
        text = "Most Liked";
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
