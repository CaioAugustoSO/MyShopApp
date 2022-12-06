import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myshop/data/store.dart';
import 'package:myshop/exceptions/auth_exception.dart';

class Auth with ChangeNotifier {
  Timer? _logoutTimer;
  String? _userId;
  DateTime? _expireDate;
  String? _token;

  String? get userId {
    return isAuth ? _userId : null;
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_token != null &&
        _expireDate != null &&
        _expireDate!.isAfter(DateTime.now())) {
      return _token;
    } else {
      return null;
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCrvhOs0oVhLiF9cY_UvRUvsO8KcGReAyY';

    final response = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );
    final responseBody = json.decode(response.body);
    if (responseBody["error"] != null) {
      throw AuthException(responseBody['error']['message']);
    } else {
      _token = responseBody["idToken"];
      _userId = responseBody["localId"];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody["expiresIn"]),
        ),
      );
      Store.saveMap('userData', {
        "token": _token,
        "userId": _userId,
        "expireDate": _expireDate!.toIso8601String(),
      });

      _autologout();
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) {
      return Future.value();
    }
    final userData = await Store.getMap('userData');
    if (userData == null) {
      return Future.value();
    }
    final expireDate = DateTime.parse(userData["expireDate"]);

    if (expireDate.isBefore(DateTime.now())) {
      return Future.value();
    }
    _userId = userData["userId"];
    _token = userData["token"];
    _expireDate = expireDate;

    _autologout();
    notifyListeners();
    Future.value();
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  void logout() {
    _token = null;
    _userId = null;
    _expireDate = null;
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
      _logoutTimer = null;
    }
    Store.remove('userData');
    notifyListeners();
  }

  void _autologout() {
    if (_logoutTimer != null) {
      _logoutTimer!.cancel();
    }
    final timetoLogout = _expireDate!.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timetoLogout), logout);
  }
}
