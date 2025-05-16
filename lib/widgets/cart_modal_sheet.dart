import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../pages/checkout_page.dart';

class CartModalSheet extends StatelessWidget {
  const CartModalSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        children: [
          const Text(
            "Giỏ hàng của bạn",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: cart.items.isEmpty
                ? const Center(child: Text("Chưa có sản phẩm nào"))
                : ListView(
              children: cart.items.values.map((item) {
                return ListTile(
                  leading: Image.network(item.product.imageUrl, width: 40),
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
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tổng:", style: Theme.of(context).textTheme.titleMedium),
              Text("${cart.total.toStringAsFixed(2)} đ",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Đóng modal
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CheckoutPage()),
              );
            },
            child: const Text("Tiến hành thanh toán"),
          ),
        ],
      ),
    );
  }
}
