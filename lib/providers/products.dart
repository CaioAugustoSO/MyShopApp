import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myshop/data/dummy_data.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  List<Product> get favoriteitems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  void addProduct(Product newProduct) {
    _items.add(Product(
        id: Random().nextDouble().toString(),
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
