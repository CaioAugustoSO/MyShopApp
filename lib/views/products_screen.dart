import 'package:flutter/material.dart';
import '../providers/products.dart';
import '../utils/app_routes.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsSreen extends StatelessWidget {
  Future<void> _refreshPage(BuildContext context) async {
    return Provider.of<Products>(context, listen: false).loadingProducts();
  }

  const ProductsSreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PRODUCTSFORM,
              );
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshPage(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productsData.itemsCount,
            itemBuilder: ((context, index) => Column(
                  children: [
                    ProductItem(products[index]),
                    Divider(),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
