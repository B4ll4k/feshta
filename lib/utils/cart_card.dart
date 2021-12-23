import 'package:feshta/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: EdgeInsets.all(getProportionateScreenWidth(10)),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(cart.image),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cart.name,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text.rich(
                  TextSpan(
                    text: "\$${cart.price}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .modifyQuantityCart(cart.ticketId, false);
                    },
                    icon: const Icon(Icons.chevron_left)),
                Text(cart.quantity.toString()),
                IconButton(
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false)
                          .modifyQuantityCart(cart.ticketId, true);
                    },
                    icon: const Icon(Icons.chevron_right))
              ],
            ),
          ],
        )
      ],
    );
  }
}
