import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imgURL;
  bool isFavorite;

  Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imgURL,
    this.isFavorite = false,
  });
  void _toggleFavorite() {
    _toggleFavorite();
  }

  Future<void> toggleFavorte() async {
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final url = '${Constants.BASE_API_URL}/products/$id.json';

      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (error) {
      _toggleFavorite();
    }
  }
}
