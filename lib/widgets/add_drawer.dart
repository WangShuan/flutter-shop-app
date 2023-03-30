import 'package:flutter/material.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    String pageName = ModalRoute.of(context).settings.name;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('MENU'),
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).primaryColorDark,
          ),
          ListTile(
            selectedTileColor: Theme.of(context).primaryColorLight,
            selected: pageName == '/',
            leading: Icon(
              Icons.shopping_cart_rounded,
              color: Theme.of(context).textTheme.labelLarge.color,
            ),
            title: Text(
              '菲克商店',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            onTap: () {
              setState(() {
                pageName = '/';
              });
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          ListTile(
            selectedTileColor: Theme.of(context).primaryColorLight,
            selected: pageName == '/orders',
            leading: Icon(
              Icons.list_alt_rounded,
              color: Theme.of(context).textTheme.labelLarge.color,
            ),
            title: Text(
              '我的訂單',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            onTap: () {
              setState(() {
                pageName = '/orders';
              });
              Navigator.of(context).pushReplacementNamed('/orders');
            },
          ),
          ListTile(
            selectedTileColor: Theme.of(context).primaryColorLight,
            selected: pageName == '/user-products',
            leading: Icon(
              Icons.settings_suggest,
              color: Theme.of(context).textTheme.labelLarge.color,
            ),
            title: Text(
              '商品管理',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            onTap: () {
              setState(() {
                pageName = '/user-products';
              });
              Navigator.of(context).pushReplacementNamed('/user-products');
            },
          )
        ],
      ),
    );
  }
}
