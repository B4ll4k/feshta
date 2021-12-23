//import 'package:feshta/popular_events_hero_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoriesWidget extends StatelessWidget {
  final String id;
  final String name;
  final String image;

  const CategoriesWidget(
      {Key? key, required this.id, required this.name, required this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => popularHeroWidget(eventName: eventName, eventType: eventType, image: image,))),
      child: Stack(
        children: [
          Hero(
              tag: image,
              child: Container(
                height: 200,
                width: 170,
                margin: const EdgeInsets.all(5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(image),
                      colorFilter: const ColorFilter.mode(
                          Colors.black26, BlendMode.srcOver),
                    )),
              )),
          Positioned(
            top: 30,
            bottom: 20,
            left: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.length > 10
                      ? name.substring(0, 10) + '\n' + name.substring(10)
                      : name,
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.fade,
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
