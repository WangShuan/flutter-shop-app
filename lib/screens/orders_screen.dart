import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './cart_screen.dart';

import '../models/cart.dart';
import '../models/order.dart';

import '../widgets/add_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';
  const OrdersScreen({Key key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的訂單'),
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
      drawer: AppDrawer(),
      body: ordersData.orders.length == 0
          ? Center(
              child: Text(
                '- 沒有訂單記錄 -',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return OrderItem(ordersData.orders[index]);
              },
              itemCount: ordersData.orders.length,
            ),
    );
  }
}
