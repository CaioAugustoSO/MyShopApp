import 'package:flutter/material.dart';
import 'package:myshop/data/dummy_data.dart';

import '../models/products.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
