import 'package:flutter/material.dart';
import 'package:myshop/widgets/order_widget.dart';
import 'package:provider/provider.dart';

import '../widgets/app_drawer.dart';

import '../providers/orders.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Orders orders = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus pedidos'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index) => OrderWidget(
          order: orders.items[index],
        ),
        itemCount: orders.itemscount,
      ),
    );
  }
}
