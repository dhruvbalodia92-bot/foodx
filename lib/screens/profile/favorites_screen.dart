import 'package:flutter/material.dart';

import '../../models/restaurant_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/restaurant_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
final FirestoreService _firestoreService = FirestoreService();

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.grey.shade100,

appBar: AppBar(
elevation: 0,
centerTitle: true,
title: const Text(
"My Favorites",
style: TextStyle(
fontWeight: FontWeight.bold,
),
),
),

body: StreamBuilder<List<RestaurantModel>>(
stream: _firestoreService.getFavoriteRestaurants(),
builder: (context, snapshot) {
if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

if (snapshot.hasError) {
return Center(
child: Text(
snapshot.error.toString(),
),
);
}

final favorites = snapshot.data ?? [];

if (favorites.isEmpty) {
return const Center(
child: Padding(
padding: EdgeInsets.all(30),
child: Column(
mainAxisAlignment:
MainAxisAlignment.center,
children: [
Icon(
Icons.favorite_border,
color: Colors.red,
size: 80,
),

SizedBox(height: 20),

Text(
"No Favorites Yet",
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),

SizedBox(height: 10),

Text(
"Tap the ❤️ icon on any restaurant to save it here.",
textAlign: TextAlign.center,
style: TextStyle(
color: Colors.grey,
fontSize: 16,
),
),
],
),
),
);
}

return ListView.separated(
padding: const EdgeInsets.all(16),
itemCount: favorites.length,
separatorBuilder: (_, __) =>
const SizedBox(height: 16),
itemBuilder: (context, index) {
final restaurant = favorites[index];

return RestaurantCard(
restaurant: restaurant,
);
},
);
},
),
);
}
}