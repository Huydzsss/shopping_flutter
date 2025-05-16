import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Giỏ hàng")),
      body: cart.items.isEmpty
          ? const Center(child: Text("Giỏ hàng trống"))
          : Column(
        children: [
          Expanded(
            child: ListView(
              children: cart.items.values.map((item) {
                return ListTile(
                  leading: Image.network(item.product.imageUrl),
                  title: Text(item.product.name),
                  subtitle: Text("${item.product.price} đ"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => cart.decrease(item.product.id),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cart.increase(item.product.id),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          Text("Tổng: ${cart.total.toStringAsFixed(2)} đ"),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CheckoutPage()));
            },
            child: const Text("Tiến hành thanh toán"),
          )
        ],
      ),
    );
  }
}
