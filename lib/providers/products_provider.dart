
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meal_app/api/result/api_result.dart';
import 'package:flutter_meal_app/providers/product.dart';
import 'package:flutter_meal_app/repositories/products_repository.dart';
import 'package:flutter_meal_app/screens/add_edit_product_screen.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  ProductsRepository productsRepository;

  ProductsProvider(this.productsRepository);

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
      var apiResult = await productsRepository.fetchProducts();
      print("getProducts list : $apiResult");

      if (apiResult != null) {
        apiResult.when(success: (Map<String, Product> data) {
          List<Product> loadedProducts;
          if (data != null && data.isNotEmpty) {
            loadedProducts = data.values.toList();
          }
          print("got products $loadedProducts");
          _items = loadedProducts;
          notifyListeners();
        }, failure: (error) {
          print(error);
          throw error;
        });
      }
    } on Exception catch (error) {
      print(error);
      throw error;
    }
  }

  Future<ApiResult<NameId>> addProduct(ProductFormModel product) async {
    try {
      var apiResult = await productsRepository.addProduct(Product.fromJson({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFav
      }));

      print('got response from addProduct : $apiResult');

      apiResult.when(success: (NameId name) {
        product.id = name.name;
        _items.add(product.toProduct());
        notifyListeners();
      }, failure: (error) {
        throw error;
      });
      return apiResult;
    } on Exception catch (error) {
      print("error is :: " + error.toString());
      throw error;
    }
  }

  Future<ApiResult> editProduct(Product product) async {
    int index = indexOfProduct(product);

    if (index >= 0) {
      try {
        var apiResult = await productsRepository.updateProduct(product);

        apiResult.when(success: (data) {
          _items[index] = product;
          notifyListeners();
        }, failure: (error) {
          throw error;
        });
        return apiResult;
      } on Exception catch (error) {
        //This is another way of catching and throwing the exception to outer codeblock.
        // in the case if we want to do something in catch block.
        print("error in updating product : " + error.toString());
        //throw HttpException('Something went wrong updating the product!');
        throw error;
      }
    }
  }

  Future<ApiResult> deleteProduct(Product product) async {
    final existingIndex = indexOfProduct(product);
    var existingProduct = _items[existingIndex];

    var apiResult = await productsRepository.deleteProduct(product.id);
    try {
      apiResult.when(success: (data) {
        _items.removeAt(existingIndex);
        notifyListeners();
        existingProduct = null;
        return apiResult;
      }, failure: (error) {
        throw error;
      });
    } catch (e) {
      //revert back.
      _items.insert(existingIndex, existingProduct);
      notifyListeners();
      print(e);
      throw e;
    }
  }

  Future<ApiResult<Product>> toggleFavorite(String id) async{

    var existingProduct = findProductById(id);
    var index = indexOfProduct(existingProduct);
    existingProduct.isFavorite = !existingProduct.isFavorite;
    _items[index] = existingProduct;
    notifyListeners();

    var apiResult = await productsRepository.updateProduct(existingProduct);

    try{
      apiResult.when(success: (product){

      }, failure: (error){
        //revert back.
        existingProduct.isFavorite = !existingProduct.isFavorite;
        _items[index] = existingProduct;
        notifyListeners();
        throw error;
      });

      return apiResult;
    }
    catch (e){
      print(e);
      throw e;
    }
  }
}
