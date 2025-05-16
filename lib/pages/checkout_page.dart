import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../utils/pdf_invoice.dart';
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Xác nhận thanh toán")),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = cart.items.values.toList()[index];
                return ListTile(
                  leading: Image.network(
                    item.product.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(item.product.name),
                  subtitle: Text(
                    "Đơn giá: ${item.product.price.toStringAsFixed(2)} đ\nSố lượng: ${item.quantity}",
                  ),
                  trailing: Text(
                    "Tổng: ${(item.product.price * item.quantity).toStringAsFixed(2)} đ",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ),
          const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tổng cộng:",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(
                  "${cart.total.toStringAsFixed(2)} đ",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.picture_as_pdf),
                  label: Text('Xuất hóa đơn PDF'),
                  onPressed: () async {
                    final pdf = await generateInvoice(cart);
                    await exportPdf(pdf);
                  },
                ),

                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Xác nhận thanh toán"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Thanh toán thành công!")),
                    );
                    cart.clear();
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
