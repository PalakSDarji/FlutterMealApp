import 'package:dio/dio.dart';
import 'package:flutter_meal_app/providers/product.dart';
import 'package:flutter_meal_app/utils/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'retro_rest_service.g.dart';

@singleton
@RestApi(baseUrl: Constants.BASE_URL)
abstract class RetroRestService {
  factory RetroRestService(Dio dio, {String baseUrl}) = _RetroRestService;

  @factoryMethod
  static RetroRestService create() {
    final dio = Dio()
      ..interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: true,
          request: true,
          requestBody: true));
    return RetroRestService(dio);
  }

  @GET("/products.json?auth={authToken}")
  Future<Map<String, Product>> getProducts(@Path("authToken") String authToken);

  @POST("/products.json?auth={authToken}")
  Future<void> addProduct(@Path("authToken") String authToken);

  @PATCH("/products/{id}.json?auth={authToken}")
  Future<void> editProduct(
      @Path("id") String id, @Path("authToken") String authToken);

  @PATCH("/products/{id}.json?auth={authToken}")
  Future<void> deleteProduct(
      @Path("id") String id, @Path("authToken") String authToken);
}
