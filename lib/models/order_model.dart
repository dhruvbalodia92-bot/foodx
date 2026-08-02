import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String phone;
  final int totalAmount;
  final String paymentMethod;
  final String paymentStatus;
  final String status;
  final String deliveryPartnerId;
  final String deliveryPartnerName;
  final List<Map<String, dynamic>> items;
  final Map<String, dynamic>? address;
  final Timestamp? createdAt;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.phone,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    required this.deliveryPartnerId,
    required this.deliveryPartnerName,
    required this.items,
    required this.address,
    required this.createdAt,
  });

  factory OrderModel.fromMap(
      Map<String, dynamic> map,
      ) {
    return OrderModel(
      orderId: map["orderId"] ?? "",
      userId: map["userId"] ?? "",
      phone: map["phone"] ?? "",
      totalAmount: map["totalAmount"] ?? 0,
      paymentMethod: map["paymentMethod"] ?? "COD",
      paymentStatus: map["paymentStatus"] ?? "Pending",
      status: map["status"] ?? "Pending",
      deliveryPartnerId:
      map["deliveryPartnerId"] ?? "",
      deliveryPartnerName:
      map["deliveryPartnerName"] ?? "",
      items: List<Map<String, dynamic>>.from(
        map["items"] ?? [],
      ),
      address: map["address"] == null
          ? null
          : Map<String, dynamic>.from(
        map["address"],
      ),
      createdAt: map["createdAt"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "orderId": orderId,
      "userId": userId,
      "phone": phone,
      "totalAmount": totalAmount,
      "paymentMethod": paymentMethod,
      "paymentStatus": paymentStatus,
      "status": status,
      "deliveryPartnerId": deliveryPartnerId,
      "deliveryPartnerName":
      deliveryPartnerName,
      "items": items,
      "address": address,
      "createdAt": createdAt,
    };
  }
}