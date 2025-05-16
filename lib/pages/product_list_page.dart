import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_modal_sheet.dart';
import '../pages/product_detail_page.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as custom_badge;

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Product>> futureProducts;

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://6826e617397e48c91317ab47.mockapi.io/api/v1/product'));
    if (response.statusCode == 200) {
      List list = json.decode(response.body);
      return list.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load');
    }
  }

  @override
  void initState() {
    futureProducts = fetchProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách sản phẩm"),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) {
              return IconButton(
                icon: custom_badge.Badge(
                  badgeContent: Text(
                    cart.items.length.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  showBadge: cart.items.isNotEmpty,
                  child: const Icon(Icons.shopping_cart),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (context) => const CartModalSheet(),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1/1.5,

              ),

              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final product = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(4), // Add padding around the image
                            child: Image.network(
                              product.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 150, // Set a maximum height for the image
                            ),
                          ),
                        ),
                        Text(product.name),
                        Text('${product.price} đ'),
                        ElevatedButton(
                          onPressed: () => cart.add(product),
                          child: const Text('Thêm vào giỏ'),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}