
import 'package:flutter_meal_app/api/base_model.dart';
import 'package:flutter_meal_app/api/rest_service.dart';
import 'package:flutter_meal_app/di/injection.dart';
import 'package:flutter_meal_app/providers/auth_provider.dart';
import 'package:flutter_meal_app/repositories/products_repository.dart';
import 'package:injectable/injectable.dart';

@prod
@Singleton(as: ProductsRepository)
class ProductsRepositoryImpl extends ProductsRepository{

  RestService restService;

  ProductsRepositoryImpl(this.restService);

  @override
  void deleteProduct() {
    // TODO: implement deleteProduct
  }

  @override
  Future<BaseModel> fetchProducts() async {
    BaseModel baseModel = new BaseModel();
    final response = await restService.getProducts(locator<AuthProvider>().token);
    if(response.isSuccessful){
      baseModel.data = response.body;
    }
    else{
      baseModel.error = ServerError(response.statusCode,'An error occurred!');
    }
    return baseModel;
  }

  @override
  void updateProduct() {
    // TODO: implement updateProduct
  }

}