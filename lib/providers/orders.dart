import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/providers/cart.dart';

import '../utils/constants.dart';

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
  String? _token;
  String? _userId;

  Orders([this._token, this._userId, this._items = const []]);
  final String _baseUrl = '${Constants.BASE_API_URL}/orders';
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemscount {
    return _items.length;
  }

  Future<void> loadingOrders() async {
    List<Order> loadedItems = [];
    final response = await http.get("$_baseUrl/$_userId.json?auth=$_token");
    Map<String, dynamic> data = jsonDecode(response.body);
    loadedItems.clear();
    if (data != null) {
      data.forEach((orderId, orderData) {
        loadedItems.add(Order(
          id: orderId,
          total: orderData['total'],
          date: DateTime.parse(orderData['date']),
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price'],
                productId: item['productId']);
          }).toList(),
        ));
      });
      _items = loadedItems.reversed.toList();
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> addOrders(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      '$_baseUrl/$_userId.json?auth=$_token',
      body: json.encode(
        {
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.items.values
              .map((cartitem) => {
                    'id': cartitem.id,
                    'title': cartitem.title,
                    'productId': cartitem.productId,
                    'quantity': cartitem.quantity,
                    'price': cartitem.price,
                  })
              .toList()
        },
      ),
    );
    _items.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        total: cart.totalAmount,
        products: cart.items.values.toList(),
        date: date,
      ),
    );
    notifyListeners();
  }
}
