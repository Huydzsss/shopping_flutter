import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Thanh toán")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: cart.items.values.map((item) {
                return ListTile(
                  title: Text(item.product.name),
                  trailing: Text("${item.quantity} x ${item.product.price}"),
                );
              }).toList(),
            ),
          ),
          Text("Tổng cộng: ${cart.total.toStringAsFixed(2)} đ"),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Thanh toán thành công!")),
              );
              cart.clear();
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: const Text("Xác nhận thanh toán"),
          )
        ],
      ),
    );
  }
}
