import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myshop/exceptions/http_exception.dart';
import 'package:myshop/utils/constants.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final String _baseUrl = '${Constants.BASE_API_URL}/products';
  List<Product> _items = [];

  List<Product> get items => [..._items];

  List<Product> get favoriteitems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Future<void> loadingProducts() async {
    final response = await http.get("$_baseUrl.json");
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
      "$_baseUrl.json",
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

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return;
    }
    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch(
        "$_baseUrl/${product.id}.json",
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imgURL': product.imgURL,
        }),
      );
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();
      final response = await http.delete("$_baseUrl/${product.id}.json");
      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do produto');
      }
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
