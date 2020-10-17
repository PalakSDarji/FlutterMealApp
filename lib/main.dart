import 'package:flutter/material.dart';
import 'package:flutter_meal_app/di/injection.dart';
import 'package:flutter_meal_app/providers/auth_provider.dart';
import 'package:flutter_meal_app/providers/cart_provider.dart';
import 'package:flutter_meal_app/providers/orders_provider.dart';
import 'package:flutter_meal_app/providers/products_provider.dart';
import 'package:flutter_meal_app/repositories/products_repository.dart';
import 'package:flutter_meal_app/screens/add_edit_product_screen.dart';
import 'package:flutter_meal_app/screens/auth_screen.dart';
import 'package:flutter_meal_app/screens/cart_screen.dart';
import 'package:flutter_meal_app/screens/orders_screen.dart';
import 'package:flutter_meal_app/screens/product_detail_screen.dart';
import 'package:flutter_meal_app/screens/products_overview_screen.dart';
import 'package:flutter_meal_app/screens/user_products_screen.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureInjection(Env.prod);
  _setupLogging();
  runApp(MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: locator<AuthProvider>()),
        ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
          create: (context) => ProductsProvider(locator<ProductsRepository>()),
          update: (context, authProvider, previousProductsProvider) {
            previousProductsProvider.authToken = authProvider.token;
            return previousProductsProvider;
          },
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProvider(create: (context) => OrdersProvider())
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          print('authProvider in Consumer ${authProvider.token}');
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              fontFamily: 'Lato',
            ),
            home: authProvider.isAuth ? ProductsOverviewScreen() : AuthScreen(),
            routes: {
              ProductsOverviewScreen.routeName: (ctx) =>
                  ProductsOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              AddEditProductScreen.routeName: (ctx) => AddEditProductScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen()
            },
          );
        },
      ),
    );
  }
}
