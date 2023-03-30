import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String prodId;
  final int qty;
  final int price;
  final String name;

  CartItem({this.id, this.prodId, this.name, this.price, this.qty});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text(
                '是否移除商品 - $name',
                textAlign: TextAlign.center,
              ),
              titleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColorDark,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text(
                    'No',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(prodId);
      },
      key: ValueKey(id),
      background: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            title: Text(name),
            subtitle: Text('NT\$ ${price}'),
            trailing: Text(
              '小計 \n \$ ${price * qty}',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).primaryColorLight,
              child: Text('x $qty'),
            ),
          ),
        ),
      ),
    );
  }
}
