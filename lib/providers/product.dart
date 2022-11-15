import 'package:flutter/foundation.dart';

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
  void toggleFavorte() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
