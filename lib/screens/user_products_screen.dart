import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/products_provider.dart';
import 'package:flutter_meal_app/screens/add_edit_product_screen.dart';
import 'package:flutter_meal_app/widgets/app_drawer.dart';
import 'package:flutter_meal_app/widgets/user_product_item_widget.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    print(
        "productProvider in user_products_screen : ${productsProvider.items}");
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AddEditProductScreen.routeName);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: productsProvider.items.length == 0
            ? Center(child: Text('No Products available. Please add one.'))
            : ListView.builder(
                itemCount: productsProvider.items.length,
                itemBuilder: (_, index) {
                  return UserProductItemWidget(productsProvider.items[index]);
                },
              ),
      ),
    );
  }
}
