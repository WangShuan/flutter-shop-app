import 'package:flutter/material.dart';

import './cart.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void createOrder(List<CartItem> products, int total) {
    _orders.insert(
      0,
      Order(
        amount: total,
        dateTime: DateTime.now(),
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        products: products,
      ),
    );
    notifyListeners();
  }
}

class Order {
  final String id;
  final int amount;
  final DateTime dateTime;
  final List<CartItem> products;

  Order({
    @required this.amount,
    @required this.dateTime,
    @required this.id,
    @required this.products,
  });
}
