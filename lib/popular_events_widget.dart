import 'package:feshta/popular_events_hero_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class popularEventsWidget extends StatelessWidget {
  final String eventType;
  final String eventName;
  final String image;

  popularEventsWidget(
      {required this.eventType, required this.eventName, required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => popularHeroWidget(
                    eventName: eventName,
                    eventType: eventType,
                    image: image,
                  ))),
      child: Stack(
        children: [
          Hero(
              tag: image,
              child: Container(
                height: 200,
                width: 300,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('images/$image.jpg'))),
              )),
          Positioned(
            bottom: 20,
            left: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventType,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                Text(
                  '$eventName',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
