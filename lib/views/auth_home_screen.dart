import 'package:flutter/material.dart';
import '/views/auth_screen.dart';
import '/views/products_overview_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

class AuthorHome extends StatelessWidget {
  const AuthorHome({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(child: Text('Ocorreu um erro!'));
        } else {
          return auth.isAuth ? ProductsOverviewScreen() : AuthScreen();
        }
      },
    );
  }
}
