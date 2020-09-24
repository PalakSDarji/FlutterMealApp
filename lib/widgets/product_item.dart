import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/cart_provider.dart';
import 'package:flutter_meal_app/providers/product.dart';
import 'package:flutter_meal_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final Function onFavChange;

  ProductItem(this.onFavChange);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    print("prouctid : ${product.id} , ${product.isFavorite}");
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      elevation: 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: product.id);
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: Consumer<Product>(
              builder: (context, value, _) => IconButton(
                icon: Icon(
                    value.isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  product.toggleFavorite();
                  onFavChange();
                },
                color: Theme.of(context).accentColor,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product.id, product.price, product.title);
              },
              color: Theme.of(context).accentColor,
            ),
            backgroundColor: Colors.black87,
            title: Text(
              '${product.title}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
