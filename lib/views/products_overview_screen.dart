import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/utils/app_routes.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:myshop/widgets/badge.dart';
import 'package:provider/provider.dart';
import '../widgets/product_grid.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen();

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha loja'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Somente favoritos'),
                value: FilterOptions.Favorite,
              ),
              PopupMenuItem(
                child: Text('Todos'),
                value: FilterOptions.All,
              )
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.CART);
                },
                icon: Icon(Icons.shopping_cart)),
            builder: (ctx, cart, child) => Badge(
              child: child,
              value: cart.itemCount.toString(),
              color: Theme.of(context).accentColor,
            ),
          )
        ],
      ),
      body: ProductGrid(_showFavoriteOnly),
      drawer: AppDrawer(),
    );
  }
}
