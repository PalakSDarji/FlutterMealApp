import 'package:flutter_meal_app/api/result/api_result.dart';
import 'package:flutter_meal_app/providers/product.dart';

abstract class ProductsRepository {
  Future<ApiResult<Map<String, Product>>> fetchProducts();

  void updateProduct();

  void deleteProduct();
}
