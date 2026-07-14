import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  // Cart ke saare items
  List<CartItem> get items => _items;

  // Total different items
  int get itemCount => _items.length;

  // Total quantity
  int get totalQuantity {
    return _items.fold(
      0,
          (total, item) => total + item.quantity,
    );
  }

  // Total cart price
  int get totalPrice {
    return _items.fold(
      0,
          (total, item) => total + item.totalPrice,
    );
  }

  // Item add karo
  void addItem(String name, int price) {
    final index = _items.indexWhere(
          (item) => item.name == name,
    );

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(
        CartItem(
          name: name,
          price: price,
        ),
      );
    }

    notifyListeners();
  }

  // Quantity kam karo
  void removeOneItem(String name) {
    final index = _items.indexWhere(
          (item) => item.name == name,
    );

    if (index == -1) return;

    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  // Kisi item ki current quantity
  int getQuantity(String name) {
    final index = _items.indexWhere(
          (item) => item.name == name,
    );

    if (index == -1) {
      return 0;
    }

    return _items[index].quantity;
  }

  // Pura cart clear karo
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}