import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderStorageService {
  static const String _ordersKey = 'foodx_saved_orders';

  static Future<void> saveOrder({
    required String orderId,
    required int totalAmount,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> savedOrders =
        prefs.getStringList(_ordersKey) ?? [];

    final Map<String, dynamic> newOrder = {
      'orderId': orderId,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'items': items,
      'status': 'Order Placed',
      'orderDate': DateTime.now().toIso8601String(),
    };

    savedOrders.insert(
      0,
      jsonEncode(newOrder),
    );

    await prefs.setStringList(
      _ordersKey,
      savedOrders,
    );
  }

  static Future<List<Map<String, dynamic>>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final List<String> savedOrders =
        prefs.getStringList(_ordersKey) ?? [];

    return savedOrders.map((orderJson) {
      return Map<String, dynamic>.from(
        jsonDecode(orderJson),
      );
    }).toList();
  }
}