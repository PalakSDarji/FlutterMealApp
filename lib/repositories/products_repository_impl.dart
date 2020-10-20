import 'package:flutter_meal_app/api/result/api_result.dart';
import 'package:flutter_meal_app/api/result/network_exceptions.dart';
import 'package:flutter_meal_app/api/retro_rest_service.dart';
import 'package:flutter_meal_app/di/injection.dart';
import 'package:flutter_meal_app/providers/auth_provider.dart';
import 'package:flutter_meal_app/providers/product.dart';
import 'package:flutter_meal_app/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@prod
@Singleton(as: ProductsRepository)
class ProductsRepositoryImpl extends ProductsRepository {
  RetroRestService restService;

  ProductsRepositoryImpl(this.restService);

  @override
  void deleteProduct() {
    // TODO: implement deleteProduct
  }

  @override
  Future<ApiResult<Map<String, Product>>> fetchProducts() async {
    try {
      Map<String, Product> response =
          await restService.getProducts(locator<AuthProvider>().token);
      print("got response finally : $response");
      return ApiResult.success(data: response);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  void updateProduct() {
    // TODO: implement updateProduct
  }
}
