import 'package:chopper/chopper.dart';
import 'package:flutter_meal_app/utils/constants.dart';
import 'package:injectable/injectable.dart';

part 'rest_service.chopper.dart';

@singleton
@ChopperApi(baseUrl: Constants.BASE_URL)
abstract class RestService extends ChopperService {

  @Get(path: "/products.json?auth={authToken}")
  Future<Response> getProducts(@Path("authToken") String authToken);

  @Post(path: "/products.json?auth={authToken}")
  Future<void> addProduct(@Path("authToken") String authToken);

  @Patch(path: "/products/{id}.json?auth={authToken}")
  Future<void> editProduct(
      @Path("id") String id, @Path("authToken") String authToken);

  @Patch(path: "/products/{id}.json?auth={authToken}")
  Future<void> deleteProduct(
      @Path("id") String id, @Path("authToken") String authToken);


  @factoryMethod
  static RestService create() {
    final client = ChopperClient(
        baseUrl: Constants.BASE_URL,
        services: [
          _$RestService(),
        ],
        converter: JsonConverter());

    return _$RestService(client);
  }
}
