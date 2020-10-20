import 'package:flutter_meal_app/api/result/api_result.dart';
import 'package:flutter_meal_app/providers/product.dart';
import 'package:flutter_meal_app/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@dev
@Singleton(as: ProductsRepository)
class MockProductsRepositoryImpl extends ProductsRepository {
  Map<String, Product> items = {
    'key1': Product.fromJson({
      'title': 'product1',
      'description': 'product1 description',
      'price': 200.3,
      'imageUrl': '',
      'isFavorite': true
    })
  };

  MockProductsRepositoryImpl() {
    print('MockProductsRepositoryImpl constr called');
  }

  @override
  void deleteProduct() {
    // TODO: implement deleteProduct
  }

  @override
  Future<ApiResult<Map<String, Product>>> fetchProducts() {
    Future.delayed(Duration(seconds: 3));
    return Future.value(ApiResult.success(data: items));
  }

  @override
  void updateProduct() {
    // TODO: implement updateProduct
  }
}
