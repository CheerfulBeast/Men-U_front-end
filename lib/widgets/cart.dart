import 'package:flutter/material.dart';
import 'package:men_u/order.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return Order();
        }));
      },
      icon: const Icon(Icons.shopping_cart_checkout),
    );
  }
}
