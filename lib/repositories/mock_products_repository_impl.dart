import 'package:flutter_meal_app/api/base_model.dart';
import 'package:flutter_meal_app/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@dev
@Singleton(as: ProductsRepository)
class MockProductsRepositoryImpl extends ProductsRepository {
  final items = {
    'key1': {
      'title': 'product1',
      'description': 'product1 description',
      'price': 200.3,
      'imageUrl': '',
      'isFavorite': true
    }
  };


  MockProductsRepositoryImpl(){
    print('MockProductsRepositoryImpl constr called');
  }

  @override
  void deleteProduct() {
    // TODO: implement deleteProduct
  }

  @override
  Future<BaseModel> fetchProducts() {
    Future.delayed(Duration(seconds: 3));
    return Future.value(BaseModel()..data = items);
  }

  @override
  void updateProduct() {
    // TODO: implement updateProduct
  }
}
