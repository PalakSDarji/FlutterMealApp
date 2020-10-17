import 'package:flutter_meal_app/api/base_model.dart';

abstract class ProductsRepository{
  Future<BaseModel> fetchProducts();
  void updateProduct();
  void deleteProduct();
}