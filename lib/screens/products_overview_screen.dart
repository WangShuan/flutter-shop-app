import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';

import '../models/cart.dart';
import '../models/products_provider.dart';

import '../widgets/add_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showOnlyFavo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('菲克商店'),
        actions: [
          PopupMenuButton(
            initialValue:
                _showOnlyFavo ? FilterOptions.Favorites : FilterOptions.All,
            onSelected: (FilterOptions val) {
              if (val == FilterOptions.Favorites) {
                setState(() {
                  _showOnlyFavo = true;
                });
              } else {
                setState(() {
                  _showOnlyFavo = false;
                });
              }
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('All Products'),
                value: FilterOptions.All,
              ),
              PopupMenuItem(
                child: const Text('My Favorites'),
                value: FilterOptions.Favorites,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, ch) => MyBadge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_bag),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  CartScreen.routeName,
                );
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Provider.of<Products>(context).isListEmpty(_showOnlyFavo)
          ? Center(
              child: Text(
                _showOnlyFavo ? '- 您的願望清單為空 -' : '- 目前店內沒有商品 -',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          : ProductsGrid(_showOnlyFavo),
    );
  }
}
