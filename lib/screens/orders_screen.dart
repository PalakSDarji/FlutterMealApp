import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/orders_provider.dart';
import 'package:flutter_meal_app/widgets/app_drawer.dart';
import 'package:flutter_meal_app/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ordersProvider.orders.length == 0
          ? Center(child: Text('No orders yet!'))
          : ListView.builder(
              itemCount: ordersProvider.orders.length,
              itemBuilder: (context, index) =>
                  OrderItemWidget(ordersProvider.orders[index]),
            ),
    );
  }
}
