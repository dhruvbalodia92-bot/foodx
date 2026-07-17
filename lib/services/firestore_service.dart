import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/restaurant_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RestaurantModel>> getRestaurants() async {
    final snapshot = await _firestore.collection('restaurants').get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      print(data);

      return RestaurantModel(
        id: doc.id,
        name: data['name'] ?? '',
        cuisine: data['cuisine'] ?? '',
        rating: data['rating'].toString(),
        deliveryTime: data['deliveryTime'] ?? '',
        imagePath: data['imagePath'] ?? '',
        isOpen: data['isOpen'] ?? false,
      );
    }).toList();
  }
}