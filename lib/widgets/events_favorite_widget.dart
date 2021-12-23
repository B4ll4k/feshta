import 'package:feshta/providers/artist_provider.dart';
import 'package:feshta/providers/event_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventsFavoriteWidget extends StatelessWidget {
  const EventsFavoriteWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context, listen: false).favorites;
    return events.isEmpty
        ? const Center(
            child: Text('No Favorite Events'),
          )
        : Consumer<EventProvider>(
            builder: (context, eventProvider, _) => ListView.builder(
              shrinkWrap: true,
              itemCount: events.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(events[index].image))),
                  ),
                  title: Text(events[index].name),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.favorite,
                          size: 25, color: Colors.red)),
                );
              },
            ),
          );
  }
}
