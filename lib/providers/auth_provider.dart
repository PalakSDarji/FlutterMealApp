import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_meal_app/di/injection.dart';
import 'package:flutter_meal_app/models/user.dart';
import 'package:flutter_meal_app/utils/constants.dart';
import 'package:flutter_meal_app/utils/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class AuthProvider with ChangeNotifier {

  User _user;
  String _token;
  DateTime _expiryDate;
  String _userId;
  static const AUTH_KEY = "AIzaSyCEi0H26tjQSmsXSv74vtZt0QkmBaVny-s";

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    const AUTH_SIGN_UP_URL =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$AUTH_KEY';
    try {
      final response = await http.post(AUTH_SIGN_UP_URL,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);
      print('Signup response : $responseData');
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    const AUTH_LOGIN_URL =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$AUTH_KEY";

    try {
      final response = await http.post(AUTH_LOGIN_URL,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));

      final responseData = json.decode(response.body);
      print("login response : $responseData");

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void saveUserInPref(){
    //Convert user object into String to save it to pref.
    locator<SharedPreferences>().setString(Constants.USER_KEY, json.encode(_user.toJson()));
  }

  void removeUserFromPref(){
    locator<SharedPreferences>().remove(Constants.USER_KEY);
  }
}
