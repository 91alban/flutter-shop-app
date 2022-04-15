import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };
  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (_isInit) {
        if (ModalRoute.of(context)!.settings.arguments != null) {
          final productId =
              ModalRoute.of(context)!.settings.arguments as String;

          if (productId != null) {
            final _editedProduct = Provider.of<Products>(context, listen: false)
                .findById(productId);
            _initValues = {
              'title': _editedProduct.title,
              'price': _editedProduct.price.toString(),
              'description': _editedProduct.description,
              'imageUrl': '',
            };
            _imageUrlController.text = _editedProduct.imageUrl;
          }
        }
      }
    }
    _isInit = false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: (() {
                _saveForm();
              }),
              icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(children: [
            TextFormField(
              initialValue: _initValues['title'],
              decoration: InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a title.';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                  title: value!,
                  price: _editedProduct.price,
                  description: _editedProduct.description,
                  imageUrl: _editedProduct.imageUrl,
                  id: _editedProduct.id,
                  isFavorite: _editedProduct.isFavorite,
                );
              },
            ),
            TextFormField(
              initialValue: _initValues['price'],
              decoration: InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a price.';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number.';
                }
                if (double.parse(value) <= 0) {
                  return 'Please enter a number greater than zero.';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                  title: _editedProduct.title,
                  price: double.parse(value!),
                  description: _editedProduct.description,
                  imageUrl: _editedProduct.imageUrl,
                  id: _editedProduct.id,
                  isFavorite: _editedProduct.isFavorite,
                );
              },
            ),
            TextFormField(
              initialValue: _initValues['description'],
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please provide a descriptions.';
                }
                if (value.length < 10) {
                  return 'Should be at least 10 char long.';
                }
                return null;
              },
              onSaved: (value) {
                _editedProduct = Product(
                  title: _editedProduct.title,
                  price: _editedProduct.price,
                  description: value!,
                  imageUrl: _editedProduct.imageUrl,
                  id: _editedProduct.id,
                  isFavorite: _editedProduct.isFavorite,
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    )),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a Url')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          )),
                Expanded(
                    child: TextFormField(
                  // initialValue: _initValues['imageUrl'],
                  decoration: InputDecoration(labelText: 'Image URL'),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageUrlController,
                  focusNode: _imageUrlFocusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide an image URL.';
                    }
                    if (!value.startsWith('http') &&
                        !value.startsWith('https') &&
                        !value.startsWith('www')) {
                      return 'Please enter a valid URL';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: value!,
                      id: _editedProduct.id,
                      isFavorite: _editedProduct.isFavorite,
                    );
                  },
                  onFieldSubmitted: (_) {
                    _saveForm;
                  },
                  onEditingComplete: () {
                    setState(() {});
                  },
                )),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
