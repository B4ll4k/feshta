import 'package:feshta/pages/artist_page.dart';
import 'package:feshta/pages/dashboard.dart';
import 'package:feshta/pages/event_page.dart';
import 'package:feshta/pages/host_page.dart';
import 'package:feshta/pages/account_page.dart';
import 'package:feshta/scoped-models/main.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  MainModel model = MainModel();
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const MyHomePage(),
    const HostPage(),
    EventPage(),
    const ArtistPage(),
    const AccountPage()
  ];
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: model,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: _widgetOptions.elementAt(_selectedIndex),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            //backgroundColor: Color(0xB2B2B2),
            selectedItemColor: const Color(0xFF4F2EAC),
            unselectedItemColor: Colors.black45,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                  backgroundColor: Color(0xFFF7F7F7)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.houseboat),
                  label: "Host",
                  backgroundColor: Color(0xFFF7F7F7)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.event_note_sharp),
                  label: "Event",
                  backgroundColor: Color(0xFFF7F7F7)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.mic_external_on),
                  label: "Artist",
                  backgroundColor: Color(0xFFF7F7F7)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.manage_accounts),
                  label: "Account",
                  backgroundColor: Color(0xFFF7F7F7)),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTap,
          ),
        ),
      ),
    );
  }
}
