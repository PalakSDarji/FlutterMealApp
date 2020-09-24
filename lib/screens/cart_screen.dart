import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/cart_provider.dart';
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
                          '\$ ${cart.totalAmount.toString()}',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .headline6
                                  .color),
                        ),
                      ),
                      SizedBox(width: 5),
                      FlatButton(
                        onPressed: () {},
                        child: Text('ORDER NOW'),
                        textColor: Theme.of(context).primaryColor,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              ListView.builder(
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
