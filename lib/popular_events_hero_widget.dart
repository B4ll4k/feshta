import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class popularHeroWidget extends StatelessWidget {
  final String eventType;
  final String eventName;
  final String image;

  popularHeroWidget(
      {required this.eventType, required this.eventName, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildStack(context),
          ],
        ),
      ),
    );
  }

  Stack _buildStack(BuildContext context) {
    return Stack(
      children: [
        Hero(
            tag: image,
            child: Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/$image.jpg'),
                      fit: BoxFit.cover)),
            )),
        Positioned(
            top: 30,
            left: 10,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(FontAwesomeIcons.arrowLeft),
              color: Colors.white,
              iconSize: 20,
            )),
      ],
    );
  }
}
