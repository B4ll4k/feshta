import 'package:feshta/widgets/artist_detail_widget.dart';
import 'package:feshta/widgets/host_detail_widget.dart';
import 'package:flutter/material.dart';

import 'widgets/event_detail_widget.dart.dart';

class EntitySliderWidget extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final double width;
  final String entityType;

  const EntitySliderWidget({
    Key? key,
    required this.id,
    required this.name,
    required this.image,
    required this.width,
    required this.entityType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => entityType.contains('event')
              ? EventsDetailWidget(
                  id: id,
                )
              : entityType.contains('host')
                  ? HostDetailWidget(id: id)
                  : entityType.contains('artist')
                      ? ArtistDetailWidget(id: id)
                      : EventsDetailWidget(id: id),
        ),
      ),
      child: Stack(
        children: [
          Container(
            height: 200,
            //width: 170,
            width: width,
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                    fit: BoxFit.cover, image: NetworkImage(image))),
          ),
          // Positioned(
          //   bottom: 40,
          //   left: 50,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text(
          //         '$name',
          //         style: GoogleFonts.poppins(
          //             color: Colors.white,
          //             fontSize: 20,
          //             fontWeight: FontWeight.w600),
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }
}
