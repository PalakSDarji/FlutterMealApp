import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_meal_app/utils/constants.dart';
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;

part 'product.g.dart';

@JsonSerializable()
class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorite(String authToken) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Constants.PRODUCTS_EDIT_URL
        .replaceFirst('{id}', id)
        .replaceFirst('{authToken}', authToken);
    try {
      Response response = await http.patch(url, body: json.encode(toJson()));
      if (response.statusCode >= 400) {
        throw HttpException('Try again!');
      }
    } on Exception catch (error) {
      isFavorite = oldStatus;
      notifyListeners();
      throw 'WWRONG';
    }
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, price: $price, imageUrl: $imageUrl, isFavorite: $isFavorite}';
  }

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
