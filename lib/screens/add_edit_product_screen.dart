import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_meal_app/providers/product.dart';
import 'package:flutter_meal_app/providers/products_provider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class AddEditProductScreen extends StatefulWidget {
  static const routeName = '/add-edit-product';

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  var isEditMode = false;
  var isImageCleared = false;
  final _priceFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  ProductFormModel _formProduct;

  @override
  Widget build(BuildContext context) {
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    Product product = ModalRoute.of(context).settings.arguments;
    if (product != null) {
      isEditMode = true;
      _formProduct = ProductFormModel.copyFromProduct(product);
      if (isImageCleared) {
        _imageUrlController.text = '';
      } else if (_imageUrlController.text.isEmpty) {
        _imageUrlController.text = _formProduct.imageUrl;
      }
    } else {
      _formProduct = ProductFormModel.init();
      _imageUrlController.text = _formProduct.imageUrl;
    }
    print("reebuilt");
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              SizedBox(height: 10),
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
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid URL.';
                        }
                        /*if (!value.endsWith('.png') &&
                            !value.endsWith('.jpeg') &&
                            !value.endsWith('.jpg')) {
                          return 'Please enter a valid URL';
                        }*/
                        return null;
                      },
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          print("img : " + _imageUrlController.text);
                          isImageCleared = false;
                        });
//                        loadImageFromURL();
                      },
                      onSaved: (newValue) {
                        print('saved  $newValue');
                        _formProduct.imageUrl = newValue;
                      },
                    ),
                  ),
                  IconButton(
                    alignment: Alignment.bottomCenter,
                    icon: Icon(Icons.clear_rounded),
                    onPressed: () {
                      setState(() {
                        isImageCleared = true;
                      });
                      //loadImageFromURL();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SubmitButtonWithProgressBar(
          isEditMode: isEditMode, formKey: _formKey, formProduct: _formProduct),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _imageUrlController.dispose();
  }

  void loadImageFromURL() {
    var text = _imageUrlController.text;

    if (!text.startsWith('http') &&
            !text.startsWith(
                'https') /*||
        (!text.endsWith('.png') &&
            !text.endsWith('.jpeg') &&
            !text.endsWith('.jpg'))*/
        ) {
      return;
    }
    print("crossed : " + text.toString());
    setState(() {});
  }
}

class SubmitButtonWithProgressBar extends StatefulWidget {
  final isEditMode;
  final formKey;
  final ProductFormModel formProduct;

  SubmitButtonWithProgressBar({
    this.isEditMode,
    this.formKey,
    this.formProduct,
  });

  @override
  _SubmitButtonWithProgressBarState createState() =>
      _SubmitButtonWithProgressBarState();
}

class _SubmitButtonWithProgressBarState
    extends State<SubmitButtonWithProgressBar> {
  Future<Response> futureOfSubmit;
  bool isLoadingVisible = false;

  @override
  Widget build(BuildContext context) {
    print("isEditMode : ${widget.isEditMode}");
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    return Container(
      height: 50,
      child: Material(
        color: Theme.of(context).accentColor,
        child: InkWell(
          onTap: isLoadingVisible
              ? null
              : () {
                  final isValid = widget.formKey.currentState.validate();
                  if (!isValid) {
                    return;
                  }
                  widget.formKey.currentState.save();
                  FocusScope.of(context).unfocus();

                  setState(() {
                    if (widget.isEditMode) {
                      futureOfSubmit =
                          productsProvider.editProduct(widget.formProduct.toProduct());
                    } else {
                      futureOfSubmit =
                          productsProvider.addProduct(widget.formProduct);
                    }
                    isLoadingVisible = true;
                  });
                  futureOfSubmit.then((value) {
                    Navigator.of(context).pop();
                  }).catchError((error) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('An error occurred!'),
                              content: Text(error.toString()),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Okay'))
                              ],
                            ));
                  }).whenComplete(() {
                    setState(() {
                      isLoadingVisible = false;
                    });
                  });
                },
          child: FutureBuilder(
            future: futureOfSubmit,
            builder: (context, AsyncSnapshot<Response> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Align(
                  alignment: Alignment.center,
                  child: Container(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )),
                );
              } else {
                return Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
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
    title = 'Sample ${Random().nextInt(10000)}';
    description = 'ansdbasidbia sb';
    price = 50.0;
    imageUrl =
        'https://yt3.ggpht.com/a/AATXAJzwWs2J6XBL_2o0jMyIuEmufzw3wcnD_p-ABqzzF44=s200-c-k-c0xffffffff-no-rj-mo';
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
