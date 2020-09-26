import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/cart_provider.dart';
import 'package:flutter_meal_app/providers/orders_provider.dart';
import 'package:flutter_meal_app/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your cart'),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontSize: 20)),
                      Spacer(),
                      SizedBox(width: 20),
                      Chip(
                        backgroundColor: Theme.of(context).primaryColor,
                        label: Text(
                          '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .color),
                        ),
                      ),
                      SizedBox(width: 5),
                      FlatButton(
                        onPressed: () {
                          Provider.of<OrdersProvider>(context, listen: false)
                              .addOrder(cart.items, cart.totalAmount);
                          cart.clearCart();
                        },
                        child: Text('ORDER NOW'),
                        textColor: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              cart.items.length == 0
                  ? Flexible(
                      fit: FlexFit.loose,
                      child:
                          Center(child: Text('Cart is empty. Buy something.')))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cart.items.length,
                      itemBuilder: (context, index) {
                        var cartItem = cart.items[index];
                        return CartItemWidget(
                            id: cartItem.id,
                            title: cartItem.title,
                            price: cartItem.price,
                            quantity: cartItem.quantity);
                      }),
              SizedBox(height: 10),
            ],
          ),
        ));
  }
}
