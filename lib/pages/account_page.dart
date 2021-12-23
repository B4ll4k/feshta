import 'package:feshta/providers/artist_provider.dart';
import 'package:feshta/providers/event_provider.dart';
import 'package:feshta/providers/host_provider.dart';
import 'package:feshta/providers/ticket_provider.dart';
import 'package:feshta/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AccountPage();
  }
}

class _AccountPage extends State<AccountPage> {
  bool _isLoadingFav = false;
  bool _isLoadingTick = false;
  bool _isLoadingHis = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Text(
          'Account',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/banner.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                '${Provider.of<UserProvider>(context).user.firstName.isEmpty ? 'John' : Provider.of<UserProvider>(context).user.firstName} ${Provider.of<UserProvider>(context).user.lastName.isEmpty ? 'Doe' : Provider.of<UserProvider>(context).user.lastName}',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            _buildUserOptions(),
            const SizedBox(
              height: 35,
            ),
            _buildSettingsTile(),
            const SizedBox(
              height: 20,
            ),
            _buildAboutTile(),
            const SizedBox(
              height: 55,
            ),
            _buildLogOutBtn(),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserOptions() {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              IconButton(
                  onPressed: () async {
                    // setState(() {
                    //   _isLoadingFav = true;
                    // });
                    // if (!Provider.of<EventProvider>(context, listen: false)
                    //     .isFavoriteFetched) {
                    //   try {
                    //     await Provider.of<EventProvider>(context, listen: false)
                    //         .fetchFavorites();
                    //     Provider.of<EventProvider>(context, listen: false)
                    //         .isFavoriteFetchedSetter = true;
                    //   } catch (e) {
                    //     print(e.toString());
                    //   }
                    // }
                    // if (!Provider.of<HostProvider>(context, listen: false)
                    //     .isFavoriteFetched) {
                    //   try {
                    //     await Provider.of<HostProvider>(context, listen: false)
                    //         .fetchFavorites();
                    //     Provider.of<HostProvider>(context, listen: false)
                    //         .isFavoriteFetchedSetter = true;
                    //   } catch (e) {
                    //     print(e.toString());
                    //   }
                    // }
                    // if (!Provider.of<ArtistProvider>(context, listen: false)
                    //     .isFavoriteFetched) {
                    //   try {
                    //     await Provider.of<ArtistProvider>(context,
                    //             listen: false)
                    //         .fetchFavorites();
                    //     Provider.of<ArtistProvider>(context, listen: false)
                    //         .isFavoriteFetchedSetter = true;
                    //   } catch (e) {
                    //     print(e.toString());
                    //   }
                    // }
                    // setState(() {
                    //   _isLoadingFav = false;
                    // });
                    Navigator.pushNamed(context, '/favoritePage');
                  },
                  icon: _isLoadingFav
                      ? const CircularProgressIndicator()
                      : Icon(
                          Icons.favorite,
                          color: Theme.of(context).primaryColor,
                          size: 35,
                        )),
              Text(
                'Favorites',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          VerticalDivider(
            color: Theme.of(context).primaryColor,
          ),
          Column(
            children: [
              IconButton(
                  onPressed: () async {
                    setState(() {
                      _isLoadingTick = true;
                    });
                    if (!Provider.of<TicketProvider>(context, listen: false)
                        .isActiveTicketsFetched) {
                      try {
                        await Provider.of<TicketProvider>(context,
                                listen: false)
                            .fetchActiveTickets();
                        Provider.of<TicketProvider>(context, listen: false)
                            .isActiveTicketsFetchedSetter = true;
                      } catch (e) {
                        print(e.toString());
                      }
                    }
                    setState(() {
                      _isLoadingTick = false;
                    });
                    Navigator.pushNamed(context, '/ticketsPage');
                  },
                  icon: _isLoadingTick
                      ? const CircularProgressIndicator()
                      : Icon(
                          FontAwesomeIcons.ticketAlt,
                          color: Theme.of(context).primaryColor,
                          size: 35,
                        )),
              Text(
                'Tickets',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          VerticalDivider(
            color: Theme.of(context).primaryColor,
          ),
          Column(
            children: [
              IconButton(
                  onPressed: () async {
                    setState(() {
                      _isLoadingHis = true;
                    });
                    if (!Provider.of<TicketProvider>(context, listen: false)
                        .isPastTicketsFetched) {
                      try {
                        await Provider.of<TicketProvider>(context,
                                listen: false)
                            .fetchPastTickets();
                        Provider.of<TicketProvider>(context, listen: false)
                            .isPastTicketsFetchedSetter = true;
                      } catch (e) {
                        print(e.toString());
                      }
                    }
                    setState(() {
                      _isLoadingHis = false;
                    });
                    Navigator.pushNamed(context, '/ticketsHistoryPage');
                  },
                  icon: _isLoadingHis
                      ? const CircularProgressIndicator()
                      : Icon(
                          Icons.history,
                          color: Theme.of(context).primaryColor,
                          size: 35,
                        )),
              Text(
                'History',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.6),
                    fontWeight: FontWeight.w600),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSettingsTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            'Setting',
            style: TextStyle(
                fontSize: 21,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w500),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.account_circle_outlined,
            color: Theme.of(context).primaryColor,
            size: 27,
          ),
          title: Text(
            'Update Profile',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w500),
          ),
          onTap: () {
            Navigator.pushNamed(context, '/editProfilePage');
          },
          hoverColor: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
        Divider(
          color: Theme.of(context).primaryColor,
          indent: 50,
        ),
      ],
    );
  }

  Widget _buildAboutTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'About',
            style: TextStyle(
                fontSize: 21,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w500),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.verified_user_outlined,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          title: Text(
            'Version',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w500),
          ),
          trailing: Text(
            '2.0',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w500),
          ),
          onTap: () {},
          hoverColor: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
        Divider(
          color: Theme.of(context).primaryColor,
          indent: 60,
        ),
        ListTile(
          leading: Icon(
            Icons.privacy_tip_outlined,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          title: Text(
            'Privacy',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w500),
          ),
          onTap: () {},
          hoverColor: Theme.of(context).primaryColor.withOpacity(0.2),
        ),
        Divider(
          color: Theme.of(context).primaryColor,
          indent: 60,
        ),
        ListTile(
          leading: Icon(
            Icons.app_registration_outlined,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
          title: Text(
            'Terms of Service',
            style: TextStyle(
                fontSize: 18,
                color: Colors.black.withOpacity(0.7),
                fontWeight: FontWeight.w500),
          ),
          onTap: () {},
        ),
        Divider(
          color: Theme.of(context).primaryColor,
          indent: 60,
        ),
      ],
    );
  }

  Widget _buildLogOutBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      width: double.infinity,
      height: 35,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => Theme.of(context).primaryColor)),
          onPressed: () {
            Provider.of<UserProvider>(context, listen: false).logOut();
          },
          child: const Text(
            'LogOut',
            style: TextStyle(color: Colors.white, fontSize: 16),
          )),
    );
  }
}
