import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/event_provider.dart';
import '../widgets/events_card.dart';

class EventPage extends StatelessWidget {
  const EventPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var eventsProvider = Provider.of<EventProvider>(context);
    var dates = eventsProvider.dates;
    var events = eventsProvider.events;

    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<EventProvider>(context, listen: false).fetchEvents();
      },
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(context, GetMonth: eventsProvider.GetMonth),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(4),
                  shrinkWrap: true,
                  itemCount: dates.length,
                  itemBuilder: (BuildContext context, int index) {
                    return EventsCard(
                      events.firstWhere((element) =>
                          element.start
                              .compareTo(DateTime.parse(dates[index])) ==
                          0),
                      events
                          .where(
                            (element) => element.start.isAtSameMomentAs(
                              DateTime.parse(dates[index]),
                            ),
                          )
                          .toList()
                          .length,
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, {required Function GetMonth}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 10),
              child: Text(
                "${GetMonth(DateTime.now().toString())} ${DateTime.now().day.toString()}, ${DateTime.now().year.toString()}",
                style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                    fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Upcoming Events",
                  style: GoogleFonts.poppins(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff4F2EAC))),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Column(children: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.slidersH),
              onPressed: () {
                Navigator.pushNamed(context, '/filterPage');
              },
              color: const Color(0xff4F2EAC),
            ),
          ]),
        ),
      ],
    );
  }
}
