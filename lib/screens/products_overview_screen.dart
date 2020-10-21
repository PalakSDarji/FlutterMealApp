import 'package:flutter/material.dart';
import 'package:flutter_meal_app/api/result/network_exceptions.dart';
import 'package:flutter_meal_app/api/result/network_exceptions.dart';
import 'package:flutter_meal_app/api/result/network_exceptions.dart';
import 'package:flutter_meal_app/api/result/network_exceptions.dart';
import 'package:flutter_meal_app/providers/cart_provider.dart';
import 'package:flutter_meal_app/providers/products_provider.dart';
import 'package:flutter_meal_app/screens/cart_screen.dart';
import 'package:flutter_meal_app/widgets/app_drawer.dart';
import 'package:flutter_meal_app/widgets/badge.dart';
import 'package:flutter_meal_app/widgets/products_grid.dart';
import 'package:provider/provider.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/product-overview';

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isDataLoading = false;
  var _isInit = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isDataLoading = true;
      });
      Provider.of<ProductsProvider>(context, listen: false)
          .fetchAndSetProducts()
          .catchError((error) {
        print(error);
        final errorMsg = NetworkExceptions.getDioException(error);
        if (errorMsg is UnexpectedError) {
          //dont show anything.
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('${NetworkExceptions.getErrorMessage(errorMsg)}')));
        }
        //Show some kind of error reporting to User in UI way.
      }).whenComplete(() {
        setState(() {
          _isDataLoading = false;
        });
      });
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('MyShop'),
          actions: [
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: Icon(Icons.shopping_cart),
              ),
            ),
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text("Only Favorites"),
                  value: FilterOptions.Favorites,
                ),
                PopupMenuItem(
                  child: Text("Show All"),
                  value: FilterOptions.All,
                ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            _isDataLoading
                ? LinearProgressIndicator(
                    minHeight: 4,
                    backgroundColor: Colors.white,
                  )
                : SizedBox(
                    height: 4,
                  ),
            Expanded(child: Container(child: ProductsGrid(_showOnlyFavorites))),
          ],
        ));
  }
}
