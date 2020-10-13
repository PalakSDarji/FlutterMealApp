import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/auth_provider.dart';
import 'package:flutter_meal_app/providers/cart_provider.dart';
import 'package:flutter_meal_app/providers/orders_provider.dart';
import 'package:flutter_meal_app/providers/products_provider.dart';
import 'package:flutter_meal_app/screens/add_edit_product_screen.dart';
import 'package:flutter_meal_app/screens/auth_screen.dart';
import 'package:flutter_meal_app/screens/cart_screen.dart';
import 'package:flutter_meal_app/screens/orders_screen.dart';
import 'package:flutter_meal_app/screens/product_detail_screen.dart';
import 'package:flutter_meal_app/screens/products_overview_screen.dart';
import 'package:flutter_meal_app/screens/user_products_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (context) => ProductsProvider(),
          update: (context, authProvider, previousProductsProvider) {
            previousProductsProvider.authToken = authProvider.token;
            return previousProductsProvider;
          },
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => OrdersProvider())
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: 'Lato',
          ),
          home: authProvider.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductsOverviewScreen.routeName: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            AddEditProductScreen.routeName: (ctx) => AddEditProductScreen(),
            AuthScreen.routeName: (ctx) => AuthScreen()
          },
        ),
      ),
    );
  }
}
