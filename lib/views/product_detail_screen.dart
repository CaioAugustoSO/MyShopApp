import 'package:flutter/material.dart';
import 'package:myshop/providers/product.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imgURL,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('R\$${product.price}',
                style: TextStyle(color: Colors.grey, fontSize: 20)),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
            )
          ],
        ),
      ),
    );
  }
}
