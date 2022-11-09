import 'package:flutter/material.dart';
import 'package:myshop/data/dummy_data.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  List<Product> get favoriteitems {
    return _items.where((prod) => prod.isFavorite).toList();
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
