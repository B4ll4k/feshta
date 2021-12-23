import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/cart_body.dart';
import '../utils/checkout_card.dart';
import '../providers/cart_provider.dart';

class CartPage extends StatefulWidget {
  static String routeName = "/cartPage";

  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<bool> fetchCart() async {
    if (!Provider.of<CartProvider>(context, listen: false).isCartFetched) {
      await Provider.of<CartProvider>(context, listen: false).fetchCarts();
      Provider.of<CartProvider>(context, listen: false).isCartFetchedSetter =
          true;
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchCart(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: buildAppBar(context),
              body: Provider.of<CartProvider>(context).carts.isEmpty
                  ? const Center(
                      child: Text('Cart is empty!'),
                    )
                  : const Body(),
              bottomNavigationBar: CheckoutCard(),
            );
          }
        });
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: Colors.black),
      title: Column(
        children: [
          const Text(
            "Your Cart",
            style: TextStyle(color: Colors.black),
          ),
          Text(
            "${Provider.of<CartProvider>(context).carts.length} items",
            style: Theme.of(context).textTheme.caption,
          ),
        ],
      ),
    );
  }
}
