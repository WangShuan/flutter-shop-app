import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_product_screen.dart';

import '../models/products_provider.dart';

import '../widgets/user_product_item.dart';
import '../widgets/add_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        title: const Text('商品一覽'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Consumer<Products>(
        builder: (context, productsData, child) => Padding(
          padding: const EdgeInsets.all(5),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return UserProductItem(
                title: productsData.items[index].name,
                imgUrl: productsData.items[index].imgUrl,
                price: productsData.items[index].price,
                id: productsData.items[index].id,
              );
            },
            itemCount: productsData.items.length,
          ),
        ),
      ),
    );
  }
}
