import 'package:flutter_meal_app/api/result/api_result.dart';
import 'package:flutter_meal_app/providers/product.dart';

abstract class ProductsRepository {
  Future<ApiResult<Map<String, Product>>> fetchProducts();
  Future<ApiResult<NameId>> addProduct(Product product);
  Future<ApiResult<Product>> updateProduct(Product product);
  Future<ApiResult> deleteProduct(String id);
}