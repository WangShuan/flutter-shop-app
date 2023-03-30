import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './cart_screen.dart';

import '../models/cart.dart';
import '../models/products_provider.dart';

import '../widgets/badge.dart';

class ProductDetailScreen extends StatefulWidget {
  static String routeName = '/product-detail';

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context).settings.arguments as String;
    final product = Provider.of<Products>(context).findById(prodId);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
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
      body: Container(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.white,
                    ),
                    height: 360,
                    padding: const EdgeInsets.all(30),
                    width: double.infinity,
                    child: Image.network(
                      product.imgUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Consumer<Product>(
                    builder: (context, value, child) => Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            product.toggleFavoriteStatus();
                          });
                        },
                        iconSize: 30,
                        icon: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      color:
                          Theme.of(context).primaryColorLight.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      child: Text(
                        'NT\$ ${product.price.toString()}',
                        style: TextStyle(
                          fontSize: 24,
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: IconButton(
                        onPressed: () {
                          Provider.of<Cart>(context, listen: false)
                              .addItem(product.id, product.name, product.price);
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${product.name} 成功加入購物車'),
                            action: SnackBarAction(
                              label: '復原',
                              textColor: Theme.of(context).primaryColorLight,
                              onPressed: () {
                                Provider.of<Cart>(context, listen: false)
                                    .removeSingleItem(prodId);
                              },
                            ),
                          ));
                        },
                        icon: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                        ),
                        iconSize: 30,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                color: Theme.of(context).primaryColorDark,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  '商品描述',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                width: double.infinity,
              ),
              Container(
                width: double.infinity,
                color: Theme.of(context).primaryColorLight.withOpacity(0.5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  '${product.description}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
