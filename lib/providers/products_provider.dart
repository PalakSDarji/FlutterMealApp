import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/product.dart';
import 'package:flutter_meal_app/utils/constants.dart';
import 'package:flutter_meal_app/utils/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_meal_app/screens/add_edit_product_screen.dart';
import 'package:http/http.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  var authToken;

  ProductsProvider();

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findProductById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  int indexOfProduct(Product product) {
    return _items.indexWhere((element) => element.id == product.id);
  }

  Future<void> fetchAndSetProducts() async {
    try {
      var url = Constants.PRODUCTS_URL.replaceFirst('{authToken}', authToken);
      print("fetchAndSetProducts url : $url");
      final response = await http.get(url);

      final extractedProducts =
          json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      if (extractedProducts != null && extractedProducts.isNotEmpty) {
        extractedProducts.forEach((prodId, prodData) {
          loadedProducts.add(Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite: prodData['isFavorite']));
        });
      }
      print("got products");
      print(loadedProducts);
      _items = loadedProducts;
      notifyListeners();
    } on Exception catch (error) {
      throw Exception(error);
    }
  }

  Future<Response> addProduct(ProductFormModel product) async {
    try {
      var url = Constants.PRODUCTS_URL.replaceFirst('{authToken}', authToken);
      print("fetchAndSetProducts url : $url");
      Response response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFav
          }));

      Map respMap = json.decode(response.body);
      product.id = respMap['name'];
      _items.add(product.toProduct());
      notifyListeners();
      return response;
    } on Exception catch (error) {
      print("error is :: " + error.toString());
      throw HttpException('Something went wrong!!');
    }
  }

  Future<Response> editProduct(ProductFormModel productFormModel) async {
    Product product = productFormModel.toProduct();
    int index = indexOfProduct(product);

    if (index >= 0) {
      try {
        final url = Constants.PRODUCTS_EDIT_URL
            .replaceFirst('{id}', product.id)
            .replaceFirst('{authToken}', authToken);
        print("url : $url");
        Response response =
            await http.patch(url, body: json.encode(product.toJson()));
        print("respo : " + response.statusCode.toString());
        if (response.statusCode >= 400) {
          throw HttpException('Wrong EndPoint');
        }
        _items[index] = product;
        notifyListeners();
        return response;
      } on Exception catch (error) {
        //This is another way of catching and throwing the exception to outer codeblock.
        // in the case if we want to do something in catch block.
        print("error in updating product : " + error.toString());
        throw HttpException('Something went wrong updating the product!');
      }
    }
  }

  Future<Response> deleteProduct(Product product) async {
    final url = Constants.PRODUCTS_EDIT_URL
        .replaceFirst('{id}', product.id)
        .replaceFirst('{authToken}', authToken);
    final existingIndex = indexOfProduct(product);
    var existingProduct = _items[existingIndex];

    _items.removeAt(existingIndex);
    notifyListeners();

    Response response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product!');
    }
    existingProduct = null;
    return response;
  }
}
