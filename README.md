# flutter_shop_app

## 狀態管理與用戶體驗優化

- provider 是一個第三方包，讓我們可以更有效率的進行狀態管理
  - 說明文件：https://flutter.cn/docs/development/data-and-backend/state-mgmt/simple
  - flutter 提供了一個 class 為 ChangeNotifier ，用於向監聽器發送通知，通過呼叫 notifyListeners() 來通知大家狀態改變了；provider 提供了一個小部件為 ChangeNotifierProvider 用來向其子孫小部件傳遞狀態變更的通知，可以當成是一個部件之間傳遞數據變更通知的橋樑，需放在要訪問狀態的小部件父層，故，我們可以創建一個 class 繼承 ChangeNotifier 當成我們要儲存的主要數據，接著再通過使用 ChangeNotifierProvider 小部件來與其子孫部件關聯，子孫部件中則可以通過 Consumer() 或 Provider.of 來獲取並使用數據，舉例如下：
  ```dart
  // 1. 在 products_provider.dart 中 建立一個 class 繼承 ChangeNotifier，並在裡面建立好我們的數據、方法等等
  class Products with ChangeNotifier {
    List<Product> _items = [ // 主要數據
      Product(
        id: 'p1',
        name: "冬季外套(女)",
        price: 699,
        description:
            "Adjustable and Detachable Hood and Adjustable cuff to prevent the wind and water,for a comfortable fit. 3 in 1 Detachable Design provide more convenience, you can separate the coat and inner as needed, or wear it together. It is suitable for different season and help you adapt to different climates",
        imgUrl: "https://fakestoreapi.com/img/51Y5NI-I5jL._AC_UX679_.jpg",
      ),
    ];

    List<Product> get items { // 通過 getter 的方式拷貝 _items 數據，這樣在其他地方使用 items 就不會影響到原本的 _items 數據了
      return [..._items];
    }

    Product findById(String prodId) { // 獲取單個商品的方法
      return items.firstWhere((element) => element.id == prodId);
    }

    void toggleFavoriteStatus() { // 變更是否為喜愛項目
      isFavorite = !isFavorite;
      notifyListeners(); // 呼叫 notifyListeners() 以更新畫面
    }
  }

  /*
  ---分隔線---
  */

  // 2-1. 只建立一個 Provider 數據對象：在 main.dart 中使用 ChangeNotifierProvider 結合 create，其子孫就可以獲取 Products 數據對象
  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider(
        create: (context) => Products(), // 告知要建立通知的數據對象
        child: // MaterialApp...
      )
    }
  }
  // 2-2. 同時要建立多個 Provider 數據對象：在 main.dart 中使用 MultiProvider 結合 providers，傳入多組 ChangeNotifierProvider
  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => Products(), // 建立 Products 的 Provider 數據對象
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(), // 建立 Cart 的 Provider 數據對象
          ),
          ChangeNotifierProvider(
            create: (context) => Orders(), // 建立 Orders 的 Provider 數據對象
          ),
        ],
        child: // MaterialApp...
      )
    }
  }

  // 3-1. 使用數據對象的方式，可通過 Provider.of<Products>(context) 來獲取 products_provider.dart 中的 Products()
  final products = Provider.of<Products>(context).items;  // 取得 Products() 中的 items 數據資料
  // 3-2. 使用數據對象但不更新畫面的方式，可通過 Provider.of<Products>(context, listen: false) 來獲取 products_provider.dart 中的 Products() 而不進行重製
  final product = Provider.of<Products>(context, listen: false).findById(prodId);  // listen 默認為 true ，會在每次數據更動時重構部件，需手動改為 false 取消兼通狀態以阻止重構部件
  // 3-3 使用數據對象 並只更新局部小部件，可以使用 Consumer() 來處理：
  header: GridTileBar(
    title: const Text(''),
    trailing: Consumer<Product>( // 使用 Consumer<傳入要使用的數據對象 class>
      builder: (context, product, child) => IconButton(
        icon: Icon(
          product.isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).colorScheme.error,
          size: 20,
        ),
        onPressed: () {
          product.toggleFavoriteStatus();
        },
      ),
    ),
  ),
  ```

- 滑動刪除的功能 Dismissible，以刪除商品為例：
```dart
Widget build(BuildContext context) {
  return Dismissible(
    key: ValueKey(id), // 設置 key 確保移除後可以正確清除小部件，這邊傳入商品的 id
    direction: DismissDirection.endToStart, // 限制滑動方向，限定右往左才有用
    confirmDismiss: (direction) { // 設置用戶確認的彈窗
      return showDialog( // 回傳 alert 彈窗小部件
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('是否移除商品 - $name'), // 設置彈窗文字
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true); // 關閉彈窗並回傳 true
                },
                child: Text('Yes'), // 設定彈窗中的按鈕文字
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false); // 關閉彈窗並回傳 false
                },
                child: Text('No'), // 設定彈窗中的按鈕文字
              ),
            ],
          );
        },
      );
    },
    onDismissed: (direction) { // 設置滑動後要執行的事
      Provider.of<Cart>(context, listen: false).removeItem(prodId); // 移除一個購物車的項目
    },
    background: Container( // 設置滑動的區塊背景
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
    child: Card( // 商品卡片本身(滑動要刪除的小部件)
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          title: Text(name),
          subtitle: Text('NT\$ ${price}'),
          trailing: Text('小計 \n \$ ${price * qty}'),
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColorLight,
            child: Text('x $qty'),
          ),
        ),
      ),
    ),
  );
}
```

- 表單小部件 Form()
```dart
final _form = GlobalKey<FormState>(); // 建立一個 key 給 Form 使用
void _saveForm() { // 提交表單用的函數
  final isValidate = _form.currentState.validate(); // 判斷是否通過所有驗證
  if (!isValidate) { // 未通過驗證 取消提交動作
    return;
  }
  _form.currentState.save(); // 觸發所有輸入框的 onSave() 以保存資料
  Provider.of<Products>(context, listen: false).addProduct(_editProd); // 執行 addProduct 方法將表單中的 _editProd 資料建立成一個商品
  Navigator.of(context).pop();
}

Form(
  key: _form, // 設置 key 用於提交表單時抓取該 form 的資訊
  child: SingleChildScrollView( // 輸入文字時會開啟小鍵盤，因此建議用可滾動的小部件當 child，以避免高度超出可視範圍的問題
    padding: const EdgeInsets.all(15),
    child: Column(
      children: [
        TextFormField( // 輸入框小部件，使用 Form 時必須搭配 TextFormField，如不使用 Form 則可直接用 TextField 小部件
          initialValue: _initValues['name'], // 設置預設輸入的值，如果是要編輯一段文字這邊就顯示被編輯的內容，如不設定則為空
          decoration: const InputDecoration(labelText: '商品名稱'), // 設定 label 文字
          textInputAction: TextInputAction.next, // 設置鍵盤點擊 Enter 時要幹嘛， next 表示將 forcus 移動到下一個輸入框的位置
          validator: (value) => value.isEmpty ? '請輸入商品名稱' : null, // 驗證，如果有問題就返回一段文字，沒問題則返回 null
          onSaved: (newValue) => _editProd = Product( // 當輸入框內容送出後執行的動作，這邊用於更新產品的內容
            id: _editProd.id,
            name: newValue,
            price: _editProd.price,
            imgUrl: _editProd.imgUrl,
            description: _editProd.description,
            isFavorite: _editProd.isFavorite,
          ),
        ),
        TextFormField(
          initialValue: _initValues['price'],
          decoration: const InputDecoration(labelText: '商品價格'),
          textInputAction: TextInputAction.next,
          keyboardType: const TextInputType.numberWithOptions( // 設定鍵盤類型，這邊設定為輸入各種數字與符號
            decimal: true,
            signed: true,
          ),
          validator: (value) {
            if (value.isEmpty) {
              return '請輸入商品價格';
            }
            if (int.tryParse(value) == null) { // 判斷是否為 int 數字類型
              return '請輸入有效的數值';
            }
            if (int.parse(value) <= 0) {
              return '請輸入正數金額';
            }
            return null;
          },
          onSaved: (newValue) => _editProd = Product(
            id: _editProd.id,
            name: _editProd.name,
            price: int.parse(newValue), // 因輸入框的內容一定是文字，所以這邊需要將文字轉成數字，再保存到 Product 中
            imgUrl: _editProd.imgUrl,
            isFavorite: _editProd.isFavorite,
            description: _editProd.description,
          ),
        ),
        TextFormField(
          initialValue: _initValues['description'],
          decoration: const InputDecoration(labelText: '商品描述'),
          keyboardType: TextInputType.multiline, // 這邊設定鍵盤類型為多行輸入，用以在點擊 Enter 時執行換行而非送出
          maxLines: 5, // 設置多行輸入框樣式要幾行高
          validator: (value) => value.length < 10 ? '商品描述不得少於十個字' : null,
          onSaved: (newValue) => _editProd = Product(
            id: _editProd.id,
            name: _editProd.name,
            price: _editProd.price,
            isFavorite: _editProd.isFavorite,
            imgUrl: _editProd.imgUrl,
            description: newValue,
          ),
        ),
        TextFormField(
          initialValue: _initValues['imgUrl'],
          decoration: const InputDecoration(labelText: '圖片連結'),
          keyboardType: TextInputType.url, // 設定為 url 用的鍵盤，會顯示 / . 等按鍵
          textInputAction: TextInputAction.done, // 點擊 Enter 表示完成表單
          validator: (value) {
            if (value.isEmpty) {
              return '請輸入圖片連結';
            }
            if (!value.startsWith('https')) {
              return '請輸入正確的連結';
            }
            if (!value.endsWith('.png') &&
                !value.endsWith('.jpg') &&
                !value.endsWith('.jpeg')) {
              return '請輸入正確的圖片連結';
            }
            return null;
          },
          onSaved: (newValue) => _editProd = Product(
            id: _editProd.id,
            name: _editProd.name,
            price: _editProd.price,
            isFavorite: _editProd.isFavorite,
            imgUrl: newValue,
            description: _editProd.description,
          ),
          onFieldSubmitted: (val) { // 完成表單需搭配提交表單函數
            _saveForm(); // 建立一個提交表單的 void
          },
        ),
      ],
    ),
  ),
),
```

- 下拉重整畫面功能
```dart
class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({Key key}) : super(key: key);

  Future<void> _refreshProds(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: RefreshIndicator( // 在最外層使用 RefreshIndicator 小部件
        onRefresh: () => _refreshProds(context), // 設置下拉後要執行的操作
        child: 
          // ...
        ),
      ),
    );
  }
}
```

