import 'dart:io';
import 'package:feshta/models/cart.dart';
import 'package:feshta/pages/cart_page.dart';
import 'package:feshta/pages/categories_page.dart';
import 'package:feshta/pages/dashboard.dart';
import 'package:feshta/pages/event_filter_page.dart';
import 'package:feshta/pages/event_page.dart';
import 'package:feshta/pages/events_filtered_page.dart';
import 'package:feshta/pages/favorite_page.dart';
import 'package:feshta/pages/host_page.dart';
import 'package:feshta/pages/account_page.dart';
import 'package:feshta/pages/see_all_page.dart';
import 'package:feshta/pages/splash_screen.dart';
import 'package:feshta/pages/tab_page.dart';
import 'package:feshta/pages/tickets_history_page.dart';
import 'package:feshta/pages/tickets_page.dart';
import 'package:feshta/pages/update_profile_page.dart';
import 'package:feshta/providers/artist_provider.dart';
import 'package:feshta/providers/cart_provider.dart';
import 'package:feshta/providers/event_provider.dart';
import 'package:feshta/providers/host_provider.dart';
import 'package:feshta/providers/ticket_provider.dart';
import 'package:feshta/providers/user_provider.dart';
import 'package:feshta/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      );
    }
  }

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
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProxyProvider<UserProvider, CartProvider>(
          //ChangeNotifierProvider<CartProvider>(
          create: (context) => CartProvider([], '', false),
          update: (context, userProvider, previousCartProvider) => CartProvider(
              previousCartProvider == null ? [] : previousCartProvider.carts,
              userProvider.token ?? '',
              previousCartProvider == null
                  ? false
                  : previousCartProvider.isCartFetched),
        ),
        ChangeNotifierProxyProvider<UserProvider, EventProvider>(
          //ChangeNotifierProvider<EventProvider>(
          create: (context) => EventProvider([], [], [], '', false),
          update: (ctx, userProvider, previousEventProvider) => EventProvider(
              previousEventProvider == null ||
                      previousEventProvider.events.isEmpty
                  ? []
                  : previousEventProvider.events,
              previousEventProvider == null ||
                      previousEventProvider.dates.isEmpty
                  ? []
                  : previousEventProvider.dates,
              previousEventProvider == null ||
                      previousEventProvider.eventCategories.isEmpty
                  ? []
                  : previousEventProvider.eventCategories,
              userProvider.token ?? '',
              previousEventProvider == null
                  ? false
                  : previousEventProvider.isFavoriteFetched),
        ),
        ChangeNotifierProxyProvider<UserProvider, HostProvider>(
          //ChangeNotifierProvider<HostProvider>(
          create: (_) => HostProvider([], '', false),
          update: (context, userProvider, previousHostProvider) => HostProvider(
              previousHostProvider == null || previousHostProvider.hosts.isEmpty
                  ? []
                  : previousHostProvider.hosts,
              userProvider.token ?? '',
              previousHostProvider == null
                  ? false
                  : previousHostProvider.isFavoriteFetched),
        ),
        ChangeNotifierProxyProvider<UserProvider, ArtistProvider>(
          //ChangeNotifierProvider<ArtistProvider>(
          create: (context) => ArtistProvider([], '', false),
          update: (ctx, userProvider, previousArtistProvider) => ArtistProvider(
              previousArtistProvider == null ||
                      previousArtistProvider.artists.isEmpty
                  ? []
                  : previousArtistProvider.artists,
              userProvider.token ?? '',
              previousArtistProvider == null
                  ? false
                  : previousArtistProvider.isFavoriteFetched),
        ),
        ChangeNotifierProxyProvider<UserProvider, TicketProvider>(
          //ChangeNotifierProvider<TicketProvider>(
          create: (context) => TicketProvider([], ''),
          update: (ctx, userProvider, previousTicketProvider) => TicketProvider(
              previousTicketProvider == null
                  ? []
                  : previousTicketProvider.tickets,
              userProvider.token ?? ''),
        ),
      ],
      child: MaterialApp(
        title: 'Feshta',
        theme: theme(),
        home: SplashScreen(),
        routes: {
          MyHomePage.homePageRoute: (ctx) => const MyHomePage(),
          SeeAllPage.seeAllPageRoute: (ctx) => SeeAllPage(),
          CategoriesPage.route: (ctx) => const CategoriesPage(),
          TabPage.route: (ctx) => const TabPage(),
          FavoritePage.route: (ctx) => const FavoritePage(),
          TicketsPage.route: (ctx) => TicketsPage(),
          TicketsHistoryPage.route: (ctx) => const TicketsHistoryPage(),
          CartPage.routeName: (ctx) => const CartPage(),
          EditProfilePage.route: (ctx) => const EditProfilePage(),
          EventFilterPage.route: (ctx) => EventFilterPage(),
          EventsFilteredPage.route: (ctx) => const EventsFilteredPage(),
        },
      ),
    );
  }
}
