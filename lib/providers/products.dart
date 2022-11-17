import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  final String _url =
      'https://flutter-335de-default-rtdb.firebaseio.com/products.json';
  List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteitems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> loadingProducts() async {
    final response = await http.get(_url);
    Map<String, dynamic> data = jsonDecode(response.body);
    _items.clear();
    if (data != null) {
      data.forEach((id, productData) {
        _items.add(Product(
          id: id,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imgURL: productData['imgURL'],
          isFavorite: productData['isFavorite'],
        ));
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addProduct(Product newProduct) async {
    final response = await http.post(
      _url,
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imgURL': newProduct.imgURL,
        'isFavorite': newProduct.isFavorite
      }),
    );
    _items.add(Product(
        id: json.decode(response.body)['name'],
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imgURL: newProduct.imgURL));
    notifyListeners();
  }

  void updateProduct(Product product) {
    if (product == null || product.id == null) {
      return;
    }
    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }

  int get itemsCount {
    return _items.length;
  }
}
  // bool _showFavoriteonly = false;
  // void showFavoriteonly() {
  //   _showFavoriteonly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteonly = false;
  //   notifyListeners();
  // }

  // void addProduct(Product product) {
  //   _items.add(product);
  //   notifyListeners();
  // }
