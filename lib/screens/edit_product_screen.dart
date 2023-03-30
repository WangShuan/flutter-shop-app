import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({Key key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  bool _isInit = true;
  String _imgUrlInputed = '';
  var _editProd = Product(
    id: null,
    name: '',
    price: 0,
    imgUrl: '',
    description: '',
  );
  var _initValues = {
    'name': '',
    'price': '',
    'imgUrl': '',
    'description': '',
  };
  final _form = GlobalKey<FormState>();
  void _saveForm() {
    final isValidate = _form.currentState.validate();
    if (!isValidate) {
      return;
    }
    _form.currentState.save();
    Provider.of<Products>(context, listen: false).addProduct(_editProd);
    Navigator.of(context).pop();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      if (ModalRoute.of(context).settings.arguments != null) {
        final prodId = ModalRoute.of(context).settings.arguments as String;
        _editProd =
            Provider.of<Products>(context, listen: false).findById(prodId);
        _initValues = {
          'name': _editProd.name,
          'price': _editProd.price.toString(),
          'imgUrl': _editProd.imgUrl,
          'description': _editProd.description,
        };
        _imgUrlInputed = _editProd.imgUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('新增產品'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: Icon(Icons.done),
          ),
        ],
      ),
      body: Form(
        key: _form,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextFormField(
                initialValue: _initValues['name'],
                decoration: const InputDecoration(labelText: '商品名稱'),
                textInputAction: TextInputAction.next,
                validator: (value) => value.isEmpty ? '請輸入商品名稱' : null,
                onSaved: (newValue) => _editProd = Product(
                  id: _editProd.id,
                  name: newValue,
                  price: _editProd.price,
                  imgUrl: _editProd.imgUrl,
                  description: _editProd.description,
                  isFavorite: _editProd.isFavorite,
                ),
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: const InputDecoration(labelText: '商品價格'),
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return '請輸入商品價格';
                  }
                  if (int.tryParse(value) == null) {
                    return '請輸入有效的數值';
                  }
                  if (int.parse(value) <= 0) {
                    return '請輸入正數金額';
                  }
                  return null;
                },
                onSaved: (newValue) => _editProd = Product(
                  id: _editProd.id,
                  name: _editProd.name,
                  price: int.parse(newValue),
                  imgUrl: _editProd.imgUrl,
                  isFavorite: _editProd.isFavorite,
                  description: _editProd.description,
                ),
              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: const InputDecoration(labelText: '商品描述'),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                validator: (value) => value.length < 10 ? '商品描述不得少於十個字' : null,
                onSaved: (newValue) => _editProd = Product(
                  id: _editProd.id,
                  name: _editProd.name,
                  price: _editProd.price,
                  isFavorite: _editProd.isFavorite,
                  imgUrl: _editProd.imgUrl,
                  description: newValue,
                ),
              ),
              TextFormField(
                initialValue: _initValues['imgUrl'],
                decoration: const InputDecoration(labelText: '圖片連結'),
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) {
                    return '請輸入圖片連結';
                  }
                  if (!value.startsWith('https')) {
                    return '請輸入正確的連結';
                  }
                  if (!value.endsWith('.png') &&
                      !value.endsWith('.jpg') &&
                      !value.endsWith('.jpeg')) {
                    return '請輸入正確的圖片連結';
                  }
                  return null;
                },
                onChanged: (val) {
                  if (!val.startsWith('https') ||
                      (!val.endsWith('.png') &&
                          !val.endsWith('.jpg') &&
                          !val.endsWith('.jpeg'))) {
                    return;
                  }
                  setState(() {
                    _imgUrlInputed = val;
                  });
                },
                onSaved: (newValue) => _editProd = Product(
                  id: _editProd.id,
                  name: _editProd.name,
                  price: _editProd.price,
                  isFavorite: _editProd.isFavorite,
                  imgUrl: newValue,
                  description: _editProd.description,
                ),
                onFieldSubmitted: (val) {
                  _saveForm();
                },
              ),
              Container(
                height: 240,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Theme.of(context).primaryColorLight)),
                child: _imgUrlInputed.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 50,
                        ),
                      )
                    : Image.network(
                        _imgUrlInputed,
                        fit: BoxFit.contain,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
