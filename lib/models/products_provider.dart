import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      name: "連帽外套(女)",
      price: 699,
      description:
          "※ 因拍攝燈光效果可能造成色差，\n請以實品顏色為準。\n※ 深淺色衣物請分開洗滌；\n請勿長時間浸泡、濕放，以防染色。\n※ 衣物洗滌和保養方式請參考商品洗標。",
      imgUrl: "https://s.lativ.com.tw/i/54083/54083021/5408302_500.jpg",
    ),
    Product(
      id: 'p2',
      name: "彈力圓領T",
      price: 199,
      description:
          "※ 因拍攝燈光效果可能造成色差，\n請以實品顏色為準。\n※ 深淺色衣物請分開洗滌；\n請勿長時間浸泡、濕放，以防染色。\n※ 衣物洗滌和保養方式請參考商品洗標。",
      imgUrl: "https://s.lativ.com.tw/i/56150/56150041/5615004_500.jpg",
    ),
    Product(
      id: 'p3',
      name: "牛仔外套(男)",
      price: 599,
      description:
          "※ 因拍攝燈光效果可能造成色差，\n請以實品顏色為準。\n※ 深淺色衣物請分開洗滌；\n請勿長時間浸泡、濕放，以防染色。\n※ 衣物洗滌和保養方式請參考商品洗標。",
      imgUrl: "https://s.lativ.com.tw/i/58002/58002011/5800201_500.jpg",
    ),
    Product(
      id: 'p4',
      name: "熊大圓領T",
      price: 1599,
      description:
          "※ 因拍攝燈光效果可能造成色差，\n請以實品顏色為準。\n※ 深淺色衣物請分開洗滌；\n請勿長時間浸泡、濕放，以防染色。\n※ 衣物洗滌和保養方式請參考商品洗標。",
      imgUrl: "https://s.lativ.com.tw/i/58728/58728011/5872801_500.jpg",
    ),
  ];
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  bool isListEmpty(isShowOnlyFav) {
    if (isShowOnlyFav) {
      return favoriteItems.length == 0;
    } else {
      return items.length == 0;
    }
  }

  Product findById(String prodId) {
    return items.firstWhere((element) => element.id == prodId);
  }

  void addProduct(Product prod) {
    if (prod.id == null) {
      final newProd = Product(
        id: '${DateTime.now().millisecondsSinceEpoch}',
        name: prod.name,
        description: prod.description,
        price: prod.price,
        imgUrl: prod.imgUrl,
      );
      _items.insert(0, newProd);
    } else {
      final i = _items.indexWhere((element) => element.id == prod.id);
      _items[i] = prod;
    }
    notifyListeners();
  }

  void removeProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}

class Product with ChangeNotifier {
  final String imgUrl;
  final String id;
  final String name;
  final String description;
  final int price;
  bool isFavorite;

  Product({
    this.id,
    this.imgUrl,
    this.name,
    this.description,
    this.price,
    this.isFavorite = false,
  });

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
