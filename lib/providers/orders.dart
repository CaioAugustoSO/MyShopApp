import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    required this.id,
    required this.total,
    required this.products,
    required this.date,
  });
}

class Orders with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemscount {
    return _items.length;
  }

  void addOrders(List<CartItem> products, double total) {
    final combine = (t, i) => t + (i.price * i.quantity);
    final total = products.fold(0.0, combine);
    _items.insert(
      0,
      Order(
        id: Random().nextDouble().toString(),
        total: total,
        products: products,
        date: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
