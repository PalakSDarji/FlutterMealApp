import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/product.dart';
import 'package:flutter_meal_app/providers/products_provider.dart';
import 'package:provider/provider.dart';

class AddEditProductScreen extends StatefulWidget {
  static const routeName = '/add-edit-product';

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  var isEditMode = false;
  final _priceFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ProductFormModel _formProduct;

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    Product product = ModalRoute.of(context).settings.arguments;
    if (product != null) {
      isEditMode = true;
      _formProduct = ProductFormModel.copyFromProduct(product);
      _imageUrlController.text = product.imageUrl;
    } else {
      _formProduct = ProductFormModel.init();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _formProduct.title,
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please provide a value';
                  } else {
                    return null;
                  }
                },
                onSaved: (newValue) {
                  _formProduct.title = newValue;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                initialValue: _formProduct.price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a price.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _formProduct.price = double.parse(newValue);
                },
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
              ),
              TextFormField(
                maxLines: 3,
                initialValue: _formProduct.description,
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 10) {
                    return 'Should be at least 10 characters long';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _formProduct.description = newValue;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text(
                            'Enter a URL',
                            textAlign: TextAlign.center,
                          )
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an image URL';
                        }
                        if (!value.startsWith('htttp') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        if (!value.endsWith('.png') &&
                            !value.endsWith('.jpeg') &&
                            !value.endsWith('.jpg')) {
                          return 'Please enter a valid URL';
                        }
                        return null;
                      },
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        var text = _imageUrlController.text;
                        if (text.isEmpty ||
                            (!text.startsWith('htttp') &&
                                !text.startsWith('htttps')) ||
                            (!text.endsWith('.png') &&
                                !text.endsWith('.jpeg') &&
                                !text.endsWith('.jpg'))) {
                          return;
                        }

                        setState(() {});
                      },
                      onSaved: (newValue) {
                        _formProduct.imageUrl = newValue;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        color: Theme.of(context).accentColor,
        child: InkWell(
          onTap: () {
            final isValid = _formKey.currentState.validate();
            if (!isValid) {
              return;
            }
            _formKey.currentState.save();
            if (isEditMode) {
              productsProvider.editProduct(_formProduct.toProduct());
            } else {
              productsProvider.addProduct(_formProduct.toProduct());
            }
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Text(
              'SUBMIT',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
  }
}

/// This class has non final fields to enter form data.
class ProductFormModel {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFav;

  ProductFormModel.init() {
    id = UniqueKey().toString();
    title = '';
    description = '';
    price = 0.0;
    imageUrl = '';
    isFav = false;
  }

  ProductFormModel.copyFromProduct(Product product) {
    id = product.id;
    title = product.title;
    description = product.description;
    price = product.price;
    imageUrl = product.imageUrl;
    isFav = product.isFavorite;
  }

  Product toProduct() {
    return Product(
        id: id,
        title: title,
        price: price,
        description: description,
        imageUrl: imageUrl,
        isFavorite: isFav);
  }
}
