import 'package:flutter/material.dart';
import 'package:myshop/models/products.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen();

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
    );
  }
}
