import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/product_list_page.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Demo',
      theme: ThemeData(useMaterial3: true),
      home: const ProductListPage(),
    );
  }
}
