class Constants {
  static const BASE_URL = 'https://fluttershopapp-4dd44.firebaseio.com';

  static const PRODUCTS_URL = '$BASE_URL/products.json?auth={authToken}';

  static const PRODUCTS_EDIT_URL =
      '$BASE_URL/products/{id}.json?auth={authToken}';

  static String USER_KEY = "USER";

  static const AUTH_BASE_URL = 'https://identitytoolkit.googleapis.com/v1';
}
