import 'package:feshta/providers/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/events.dart';

class EventsCard extends StatelessWidget {
  final Event event;
  final int numOfEvents;

  EventsCard(this.event, this.numOfEvents, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final eventsProvider = Provider.of<EventProvider>(context, listen: false);
    return Container(
      //height: 400,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildDate(
              GetDay: eventsProvider.GetDay,
              GetMonth: eventsProvider.GetMonth,
              GetDayNum: eventsProvider.GetDayNum),
          _buildEventImages(context),
        ],
      ),
    );
  }

  Widget _buildEventImages(BuildContext context) {
    return /////// event images ///////
        Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.only(right: 15.0, top: 10.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/seeall',
                    arguments: 'eventsWithDate/${event.start}');
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(event.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 7),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/seeall',
                    arguments: 'eventsWithDate/${event.start}');
              },
              child: Container(
                height: 25,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                      colorFilter: const ColorFilter.mode(
                          Colors.black26, BlendMode.srcOver),
                      image: NetworkImage(event.image),
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        numOfEvents - 1 >= 1
                            ? '$numOfEvents more events'
                            : 'Only 1 event in this day.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 17),
                      ),
                      const Icon(Icons.arrow_forward_ios,
                          size: 15, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDate(
      {required Function GetDay,
      required Function GetMonth,
      required Function GetDayNum}) {
    return /////////////////date/////////////////
        Container(
      padding: const EdgeInsets.only(top: 10),
      width: 100,
      child: Column(
        children: [
          Text(
            GetMonth(event.start.toIso8601String()),
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              border: Border.all(color: Colors.black38, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  GetDayNum(event.start.toIso8601String()),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w900),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    GetDay(event.start.toIso8601String()),
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
