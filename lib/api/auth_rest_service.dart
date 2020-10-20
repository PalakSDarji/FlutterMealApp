import 'package:dio/dio.dart';
import 'package:flutter_meal_app/models/user.dart';
import 'package:flutter_meal_app/utils/constants.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_rest_service.g.dart';

@singleton
@RestApi(baseUrl: Constants.AUTH_BASE_URL)
abstract class AuthRestService {
  factory AuthRestService(Dio dio, {String baseUrl}) = _AuthRestService;

  @factoryMethod
  static AuthRestService create() {
    final dio = Dio()
      ..interceptors.add(LogInterceptor(
          responseBody: true,
          error: true,
          requestHeader: true,
          responseHeader: true,
          request: true,
          requestBody: true));
    return AuthRestService(dio);
  }

  @POST('/accounts:signUp?key={authKey}')
  Future<User> signup(
      @Path('authKey') String authKey, @Body() Map<String, dynamic> body);

  @POST('/accounts:signInWithPassword?key={authKey}')
  Future<User> login(
      @Path('authKey') String authKey, @Body() Map<String, dynamic> body);
}
