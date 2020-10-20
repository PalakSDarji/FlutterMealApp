import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_meal_app/api/auth_rest_service.dart';
import 'package:flutter_meal_app/api/result/api_result.dart';
import 'package:flutter_meal_app/api/result/network_exceptions.dart';
import 'package:flutter_meal_app/di/injection.dart';
import 'package:flutter_meal_app/models/user.dart';
import 'package:flutter_meal_app/utils/constants.dart';
import 'package:flutter_meal_app/utils/http_exception.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class AuthProvider with ChangeNotifier {
  User _user;
  static const AUTH_KEY = "AIzaSyCEi0H26tjQSmsXSv74vtZt0QkmBaVny-s";
  AuthRestService _authRestService;

  AuthProvider(this._authRestService) {
    var user = getUserFromPref();
    if (user != null) _user = user;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_user != null &&
        _user.expiryDate != null &&
        _user.expiryDate.isAfter(DateTime.now()) &&
        _user.token != null) {
      return _user.token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    try {
      final response = await _authRestService.signup(AUTH_KEY,
          {'email': email, 'password': password, 'returnSecureToken': true});

      print("body is this.." + response.toString());
      /*final responseData = response.body;
      print("body is this..2 ");
      print('Signup response : $responseData');
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _user = User.fromJson(responseData)
        ..email = email
        ..password = password;

      _user.expiryDate =
          DateTime.now().add(Duration(seconds: int.parse(_user.expiresIn)));

      print("auth user : $_user");
      saveUserInPref();
      notifyListeners();*/
    } catch (error) {
      if (error is Response<dynamic>) {
        if (error.statusCode >= 400) {
          throw HttpException(error.body.toString());
        }
      }
      print("error caught by me: $error");
      throw error;
    }
  }

  Future<ApiResult<User>> login(String email, String password) async {
    try {
      final responseUser = await _authRestService.login(AUTH_KEY,
          {'email': email, 'password': password, 'returnSecureToken': true});

      print("login response : $responseUser");

      /*if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }*/

      _user = responseUser
        ..email = email
        ..password = password;
      _user.expiryDate =
          DateTime.now().add(Duration(seconds: int.parse(_user.expiresIn)));

      print("auth user : $_user");
      saveUserInPref();
      notifyListeners();
      return ApiResult.success(data: _user);
    } catch (error) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(error));
    }
  }

  User getUserFromPref() {
    //Convert user object into String to save it to pref.
    if (locator<SharedPreferences>().containsKey(Constants.USER_KEY)) {
      return User.fromJson(json
          .decode(locator<SharedPreferences>().getString(Constants.USER_KEY)));
    }
    return null;
  }

  void saveUserInPref() {
    //Convert user object into String to save it to pref.
    locator<SharedPreferences>()
        .setString(Constants.USER_KEY, json.encode(_user.toJson()));
  }

  void removeUserFromPref() {
    locator<SharedPreferences>().remove(Constants.USER_KEY);
  }
}
