import 'package:com.gogospider.booking/database/db_helper.dart';
import 'package:com.gogospider.booking/main.dart';
import 'package:com.gogospider.booking/model/cart_model.dart';
import 'package:com.gogospider.booking/model/item_model.dart';
import 'package:com.gogospider.booking/model/service_data_model.dart';
// import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:nb_utils/nb_utils.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  int _counter = 0;
  int _quantity = 1;
  int get counter => _counter;
  int get quantity => _quantity;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  List<Cart> cart = [];
  List<Items> carts = [];
  Future<List<Cart>> getData() async {
    cart = await dbHelper.getCartList();
    if (cart.isEmpty || cart.length == 0) {
      appStore.cartItems = 0;
      setValue('cart_items', 0);
      setValue('item_quantity', 0);
      setValue('total_price', 0.0);
      cart = [];
    } else {
      _counter = cart.length;
      setValue('cart_items', cart.length);
      setValue('item_quantity', cart.length);
      appStore.cartItems = cart.length;
      appStore.cartItems = 0;
      double totalPrice = 0;
      for (var i = 0; i < cart.length; i++) {
        totalPrice = totalPrice +
            ((cart[i].quantity!.value) * cart[i].productPrice!.toDouble());
      }
      setValue('total_price', totalPrice);
    }
    notifyListeners();
    return cart;
  }

  // Future<List<Object>> getDatas() async {
  //   var addCart = await getCartResponse();
  //   // print("addCart ${addCart.id}");
  //   cart = await dbHelper.getCartList();
  //   if (addCart.id == null) {
  //     _counter = 0;
  //     setValue('cart_items', 0);
  //     setValue('item_quantity', 0);
  //     setValue('total_price', 0.0);
  //     cart = [];
  //     carts = [];
  //   } else {
  //     carts = (addCart.items) as List<Items>;
  //     dbHelper.deleteAllCartItemNotApi();
  //     _counter = carts.length;
  //     _counter = cart.length;
  //     setValue('cart_items', carts.length);
  //     setValue('item_quantity', addCart.itemsCount);
  //     double grandTotal = 0;
  //     for (var i = 0; i < carts.length; i++) {
  //       grandTotal = grandTotal +
  //           (carts[i].product!.price.validate() * carts[i].quantity!.value);
  //       dbHelper
  //           .insert(Cart(
  //               id: carts[i].id,
  //               productId: carts[i].productId,
  //               productName: carts[i].name,
  //               initialPrice: 1,
  //               productPrice: carts[i].product!.price,
  //               quantity: ValueNotifier(carts[i].quantity!.value),
  //               unitTag: "",
  //               image: carts[i].product!.attchments!.first.isNotEmpty
  //                   ? carts[i].product!.attchments!.first
  //                   : ""))
  //           .then((value) {
  //         log("insert Success");
  //       });
  //     }
  //     setValue('total_price', grandTotal);
  //     notifyListeners();
  //     _getPrefsItems();
  //   }
  //   // print("value _counter ${cart.length}");
  //   return cart;
  // }

  void _setPrefsItems() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setInt('cart_items', _counter);
    // prefs.setInt('item_quantity', _quantity);
    // prefs.setDouble('total_price', _totalPrice);
    setValue('cart_items', _counter);
    setValue('item_quantity', _quantity);
    setValue('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefsItems() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // _counter = prefs.getInt('cart_items') ?? 0;
    _counter = getIntAsync("cart_items") != 0 ? getIntAsync("cart_items") : 0;
    // _quantity = getDoubleAsync("item_quantity");
    _totalPrice = getDoubleAsync("total_price") == 0
        ? getDoubleAsync("total_price")
        : 0.0;
    // _quantity = prefs.getInt('item_quantity') ?? 1;
    // _totalPrice = prefs.getDouble('total_price') ?? 0;
  }

  void addCounter() {
    _counter++;
    _setPrefsItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    // _setPrefsItems();
    // notifyListeners();
  }

  int getCounter() {
    _getPrefsItems();
    return _counter;
  }

  void addQuantityNolist(int id) {
    _setPrefsItems();
    notifyListeners();
  }

  void addQuantity(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    if (index != -1)
      cart[index].quantity!.value = cart[index].quantity!.value + 1;
    _setPrefsItems();
    notifyListeners();
  }

  void addQuantitys(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart[index].quantity!.value = cart[index].quantity!.value + 1;
    _setPrefsItems();
    notifyListeners();
  }

  void addQuantityApi(int id, int qty) {
    qty = qty + 1;
    dbHelper.updateQuantityApi(id, qty).then((value) {
      log("Update Succefull !");
      getData();
    });
    final index = carts.indexWhere((element) => element.id == id);
    if (index != -1) {
      carts[index].quantity = ValueNotifier(qty);
      carts[index].total = qty * carts[index].price!;
    }
    _setPrefsItems();
    notifyListeners();
  }

  void deleteQuantity(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    final currentQuantity = cart[index].quantity!.value;
    if (currentQuantity <= 1) {
      // ignore: unnecessary_statements
      currentQuantity == 0;
      // dbHelper.deleteCartItem(id);
      // dbHelper.deleteCartItemApi(id);
      removeItemApi(id);
      removeItem(id);
      removeCounter();
    } else {
      cart[index].quantity!.value = currentQuantity - 1;
    }
    // getData();
    _setPrefsItems();
    notifyListeners();
  }

  void deleteQuantityApi(int id, int qty) {
    qty = qty == 1 ? 1 : qty - 1;
    dbHelper.updateQuantityApi(id, qty);
    final index = (carts.indexWhere((element) => element.id == id) < 0)
        ? 0
        : carts.indexWhere((element) => element.id == id);
    carts[index].quantity = ValueNotifier(qty);
    carts[index].total = qty * carts[index].price!;
    _setPrefsItems();
    notifyListeners();
  }

  void deleteQuantityNolist(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    var currentQuantity = 0;
    if (index == -1) {
      currentQuantity = 1;
    } else {
      currentQuantity = cart[index].quantity!.value;
    }
    if (currentQuantity <= 1) {
      // ignore: unnecessary_statements
      currentQuantity == 1;
    } else {
      cart[index].quantity!.value = currentQuantity - 1;
    }
    _setPrefsItems();
    notifyListeners();
  }

  void removeItem(int id) {
    final index = cart.indexWhere((element) => element.id == id);
    cart.removeAt(index);
    dbHelper.deleteCartItem(id);
    _setPrefsItems();
    notifyListeners();
  }

  void removeItemApi(int id) {
    final index = carts.indexWhere((element) => element.id == id);
    carts.removeAt(index);
    getData();
    _setPrefsItems();
    notifyListeners();
  }

  int getQuantity(int quantity) {
    _getPrefsItems();
    return _quantity;
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    // print(_totalPrice);
    // print(productPrice);
    _setPrefsItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefsItems();
    return _totalPrice;
  }

  void insertData(ServiceData service) async {
    dbHelper
        .insert(Cart(
      id: service.id,
      productId: service.id,
      discountProduct: service.discount != null
          ? ((service.discount!.toDouble() / 100) *
              service.basePrice!.toDouble())
          : 0.00,
      productName: service.name,
      initialPrice: service.price,
      productPrice: service.price,
      quantity: ValueNotifier(1),
      unitTag: service.unit,
      image: service.serviceAttachments.validate().isNotEmpty
          ? service.serviceAttachments!.first.validate()
          : service.attachments.validate().isNotEmpty
              ? service.attachments!.first.validate()
              : '',
    ))
        .then((value) {
      if (value.id.toString() != "") {
        getData();
        addTotalPrice(service.price!.toDouble());
        addCounter();
        getIntAsync("cart_items");
      }
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  void deleteQty(Cart cartRemve) async {
    if (cartRemve.quantity!.value == 1) {
      // dbHelper.delete(cartRemve.id!);
      getData();
    } else
      dbHelper.updateQuantity(Cart(
          id: cartRemve.id,
          productId: cartRemve.id,
          productName: cartRemve.productName,
          discountProduct: cartRemve.discountProduct,
          initialPrice: cartRemve.initialPrice,
          productPrice: cartRemve.productPrice,
          quantity: ValueNotifier(cartRemve.quantity!.value - 1),
          unitTag: cartRemve.unitTag,
          image: cartRemve.image));
    deleteQuantityNolist(cartRemve.id!);
    // addTotalPrice(getDoubleAsync("total_price"));
    removeCounter();
    getData();
  }

  void addQty(Cart cartUpdate) async {
    dbHelper.updateQuantity(Cart(
        id: cartUpdate.id,
        productId: cartUpdate.id,
        productName: cartUpdate.productName,
        discountProduct: cartUpdate.discountProduct,
        initialPrice: cartUpdate.initialPrice,
        productPrice: cartUpdate.productPrice,
        quantity: ValueNotifier(cartUpdate.quantity!.value + 1),
        unitTag: cartUpdate.unitTag,
        image: cartUpdate.image));
    getData();
    addQuantity(cartUpdate.id!);
    addTotalPrice(getDoubleAsync("total_price"));
  }
}
