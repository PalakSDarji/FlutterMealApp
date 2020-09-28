import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/product.dart';
import 'package:flutter_meal_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_meal_app/screens/add_edit_product_screen.dart';
import 'package:http/http.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    /*Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p5',
      title: 'Mobile',
      description: 'Samsung Mobile.',
      price: 23.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
    Product(
      id: 'p6',
      title: 'Router',
      description: 'A router',
      price: 62.54,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];

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
      final response = await http.get(Constants.PRODUCTS_URL);
      final extractedProducts =
          json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      if(extractedProducts != null && extractedProducts.isNotEmpty){
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
      Response response = await http.post(Constants.PRODUCTS_URL,
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
      throw Exception('Something went wrong!!');
    }
  }

  Future<Response> editProduct(ProductFormModel product) {
    int index = indexOfProduct(product.toProduct());
    if (index >= 0) {
      _items[index] = product.toProduct();
      notifyListeners();
    }
  }

  void deleteProduct(Product product) {
    _items.removeAt(indexOfProduct(product));
    notifyListeners();
  }
}
