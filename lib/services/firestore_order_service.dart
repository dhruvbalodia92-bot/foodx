import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder({
    required String orderId,
    required int totalAmount,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    required Map<String, String>? address,
    required String restaurantId,
    required String restaurantName,
  }) async {

    final user = FirebaseAuth.instance.currentUser;

    await _firestore.collection("orders").doc(orderId).set({
      "orderId": orderId,
      "userId": user?.uid ?? "",
      "phone": user?.phoneNumber ?? "",
      "restaurantId": restaurantId,
      "restaurantName": restaurantName,
      "totalAmount": totalAmount,
      "paymentMethod": paymentMethod,
      "paymentStatus": paymentMethod == "COD"
          ? "Pending"
          : "Paid",
      "items": items,
      "address": address,
      "status": "Pending",
      "deliveryPartnerId": "",
      "deliveryPartnerName": "",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
  Future<void> cancelOrder(String orderId) async {
    await _firestore.collection("orders").doc(orderId).update({
      "status": "Cancelled",
    });
  }
}