import 'package:flutter/material.dart';
import '../restaurant/restaurant_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

                // Location Section
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Colors.orange,
                      size: 28,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
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

                    const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.orange,
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
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

                // Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search for food or restaurants",
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.orange,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
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
                    scrollDirection: Axis.horizontal,
                    children: const [

                      // Pizza
                      _CategoryItem(
                        icon: Icons.local_pizza,
                        name: "Pizza",
                      ),

                      SizedBox(width: 15),

                      // Burger
                      _CategoryItem(
                        icon: Icons.lunch_dining,
                        name: "Burger",
                      ),

                      SizedBox(width: 15),

                      // Indian Food
                      _CategoryItem(
                        icon: Icons.restaurant,
                        name: "Indian",
                      ),

                      SizedBox(width: 15),

                      // Chinese
                      _CategoryItem(
                        icon: Icons.ramen_dining,
                        name: "Chinese",
                      ),

                      SizedBox(width: 15),

                      // Sweets
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

                const _RestaurantCard(
                  name: "FoodX Kitchen",
                  cuisine: "North Indian • Chinese • Fast Food",
                  rating: "4.5",
                  deliveryTime: "25-30 min",
                ),

                const SizedBox(height: 15),

                const _RestaurantCard(
                  name: "Shree Restaurant",
                  cuisine: "Indian • Rajasthani • Thali",
                  rating: "4.3",
                  deliveryTime: "30-35 min",
                ),

                const SizedBox(height: 15),

                const _RestaurantCard(
                  name: "Pizza Hub",
                  cuisine: "Pizza • Burger • Fast Food",
                  rating: "4.2",
                  deliveryTime: "20-25 min",
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _RestaurantCard extends StatelessWidget {
  final String name;
  final String cuisine;
  final String rating;
  final String deliveryTime;

  const _RestaurantCard({
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RestaurantDetailsScreen(
              restaurantName: name,
              cuisine: cuisine,
              rating: rating,
              deliveryTime: deliveryTime,
            ),
          ),
        );
      },

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),

        child: Row(
          children: [
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.restaurant,
                size: 40,
                color: Colors.orange,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    cuisine,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 18,
                        color: Colors.orange,
                      ),

                      const SizedBox(width: 4),

                      Text(rating),

                      const SizedBox(width: 15),

                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.grey,
                      ),

                      const SizedBox(width: 4),

                      Text(deliveryTime),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 35,
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}