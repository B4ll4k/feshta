import 'dart:convert';
import 'package:feshta/providers/ticket_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TicketsPage extends StatefulWidget {
  static const String route = '/ticketsPage';

  TicketsPage({Key? key}) : super(key: key);

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  void _showTicketQRCode(String code) async {
    Image image = Image.memory(base64Decode(code.substring(22)));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('QR Code'),
        // content: QrImage(
        //   data: code,
        //   version: QrVersions.auto,
        //   size: 200.0,
        // ),
        content: Container(
          width: 230,
          height: 230,
          child: image,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Tickets',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<TicketProvider>(context, listen: false)
              .fetchActiveTickets();
          Provider.of<TicketProvider>(context, listen: false)
              .isActiveTicketsFetchedSetter = true;
        },
        child: Consumer<TicketProvider>(
          builder: (BuildContext context, ticketProvider, _) {
            return ticketProvider.activeTickets.isEmpty
                ? const Center(
                    child: Text('No active tickets!'),
                  )
                : ListView.builder(
                    itemCount: ticketProvider.activeTickets.length,
                    itemBuilder: (ctx, index) => ListTile(
                      onTap: () {
                        _showTicketQRCode(ticketProvider.tickets[index].qr);
                      },
                      leading: Container(
                        height: 50,
                        width: 40,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                ticketProvider.activeTickets[index].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(ticketProvider.activeTickets[index].name),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
