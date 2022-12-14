import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';

class ProductsFormScreen extends StatefulWidget {
  const ProductsFormScreen({super.key});

  @override
  State<ProductsFormScreen> createState() => _ProductsFormScreenState();
}

class _ProductsFormScreenState extends State<ProductsFormScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imgUrlFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _imgUrlFocusNode.addListener(() {});
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final product = ModalRoute.of(context)!.settings.arguments as Product;
      if (product != null) {
        _formData['id'] = product.id as String;
        _formData['title'] = product.title;
        _formData['price'] = product.price.toString();
        _formData['description'] = product.description;
        _formData['imgUrl'] = product.imgURL;

        _imgUrlController.text = _formData['imgUrl'] as String;
      } else {
        _formData['price'] = '';
      }
    }
  }

  void _updateimgURL() {
    if (isValidImgUrl(_imgUrlController.text)) {
      setState(() {});
    }
  }

  bool isValidImgUrl(String url) {
    bool isValidProtocol = url.toLowerCase().startsWith('http://') ||
        url.toLowerCase().startsWith('https://');
    bool endsWithPng = url.toLowerCase().endsWith('.png');
    bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');
    return (isValidProtocol) && (endsWithJpeg || endsWithJpg || endsWithPng);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imgUrlFocusNode.removeListener(() {});
    _imgUrlFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    var isvalid = _form.currentState!.validate();

    if (!isvalid) {
      return;
    }
    _form.currentState?.save();
    final product = Product(
      id: _formData['id'] as String,
      title: _formData['title'] as String,
      description: _formData['description'] as String,
      price: _formData['price'] as double,
      imgURL: _formData['imgURL'] as String,
    );

    setState(() {
      _isLoading = true;
    });

    final products = Provider.of<Products>(context, listen: false);
    try {
      if (_formData['id'] == null) {
        await products.addProduct(product);
      } else {
        await products.updateProduct(product);
      }
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
            'An error ocurred while saving the product',
          ),
          actions: [
            TextButton(
                onPressed: (() => Navigator.of(context).pop()),
                child: const Text('Ok'))
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Form'),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['title'] as String,
                      decoration: const InputDecoration(labelText: 'Titulo'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) => _formData['title'] = value as Object,
                      validator: (value) {
                        bool isEmptyTitle = value!.trim().isEmpty;
                        bool isInvalidTitle = value.trim().length < 3;

                        if (isEmptyTitle || isInvalidTitle) {
                          return 'Informe um t??tulo v??lido com no m??nimo 3 letras';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price'].toString(),
                      decoration: const InputDecoration(labelText: 'Pre??o'),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value!),
                      validator: (value) {
                        bool isemptyValue = value!.trim().isEmpty;
                        var newPrice = double.tryParse(value);
                        bool isInvalidValue = newPrice == null || newPrice <= 0;

                        if (isemptyValue || isInvalidValue) {
                          return 'Informe um pre??o v??lido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description'] as String,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      focusNode: _descFocusNode,
                      onSaved: (value) =>
                          _formData['description'] = value as Object,
                      validator: (value) {
                        bool isEmtpyDesc = value!.trim().isEmpty;
                        bool isInvalidDesc = value.trim().length < 10;

                        if (isEmtpyDesc || isInvalidDesc) {
                          return 'Informe uma descri????o v??lida com no m??nimo 10 letras';
                        }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            // initialValue: _formData['imgURL'] as String,
                            decoration:
                                const InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                            focusNode: _imgUrlFocusNode,
                            controller: _imgUrlController,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) =>
                                _formData['imgURL'] = value as Object,
                            validator: (value) {
                              bool emptyUrl = value!.trim().isEmpty;
                              bool invalidUrl = !isValidImgUrl(value);
                              if (emptyUrl || invalidUrl) {
                                return 'Informe uma URL v??lida';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.only(
                            top: 8,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: _imgUrlController.text.isEmpty
                              ? const Text(
                                  'Informe a URL',
                                  textAlign: TextAlign.center,
                                )
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child: Image.network(_imgUrlController.text),
                                ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
