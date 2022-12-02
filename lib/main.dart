import 'package:flutter/material.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';

import './views/auth_home_screen.dart';
import './views/auth_screen.dart';
import './views/products_form_screen.dart';
import './views/products_screen.dart';
import './views/cart_screen.dart';
import './views/product_detail_screen.dart';
import './views/products_overview_screen.dart';
import './views/orders_screen.dart';

import './utils/app_routes.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Orders(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Auth(),
        ),
      ],
      child: MaterialApp(
        title: 'Minha Loja',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          AppRoutes.PRODUCT_DETAIl: (ctx) => ProductDetailScreen(),
          AppRoutes.CART: (ctx) => CartScreen(),
          AppRoutes.ORDERS: (ctx) => OrderScreen(),
          AppRoutes.PRODUCTS: (ctx) => ProductsSreen(),
          AppRoutes.PRODUCTSFORM: (ctx) => ProductsFormScreen(),
          AppRoutes.AUTH_HOME: (context) => AuthorHome(),
        },
        // home: ProductsOverviewScreen(),
      ),
    );
  }
}
