import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_model.dart';

class MenuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<MenuModel>> getMenu(String restaurantId) async {
    final snapshot = await _firestore
        .collection('restaurants')
        .doc(restaurantId)
        .collection('menu')
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return MenuModel(
        id: doc.id,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        price: (data['price'] as num).toInt(),
        imagePath: data['imagePath'] ?? '',
        isAvailable: data['isAvailable'] ?? true,
      );
    }).toList();
  }
}