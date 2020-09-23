import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<ProductsProvider>(context, listen: false).findProductById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.id),
      ),
    );
  }
}
