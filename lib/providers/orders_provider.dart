import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/cart_provider.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> products, double total) {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            amount: total,
            products: products,
            dateTime: DateTime.now()));
    notifyListeners();
  }

}
