import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EventPage();
  }
}

class _EventPage extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text("Event"),
      ),
    );
  }
}
