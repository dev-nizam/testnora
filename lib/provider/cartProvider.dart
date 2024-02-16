//
//
//
// import 'package:flutter/cupertino.dart';
//
//
//
// class CartItem {
//   final int id;
//   final String title;
//   final double price;
//   int qty;
//   final String image;
//
//   CartItem({
//     required this.id,
//     required this.title,
//     required this.price,
//     required this.qty,
//     required this.image,
//   });
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'title': title,
//       'price': price,
//       'qty': qty,
//       'image': image,
//     };
//   }
//
//   static CartItem fromMap(Map<String, dynamic> map) {
//     return CartItem(
//       id: map['id'],
//       title: map['title'],
//       price: map['price'],
//       qty: map['qty'],
//       image: map['image'],
//     );
//   }
//
// }
//
// // Provider class for managing the shopping cart
// class CartProvider extends ChangeNotifier {
//
//   List<CartItem> _cartItems = [];
//
//   // Getter to access the cart items
//   List<CartItem> get cartItems => _cartItems;
//
//   // Method to add an item to the cart
//   void addItemToCart(CartItem item) {
//     _cartItems.add(item);
//     notifyListeners();
//   }
//
//   // Method to remove an item from the cart
//   void removeItemFromCart(CartItem item) {
//     _cartItems.remove(item);
//     notifyListeners();
//   }
//
//   // Method to update the quantity of an item in the cart
//   void updateItemQuantity(CartItem item, int newQuantity) {
//     item.qty = newQuantity;
//     notifyListeners();
//   }
//
//   // Method to calculate the total price of items in the cart
//   double calculateTotalPrice() {
//     double totalPrice = 0.0;
//     for (var item in _cartItems) {
//       totalPrice += item.price * item.qty;
//     }
//     return totalPrice;
//   }}


import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class CartItem {
  final int id;
  final String title;
  final double price;
  int qty;
  final String image;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.qty,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'qty': qty,
      'image': image,
    };
  }

  static CartItem fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      title: map['title'],
      price: map['price'],
      qty: map['qty'],
      image: map['image'],
    );
  }
}

// Provider class for managing the shopping cart
class CartProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  late Database _database;
  static const String _cartTable = 'cart';

  // Getter to access the cart items
  List<CartItem> get cartItems => _cartItems;

  CartProvider() {
    // Initialize database
    _initDatabase();
  }

  // Initialize the SQLite database
  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'cart_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_cartTable(id INTEGER PRIMARY KEY, title TEXT, price REAL, qty INTEGER, image TEXT)',
        );
      },
      version: 1,
    );
    // Load cart items from database when the provider is initialized
    _loadCartItems();
  }

  // Method to add an item to the cart
  Future<void> addItemToCart(CartItem item) async {
    _cartItems.add(item);
    await _database.insert(
      _cartTable,
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    notifyListeners();
  }

  // Method to remove an item from the cart
  Future<void> removeItemFromCart(CartItem item) async {
    _cartItems.remove(item);
    await _database.delete(
      _cartTable,
      where: 'id = ?',
      whereArgs: [item.id],
    );
    notifyListeners();
  }

  // Method to update the quantity of an item in the cart
  Future<void> updateItemQuantity(CartItem item, int newQuantity) async {
    item.qty = newQuantity;
    await _database.update(
      _cartTable,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
    notifyListeners();
  }

  // Method to calculate the total price of items in the cart
  double calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in _cartItems) {
      totalPrice += item.price * item.qty;
    }
    return totalPrice;
  }

  // Method to load cart items from the database
  Future<void> _loadCartItems() async {
    final List<Map<String, dynamic>> maps = await _database.query(_cartTable);
    _cartItems = List.generate(
      maps.length,
          (i) {
        return CartItem(
          id: maps[i]['id'],
          title: maps[i]['title'],
          price: maps[i]['price'],
          qty: maps[i]['qty'],
          image: maps[i]['image'],
        );
      },
    );
  }
}