import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  final List<String> popularSearches = [
    "Pizza",
    "Burger",
    "Paneer",
    "Chinese",
    "Thali",
    "Sandwich",
  ];

  final List<String> restaurants = [
    "FoodX Kitchen",
    "Shree Restaurant",
    "Pizza Hub",
    "Royal Tadka",
    "Indian Spice",
  ];

  List<String> filteredRestaurants = [];

  @override
  void initState() {
    super.initState();
    filteredRestaurants = restaurants;
  }

  void search(String value) {
    setState(() {
      filteredRestaurants = restaurants
          .where((restaurant) =>
          restaurant.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          "Search",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
              onChanged: search,
              decoration: InputDecoration(
                hintText: "Search food or restaurant",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Popular Searches",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: popularSearches.map((item) {
                return Chip(
                  label: Text(item),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),

            const Text(
              "Restaurants",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: filteredRestaurants.isEmpty
                  ? const Center(
                child: Text(
                  "No restaurant found",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredRestaurants.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.restaurant,
                        color: Colors.orange,
                      ),
                      title: Text(filteredRestaurants[index]),
                      trailing: const Icon(Icons.chevron_right),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}