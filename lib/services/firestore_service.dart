import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/address_model.dart';
import '../models/restaurant_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ===========================
  // User
  // ===========================

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> get _favoriteCollection {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('favorites');
  }

  // ===========================
  // Restaurants
  // ===========================

  Stream<List<RestaurantModel>> getRestaurants() {
    return _firestore
        .collection('restaurants')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return RestaurantModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  // ===========================
  // Favorites
  // ===========================

  Future<void> addToFavorites(String restaurantId) async {
    if (_uid == null) return;

    await _favoriteCollection.doc(restaurantId).set({
      'restaurantId': restaurantId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
  // ===========================
// Addresses
// ===========================

  CollectionReference<Map<String, dynamic>> get _addressCollection {
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('addresses');
  }

  Stream<List<AddressModel>> getAddresses() {
    if (_uid == null) {
      return Stream.value([]);
    }

    return _addressCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AddressModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  Future<void> addAddress(AddressModel address) async {
    if (_uid == null) return;

    await _addressCollection.add(address.toMap());
  }

  Future<void> updateAddress(AddressModel address) async {
    if (_uid == null) return;

    await _addressCollection
        .doc(address.id)
        .update(address.toMap());
  }

  Future<void> deleteAddress(String addressId) async {
    if (_uid == null) return;

    await _addressCollection
        .doc(addressId)
        .delete();
  }

  Future<void> setDefaultAddress(String addressId) async {
    if (_uid == null) return;

    final docs = await _addressCollection.get();

    for (final doc in docs.docs) {
      await doc.reference.update({
        'isDefault': false,
      });
    }

    await _addressCollection.doc(addressId).update({
      'isDefault': true,
    });
  }

  Future<void> removeFromFavorites(String restaurantId) async {
    if (_uid == null) return;

    await _favoriteCollection.doc(restaurantId).delete();
  }

  Stream<bool> isFavorite(String restaurantId) {
    if (_uid == null) {
      return Stream.value(false);
    }

    return _favoriteCollection
        .doc(restaurantId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Stream<List<String>> getFavoriteIds() {
    if (_uid == null) {
      return Stream.value([]);
    }

    return _favoriteCollection.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.id).toList(),
    );
  }

  Stream<List<RestaurantModel>> getFavoriteRestaurants() {
    if (_uid == null) {
      return Stream.value([]);
    }

    return _favoriteCollection.snapshots().asyncMap((favoriteSnapshot) async {
      if (favoriteSnapshot.docs.isEmpty) {
        return <RestaurantModel>[];
      }

      List<RestaurantModel> restaurants = [];

      for (final favorite in favoriteSnapshot.docs) {
        final restaurantDoc = await _firestore
            .collection('restaurants')
            .doc(favorite.id)
            .get();

        if (restaurantDoc.exists) {
          restaurants.add(
            RestaurantModel.fromMap(
              restaurantDoc.data()!,
              restaurantDoc.id,
            ),
          );
        }
      }

      return restaurants;
    });
  }
}