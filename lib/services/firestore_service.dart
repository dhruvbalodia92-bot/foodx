import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<RestaurantModel>> getRestaurants() {
    return _firestore
        .collection('restaurants')
        .where('status', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RestaurantModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}