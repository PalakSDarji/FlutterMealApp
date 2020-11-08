import 'dart:convert';

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
  Future<ApiResult> deleteProduct(String id) async {
    try {
      await restService.deleteProduct(id, locator<AuthProvider>().token);
      return ApiResult.success(data: "done");
    } catch (e) {
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<Map<String, Product>>> fetchProducts() async {
    try {
      Map<String, Product> response =
          await restService.getProducts(locator<AuthProvider>().token);

      response.forEach((key, value) {
        value.id = key;
      });
      print("got response finally : $response");
      return ApiResult.success(data: response);
    } catch (e) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<Product>> updateProduct(Product product) async {
    try {
      Product savedProduct = await restService.editProduct(
          product.id, locator<AuthProvider>().token, json.encode(product));
      print('got response from editProduct : $savedProduct');
      return ApiResult.success(data: savedProduct);
    } catch (e) {
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }

  @override
  Future<ApiResult<NameId>> addProduct(Product product) async {
    try {
      NameId name = await restService.addProduct(
          locator<AuthProvider>().token, json.encode(product.toJson()));
      print('got response from addProduct : $name');
      return ApiResult.success(data: name);
    } catch (e) {
      print(e);
      return ApiResult.failure(error: NetworkExceptions.getDioException(e));
    }
  }
}
