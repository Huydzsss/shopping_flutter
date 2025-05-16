import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(product.imageUrl, height: 200),
            const SizedBox(height: 16),
            Text(product.name, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 10),
            Text("${product.price} đ", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text("Chi tiết sản phẩm sẽ được bổ sung sau...", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
