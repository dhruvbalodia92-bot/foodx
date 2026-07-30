import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/restaurant_model.dart';
import '../screens/restaurant/restaurant_details_screen.dart';
import '../services/firestore_service.dart';

class RestaurantCard extends StatefulWidget {
  final RestaurantModel restaurant;

  const RestaurantCard({
    super.key,
    required this.restaurant,
  });

  @override
  State<RestaurantCard> createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
final FirestoreService _firestoreService = FirestoreService();

String? get _uid => FirebaseAuth.instance.currentUser?.uid;

@override
Widget build(BuildContext context) {
return StreamBuilder<bool>(
stream: _firestoreService.isFavorite(widget.restaurant.id),
builder: (context, snapshot) {
final bool isFavorite = snapshot.data ?? false;

return InkWell(
borderRadius: BorderRadius.circular(18),
onTap: () {
if (!widget.restaurant.status) {
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text("Restaurant is currently closed"),
),
);
return;
}

Navigator.push(
context,
MaterialPageRoute(
builder: (_) => RestaurantDetailsScreen(
restaurant: widget.restaurant,
),
),
);
},
child: Card(
elevation: 3,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
clipBehavior: Clip.antiAlias,
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Stack(
children: [
Image.network(
widget.restaurant.imageUrl,
height: 170,
width: double.infinity,
fit: BoxFit.cover,
errorBuilder: (context, error, stackTrace) {
return Container(
height: 170,
color: Colors.grey.shade300,
child: const Center(
child: Icon(
Icons.restaurant,
size: 50,
),
),
);
},
),

Positioned(
top: 10,
left: 10,
child: Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 5,
),
decoration: BoxDecoration(
color: widget.restaurant.status
? Colors.green
: Colors.red,
borderRadius: BorderRadius.circular(20),
),
child: Text(
widget.restaurant.status
? "OPEN"
: "CLOSED",
style: const TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
fontSize: 11,
),
),
),
),

// ❤️ Favorite Button
  Positioned(
    top: 10,
    right: 10,
    child: CircleAvatar(
      backgroundColor: Colors.white,
      child: IconButton(
        splashRadius: 20,
        icon: Icon(
          isFavorite
              ? Icons.favorite
              : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () async {
          if (_uid == null) return;

          if (isFavorite) {
            await _firestoreService.removeFromFavorites(
              widget.restaurant.id,
            );
          } else {
            await _firestoreService.addToFavorites(
              widget.restaurant.id,
            );
          }
        },
      ),
    ),
  ),
],
),

  Padding(
padding: const EdgeInsets.all(15),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
widget.restaurant.name,
style: const TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 6),

Text(
widget.restaurant.cuisine,
style: const TextStyle(
color: Colors.grey,
),
),

const SizedBox(height: 12),

Row(
children: [
const Icon(
Icons.star,
color: Colors.orange,
size: 18,
),

const SizedBox(width: 5),

Text(widget.restaurant.rating),

const Spacer(),

const Icon(
Icons.access_time,
color: Colors.grey,
size: 18,
),

const SizedBox(width: 5),

Text(widget.restaurant.deliveryTime),
],
),

const SizedBox(height: 12),

Row(
children: [
Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 5,
),
decoration: BoxDecoration(
color: Colors.green.shade50,
borderRadius: BorderRadius.circular(20),
),
child: const Text(
"FREE Delivery",
style: TextStyle(
color: Colors.green,
fontWeight: FontWeight.bold,
),
),
),

const SizedBox(width: 10),

Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 5,
),
decoration: BoxDecoration(
color: Colors.orange.shade50,
borderRadius: BorderRadius.circular(20),
),
child: const Text(
"₹30 OFF",
style: TextStyle(
color: Colors.orange,
fontWeight: FontWeight.bold,
),
),
),
],
),
],
),
),
  ],
),
),
  );
},
);
}
}