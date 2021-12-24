import 'package:feshta/providers/ticket_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketsHistoryPage extends StatelessWidget {
  static const String route = '/ticketsHistoryPage';
  const TicketsHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Tickets History',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<TicketProvider>(context, listen: false)
              .fetchPastTickets();
          Provider.of<TicketProvider>(context, listen: false)
              .isPastTicketsFetchedSetter = true;
        },
        child: Consumer<TicketProvider>(
          builder: (BuildContext context, ticketProvider, _) {
            return ticketProvider.pastTickets.isEmpty
                ? const Center(
                    child: Text('No past tickets!'),
                  )
                : ListView.builder(
                    itemCount: ticketProvider.pastTickets.length,
                    itemBuilder: (ctx, index) => ListTile(
                      leading: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                ticketProvider.pastTickets[index].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(ticketProvider.pastTickets[index].name),
                      contentPadding: const EdgeInsets.all(8.0),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
