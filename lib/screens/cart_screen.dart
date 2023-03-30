import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/orders_screen.dart';

import '../models/cart.dart' show Cart;
import '../models/order.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('結帳'),
      ),
      body: cart.itemCount == 0
          ? Center(
              child: Text(
              '- 購物車中沒有商品 -',
              style: Theme.of(context).textTheme.titleLarge,
            ))
          : Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  itemBuilder: (context, index) => CartItem(
                    id: cart.items.values.toList()[index].id,
                    prodId: cart.items.keys.toList()[index],
                    name: cart.items.values.toList()[index].name,
                    qty: cart.items.values.toList()[index].qty,
                    price: cart.items.values.toList()[index].price,
                  ),
                  itemCount: cart.itemCount,
                )),
                Card(
                  margin: const EdgeInsets.all(15),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '訂單總金額',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                        Text(
                          'NT\$ ${cart.totalAmount}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20,
                            height: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 15,
                    right: 15,
                    bottom: 15,
                  ),
                  child: ElevatedButton(
                    child: const Text('結帳'),
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).createOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: const Text('已成立訂單'),
                      ));
                      cart.clearItems();
                      Navigator.of(context).pushNamed(OrdersScreen.routeName);
                    },
                  ),
                )
              ],
            ),
    );
  }
}
