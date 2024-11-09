import 'package:com.gogospider.booking/model/cart_model.dart';
import 'package:com.gogospider.booking/model/item_model.dart';
import 'package:com.gogospider.booking/network/rest_apis.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart(id INTEGER PRIMARY KEY, productId INTEGER , productName TEXT,discountProduct DOUBLE, initialPrice DOUBLE, productPrice DOUBLE, quantity INTEGER, unitTag TEXT, image TEXT)');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await database;
    if (dbClient != null) await dbClient.insert('cart', cart.toMap());
    return cart;
  }

  // Future<Items> insertApi(Map requset, id) async {
  //   var dbClient = await insertCartResponse(requset, id);
  // }

  Future<List<Cart>> getCartList() async {
    var dbClient = await database;
    if (dbClient == null) {
      return [];
    } else {
      final List<Map<String, Object?>> queryResult =
          await dbClient.query('cart');
      if (queryResult.length != 0)
        return queryResult.map((result) => Cart.fromMap(result)).toList();
      else
        return [];
    }
  }

  Future<List<Items>?> getCartListApi() async {
    var dbClient = await getCartResponse();
    if (dbClient.id == 0) {
      setValue('cart_items', 0);
      return [];
    } else {
      final List<Items>? queryResult = dbClient.items;
      if (dbClient.items != null) {
        // setValue(
        //     'cart_items', queryResult!.isNotEmpty ? queryResult.length : 0);
        return queryResult;
      } else {
        setValue('cart_items', 0);
        return [];
      }
    }
  }

  Future<int> delete(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCartItemApi(int id) async {
    await deleteCartResponse(id);
    return id;
  }

  Future<int> deleteAllCartItem() async {
    var dbClient = await database;
    // await deleteAllCartResponse();
    setValue('cart_items', 0);
    setValue('item_quantity', 0);
    setValue('total_price', 0.0);
    print('Delete All Cart');
    if (dbClient != null)
      return await dbClient.delete('cart');
    else
      return Future(() => 0);
  }

  Future<int> deleteAllCartItemNotApi() async {
    var dbClient = await database;
    print('Delete All Cart');
    return await dbClient!.delete('cart');
  }

  Future<int> updateQuantity(Cart cart) async {
    var dbClient = await database;
    return await dbClient!.update('cart', cart.quantityMap(),
        where: "productId = ?", whereArgs: [cart.productId]);
  }

  Future<int> updateQuantityApi(id, count) async {
    Map? requset = {
      "qty": {"$id": count}
    };
    await updateCartResponse(requset);
    return count;
    // var dbClient = await database;
    // return await dbClient!.update('cart', cart.quantityMap(),
    //     where: "productId = ?", whereArgs: [cart.productId]);
  }

  Future<List<Cart>> getCartId(int id) async {
    var dbClient = await database;
    if (dbClient == null || id == 0) {
      return [];
    }
    final List<Map<String, Object?>> queryIdResult =
        await dbClient.query('cart', where: 'id = ?', whereArgs: [id]);
    return queryIdResult.map((e) => Cart.fromMap(e)).toList();
    // var dbClient = await database;
    // if (id == 0) {
    //   return [];
    // } else {
    //   var dbClientApi = await getCartResponse();
    //   if (dbClient == null || dbClientApi.id == null) {
    //      ();
    //     return [];
    //   } else {
    //     final List<Map<String, Object?>> queryIdResult = await dbClient
    //         .query('cart', where: 'productId = ?', whereArgs: [id]);
    //     return queryIdResult.map((e) => Cart.fromMap(e)).toList();
    //   }
    // }
  }

  Future<List<Items>> getCartIdApi(int id) async {
    var dbClient = await getCartResponse();
    // print("list cart  Cart $id");
    if (dbClient.id == null) {
      return [];
    } else {
      final List<Items> items =
          (dbClient.items as List).map((e) => e as Items).toList();
      // dbClient.items!.firstWhere(
      //   (element) => element.product!.id == id)
      // print("list cart  Cart list id1 $Items.");
      // return items.quantity!.value.validate();
      // return items;
      // if (items != null)
      return items;
    }
  }
}
