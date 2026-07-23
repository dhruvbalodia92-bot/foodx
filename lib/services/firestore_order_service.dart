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
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    await _firestore.collection("orders").doc(orderId).set({
      "orderId": orderId,
      "userId": user?.uid ?? "",
      "phone": user?.phoneNumber ?? "",
      "totalAmount": totalAmount,
      "paymentMethod": paymentMethod,
      "items": items,
      "address": address,
      "status": "Pending",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}