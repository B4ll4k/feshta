import 'dart:convert';

import 'package:feshta/models/env.dart';
import 'package:feshta/models/ticket.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class TicketProvider with ChangeNotifier {
  List<Ticket> _tickets = [];
  String token;
  bool _isPastTicketsFetched = false;
  bool _isActiveTicketsFetched = false;

  TicketProvider(this._tickets, this.token);

  Map<String, String> get headers => {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      };
  set isActiveTicketsFetchedSetter(bool isActiveTicketsFetched) {
    _isActiveTicketsFetched = isActiveTicketsFetched;
  }

  set isPastTicketsFetchedSetter(bool isPastTicketsFetched) {
    _isPastTicketsFetched = isPastTicketsFetched;
  }

  List<Ticket> get tickets {
    return [..._tickets];
  }

  List<Ticket> get activeTickets {
    return [...tickets.where((element) => element.isActive)];
  }

  List<Ticket> get pastTickets {
    return [..._tickets.where((element) => element.isPast)];
  }

  bool get isActiveTicketsFetched {
    return _isActiveTicketsFetched;
  }

  bool get isPastTicketsFetched {
    return _isPastTicketsFetched;
  }

  Future<void> fetchActiveTickets() async {
    try {
      final response = await http.post(
          Uri.parse(EnviromentVariables.baseUrl + 'api/ticket'),
          headers: headers);
      final responseData = jsonDecode(response.body) as List<dynamic>;
      if (responseData.isEmpty) {
        return;
      }
      for (var ticketData in responseData) {
        final t = ticketData as Map<String, dynamic>;
        _tickets.add(
          Ticket(
            id: t['id'].toString(),
            name: t['name'] ?? '',
            image: t['image'] ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUqjpYRNuYwypwqkCHVCrpTtRN_ij7b960Tw&usqp=CAU',
            description: t['description'] ?? '',
            quantity: int.parse(t['quantity'] ?? '0'),
            remaining: int.parse(t['remaining'] ?? '0'),
            qr: t['qr'] ?? '',
            location: t['location'] ?? '',
            start: DateTime.parse(t['start'].toString()),
            price: double.parse(t['price'] ?? '0'),
            hostName: t['host'] ?? '',
            isActive: true,
            isPast: false,
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }

  Future<void> fetchPastTickets() async {
    try {
      final response = await http.post(
          Uri.parse(EnviromentVariables.baseUrl + 'api/tickethistory'),
          headers: headers);
      final responseData = jsonDecode(response.body) as List<dynamic>;
      if (responseData.isEmpty) {
        return;
      }
      for (var ticketData in responseData) {
        final t = ticketData as Map<String, dynamic>;
        _tickets.add(
          Ticket(
            id: t['id'].toString(),
            name: t['name'] ?? '',
            image: t['image'] ??
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUqjpYRNuYwypwqkCHVCrpTtRN_ij7b960Tw&usqp=CAU',
            description: t['description'] ?? '',
            quantity: int.parse(t['quantity'] ?? '0'),
            remaining: int.parse(t['remaining'] ?? '0'),
            qr: t['qr'] ?? '',
            location: t['location'] ?? '',
            start: DateTime.parse(t['start'].toString()),
            price: double.parse(t['price'] ?? '0'),
            hostName: t['host'] ?? '',
            isActive: false,
            isPast: true,
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      print(e);
      notifyListeners();
    }
  }
}
