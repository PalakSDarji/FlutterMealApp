import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/product.dart';
import 'package:flutter_meal_app/providers/products_provider.dart';
import 'package:flutter_meal_app/screens/add_edit_product_screen.dart';
import 'package:flutter_meal_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class UserProductItemWidget extends StatelessWidget {
  final Product product;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  UserProductItemWidget(this.product, this._scaffoldKey);

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);

    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          title: Text(product.title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(product.imageUrl),
          ),
          trailing: Container(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        AddEditProductScreen.routeName,
                        arguments: product);
                  },
                  color: Theme.of(context).primaryColor,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    productsProvider.deleteProduct(product).catchError((error) {
                      showDialog(
                          context: _scaffoldKey.currentContext,
                          builder: (context) => AlertDialog(
                                title: Text('An error occurred!'),
                                content: Text(error.toString()),
                                actions: [
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Okay'))
                                ],
                              ));
                    });
                  },
                  color: Theme.of(context).errorColor,
                ),
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
