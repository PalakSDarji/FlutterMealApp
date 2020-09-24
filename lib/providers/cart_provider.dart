import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  int quantity;
  final double price;
  final String productId;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price,
      @required this.productId});
}

class Cart with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items {
    return [..._items];
  }

  double get totalAmount {
    double totalAm = 0.0;
    _items.forEach((cartItem) {
      totalAm += cartItem.price;
    });
    return totalAm;
  }

  int get itemCount {
    return _items.fold(
        0, (previousValue, cartItem) => cartItem.quantity + previousValue);
  }

  CartItem findCartItemById(String id) {
    return _items.firstWhere((cartItem) => cartItem.id == id);
  }

  int getIndexOfCartItemById(String id) {
    return _items.indexWhere((cartItem) => cartItem.id == id);
  }

  void addItem(String productId, double price, String title) {
    int indexOfItemFoundInCart =
        _items.indexWhere((cartItem) => cartItem.productId == productId);

    if (indexOfItemFoundInCart < 0) {
      //Not found. Add new item
      CartItem cartItem = CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
          productId: productId);
      _items.add(cartItem);
    } else {
      //found in cart. update the quantity by 1.
      CartItem cartItem = _items[indexOfItemFoundInCart];
      cartItem.quantity++;
      _items[indexOfItemFoundInCart] = cartItem;
    }

    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeAt(getIndexOfCartItemById(id));
    notifyListeners();
  }

  void clearCart(){
    _items.clear();
    notifyListeners();
  }
}
