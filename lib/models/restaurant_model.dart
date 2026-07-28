import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String ownerName;
  final String phone;
  final String email;
  final String address;

  final String cuisine;
  final String rating;
  final String deliveryTime;
  final String imageUrl;

  final String openingTime;
  final String closingTime;

  final bool status;

  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.address,

    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.imageUrl,

    required this.openingTime,
    required this.closingTime,

    required this.status,

    this.createdAt,
    this.updatedAt,
  });

  factory RestaurantModel.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return RestaurantModel(
      id: documentId,
      name: map['name'] ?? '',
      ownerName: map['ownerName'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',

      cuisine: map['cuisine'] ?? '',
      rating: map['rating']?.toString() ?? '0.0',
      deliveryTime: map['deliveryTime'] ?? '',
      imageUrl: map['imageUrl'] ?? '',

      openingTime: map['openingTime'] ?? '',
      closingTime: map['closingTime'] ?? '',

      status: map['status'] ?? true,

      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'ownerName': ownerName,
      'phone': phone,
      'email': email,
      'address': address,

      'cuisine': cuisine,
      'rating': rating,
      'deliveryTime': deliveryTime,
      'imageUrl': imageUrl,

      'openingTime': openingTime,
      'closingTime': closingTime,

      'status': status,

      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}