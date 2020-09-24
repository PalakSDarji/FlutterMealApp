import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/product.dart';
import 'package:flutter_meal_app/providers/products_provider.dart';
import 'package:flutter_meal_app/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatefulWidget {
  final bool showOnlyFavorites;

  ProductsGrid(this.showOnlyFavorites);

  @override
  _ProductsGridState createState() => _ProductsGridState();
}

class _ProductsGridState extends State<ProductsGrid> {
  ProductsProvider productsData;
  List<Product> loadedProducts;

  Function onFavChange() {
    setState(() {
      loadedProducts = widget.showOnlyFavorites
          ? productsData.favoriteItems
          : productsData.items;
    });
  }

  @override
  Widget build(BuildContext context) {
    productsData = Provider.of<ProductsProvider>(context);
    loadedProducts = widget.showOnlyFavorites
        ? productsData.favoriteItems
        : productsData.items;

    return loadedProducts.isEmpty
        ? Center(child: Text('No data'))
        : GridView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: loadedProducts.length,
            itemBuilder: (context, index) {
              return ChangeNotifierProvider<Product>.value(
                value: loadedProducts[index],
                child: ProductItem(onFavChange),
              );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10),
          );
  }
}
