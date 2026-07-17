import 'package:flutter/material.dart';
import '../../models/restaurant_model.dart';
import '../../widgets/restaurant_card.dart';
import '../../services/firestore_service.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.grey[100],

body: SafeArea(
child: SingleChildScrollView(
child: Padding(
padding: const EdgeInsets.all(20),

child: Column(
crossAxisAlignment: CrossAxisAlignment.start,

children: [

/// Location
Row(
children: [

const Icon(
Icons.location_on,
color: Colors.orange,
size: 28,
),

const SizedBox(width: 8),

const Expanded(
child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,
children: [

Text(
"Deliver to",
style: TextStyle(
fontSize: 13,
color: Colors.grey,
),
),

Text(
"Phulera, Rajasthan",
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
),
),
],
),
),

InkWell(
borderRadius:
BorderRadius.circular(50),

onTap: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) =>
const ProfileScreen(),
),
);
},

child: const CircleAvatar(
radius: 22,
backgroundColor: Colors.orange,
child: Icon(
Icons.person,
color: Colors.white,
),
),
),
],
),

const SizedBox(height: 30),

const Text(
"What would you like\nto eat today? 🍔",
style: TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
height: 1.2,
),
),

const SizedBox(height: 25),

TextField(
decoration: InputDecoration(
hintText:
"Search food or restaurant",

prefixIcon: const Icon(
Icons.search,
color: Colors.orange,
),

filled: true,
fillColor: Colors.white,

border: OutlineInputBorder(
borderRadius:
BorderRadius.circular(15),
borderSide:
BorderSide.none,
),
),
),

const SizedBox(height: 30),

const Text(
"Categories",
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 15),

SizedBox(
height: 100,

child: ListView(
scrollDirection:
Axis.horizontal,

children: const [

_CategoryItem(
icon: Icons.local_pizza,
name: "Pizza",
),

SizedBox(width: 15),

_CategoryItem(
icon:
Icons.lunch_dining,
name: "Burger",
),

SizedBox(width: 15),

_CategoryItem(
icon:
Icons.restaurant,
name: "Indian",
),

SizedBox(width: 15),

_CategoryItem(
icon:
Icons.ramen_dining,
name: "Chinese",
),

SizedBox(width: 15),

_CategoryItem(
icon: Icons.cake,
name: "Sweets",
),
],
),
),

const SizedBox(height: 30),

const Text(
"Popular Restaurants",
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 15),

  FutureBuilder<List<RestaurantModel>>(
    future: _firestoreService.getRestaurants(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (snapshot.hasError) {
        return Center(
          child: Text("Error: ${snapshot.error}"),
        );
      }

      final restaurants = snapshot.data ?? [];

      if (restaurants.isEmpty) {
        return const Center(
          child: Text("No Restaurants Found"),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: restaurants.length,
        separatorBuilder: (context, index) =>
        const SizedBox(height: 15),
        itemBuilder: (context, index) {
          return RestaurantCard(
            restaurant: restaurants[index],
          );
        },
      );
    },
  ),
],
),
),
),
),
);
}
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String name;

  const _CategoryItem({
    required this.icon,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.orange.shade50,
            child: Icon(
              icon,
              color: Colors.orange,
              size: 28,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}