import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../size_config.dart';
import 'cart_card.dart';
import '../providers/cart_provider.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Consumer<CartProvider>(
        builder: (context, cartProvider, _) => ListView.builder(
          itemCount: cartProvider.carts.length,
          itemBuilder: (ctx, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Dismissible(
              key: Key(cartProvider.carts[index].ticketId),
              direction: DismissDirection.endToStart,
              onDismissed: (_) async {
                await Provider.of<CartProvider>(context, listen: false)
                    .removeOrder(cartProvider.carts[index].ticketId);
              },
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE6E6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: const [
                    Spacer(),
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              child: CartCard(cart: cartProvider.carts[index]),
            ),
          ),
        ),
      ),
    );
  }
}
