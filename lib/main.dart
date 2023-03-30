import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';

import '../models/cart.dart';
import '../models/order.dart';
import '../models/products_provider.dart';

void main() {
  initializeDateFormatting('zh_TW', null).then(
    (_) => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Product(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          fontFamily: 'Lato',
          textTheme: TextTheme(
            titleSmall: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 15,
            ),
            titleMedium: TextStyle(
              color: Colors.indigo[700],
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: TextStyle(
              fontSize: 18,
              height: 1.75,
            ),
            labelLarge: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo[700],
            ),
          ),
          primarySwatch: Colors.indigo,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.indigo,
          ).copyWith(
            error: Colors.red[900],
            secondary: Theme.of(context).primaryColorDark,
          ),
          snackBarTheme: SnackBarThemeData(
            contentTextStyle: TextStyle(fontSize: 16),
            actionTextColor: Colors.indigo[300],
            behavior: SnackBarBehavior.floating,
          ),
        ),
        home: MyHomePage(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen()
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductsOverviewScreen();
  }
}
