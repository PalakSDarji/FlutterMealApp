import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartItemWidget extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;

  CartItemWidget({this.id, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {

    final cartProvider = Provider.of<Cart>(context, listen: false);

    return Dismissible(
      key: ValueKey(id),
      onDismissed: (direction) => cartProvider.removeItem(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('\$${price.toStringAsFixed(2)}',
                      textAlign: TextAlign.center),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
