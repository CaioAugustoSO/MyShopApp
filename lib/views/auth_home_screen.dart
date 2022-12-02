import 'package:flutter/material.dart';
import 'package:myshop/views/auth_screen.dart';
import 'package:myshop/views/products_overview_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AuthorHome extends StatelessWidget {
  const AuthorHome({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuth ? ProductsOverviewScreen() : AuthScreen();
  }
}
