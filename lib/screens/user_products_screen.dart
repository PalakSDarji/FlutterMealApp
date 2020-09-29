import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/products_provider.dart';
import 'package:flutter_meal_app/screens/add_edit_product_screen.dart';
import 'package:flutter_meal_app/widgets/app_drawer.dart';
import 'package:flutter_meal_app/widgets/user_product_item_widget.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts();
  }

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
      body: CustomRefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
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
        builder: (context, Widget child, IndicatorController controller) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.topCenter,
                children: [
                  if (!controller.isIdle)
                    Positioned(
                      top: 0,
                      child: SizedBox(
                        height: 5,
                        width: MediaQuery.of(context).size.width,
                        child: LinearProgressIndicator(
                          minHeight: 5,
                          backgroundColor: Colors.white,
                          value: !controller.isLoading
                              ? controller.value.clamp(0.0, 1.0)
                              : null,
                        ),
                      ),
                    ),
                  Transform.translate(
                    offset: Offset(0, 100.0 * controller.value),
                    child: child,
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
