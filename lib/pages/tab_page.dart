import 'package:feshta/pages/account_page.dart';
import 'package:feshta/pages/cart_page.dart';
import 'package:feshta/providers/artist_provider.dart';
import 'package:feshta/providers/cart_provider.dart';
import 'package:feshta/providers/event_provider.dart';
import 'package:feshta/providers/host_provider.dart';
import 'package:feshta/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './dashboard.dart';
import './artist_page.dart';
import './event_page.dart';
import './auth.dart';
import './host_page.dart';
import '../size_config.dart';

class TabPage extends StatefulWidget {
  static const String route = '/tabPage';
  const TabPage({Key? key}) : super(key: key);
  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  //String argument = '';
  int _selectedIndex = 0;
  bool isLoading = false;
  final List<Widget> _widgetOptions = [
    const MyHomePage(),
    const HostPage(),
    const EventPage(),
    ArtistPage(),
    Container()
  ];

  @override
  void initState() {
    if (Provider.of<UserProvider>(context, listen: false).isAuth) {
      if (!Provider.of<EventProvider>(context, listen: false)
          .isFavoriteFetched) {
        Provider.of<EventProvider>(context, listen: false).fetchFavorites();
        Provider.of<HostProvider>(context, listen: false).fetchFavorites();
        Provider.of<ArtistProvider>(context, listen: false).fetchFavorites();
        Provider.of<EventProvider>(context, listen: false)
            .isFavoriteFetchedSetter = true;
      }
      Future.delayed(Duration.zero);
    }
    super.initState();
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    _widgetOptions[4] = Provider.of<UserProvider>(context).isAuth
        ? const AccountPage()
        : const AuthScreen();
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: Provider.of<UserProvider>(context).isAuth
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cartPage');
              },
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            )
          : Container(),
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
    );
  }
}
