import 'package:feshta/providers/event_provider.dart';
import 'package:feshta/widgets/event_detail_widget.dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsFilteredPage extends StatelessWidget {
  static const String route = '/filteredEventsPage';
  const EventsFilteredPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filtered Events',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
      body: _buildEventWithCategoryGrid(context),
    );
  }

  Widget _buildEventWithCategoryGrid(BuildContext context) {
    //return GridView.count(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5, children: List<Widget>.generate(Provider.of<EventProvider>(context).events.where((element) => element.categoryIds[0] == _categoryId).length, (index) => null),);
    final events = Provider.of<EventProvider>(context).filteredEvents;
    return events.isEmpty
        ? const Center(
            child: Text(
              'No Event Found',
              style: TextStyle(fontSize: 25),
            ),
          )
        : GridView.builder(
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            padding: const EdgeInsets.all(5.0),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: events.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              EventsDetailWidget(id: events[index].id)));
                },
                child: Container(
                  margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(events[index].image),
                        fit: BoxFit.cover),
                  ),
                ),
              );
            });
    //return Container();
  }
}
