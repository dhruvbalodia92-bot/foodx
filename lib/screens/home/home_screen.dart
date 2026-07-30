import 'package:flutter/material.dart';

import '../../models/restaurant_model.dart';
import '../../services/firestore_service.dart';
import '../../widgets/restaurant_card.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
final FirestoreService _firestoreService = FirestoreService();

final TextEditingController _searchController =
TextEditingController();

String _searchQuery = "";
String _selectedCategory = "All";

@override
void dispose() {
_searchController.dispose();
super.dispose();
}

List<RestaurantModel> _filterRestaurants(
List<RestaurantModel> restaurants) {
return restaurants.where((restaurant) {
final matchesSearch = restaurant.name
.toLowerCase()
.contains(_searchQuery.toLowerCase());

final matchesCategory =
_selectedCategory == "All" ||
restaurant.cuisine
.toLowerCase()
.contains(
_selectedCategory.toLowerCase(),
);

return matchesSearch && matchesCategory;
}).toList();
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.grey.shade100,

body: SafeArea(
child: SingleChildScrollView(
child: Padding(
padding: const EdgeInsets.all(20),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [

/// HEADER

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

SizedBox(height: 2),

Text(
"Phulera, Rajasthan",
style: TextStyle(
fontSize: 18,
fontWeight:
FontWeight.bold,
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
backgroundColor:
Colors.orange,
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
"What would you like\n"
"to eat today? 🍔",
style: TextStyle(
fontSize: 30,
fontWeight: FontWeight.bold,
height: 1.2,
),
),

const SizedBox(height: 25),

TextField(
controller: _searchController,

onChanged: (value) {
setState(() {
_searchQuery = value;
});
},

decoration: InputDecoration(
hintText:
"Search food or restaurant",

prefixIcon: const Icon(
Icons.search,
color: Colors.orange,
),

suffixIcon:
_searchQuery.isNotEmpty
? IconButton(
onPressed: () {
_searchController.clear();

setState(() {
_searchQuery = "";
});
},
icon: const Icon(
Icons.close,
),
)
: null,

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
scrollDirection: Axis.horizontal,
children: [
_CategoryItem(
icon: Icons.apps,
name: "All",
isSelected: _selectedCategory == "All",
onTap: () {
setState(() {
_selectedCategory = "All";
});
},
),

const SizedBox(width: 15),

_CategoryItem(
icon: Icons.local_pizza,
name: "Pizza",
isSelected: _selectedCategory == "Pizza",
onTap: () {
setState(() {
_selectedCategory = "Pizza";
});
},
),

const SizedBox(width: 15),

_CategoryItem(
icon: Icons.lunch_dining,
name: "Burger",
isSelected: _selectedCategory == "Burger",
onTap: () {
setState(() {
_selectedCategory = "Burger";
});
},
),

const SizedBox(width: 15),

_CategoryItem(
icon: Icons.restaurant,
name: "Indian",
isSelected: _selectedCategory == "Indian",
onTap: () {
setState(() {
_selectedCategory = "Indian";
});
},
),

const SizedBox(width: 15),

_CategoryItem(
icon: Icons.ramen_dining,
name: "Chinese",
isSelected: _selectedCategory == "Chinese",
onTap: () {
setState(() {
_selectedCategory = "Chinese";
});
},
),

const SizedBox(width: 15),

_CategoryItem(
icon: Icons.cake,
name: "Sweets",
isSelected: _selectedCategory == "Sweets",
onTap: () {
setState(() {
_selectedCategory = "Sweets";
});
},
),
],
),
),

const SizedBox(height: 30),

Row(
mainAxisAlignment:
MainAxisAlignment.spaceBetween,
children: [
const Text(
"Popular Restaurants",
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
),
),

if (_searchQuery.isNotEmpty ||
_selectedCategory != "All")
TextButton(
onPressed: () {
_searchController.clear();

setState(() {
_searchQuery = "";
_selectedCategory = "All";
});
},
child: const Text(
"Clear",
style: TextStyle(
color: Colors.orange,
fontWeight: FontWeight.bold,
),
),
),
],
),

const SizedBox(height: 15),

StreamBuilder<List<RestaurantModel>>(
stream:
_firestoreService.getRestaurants(),
builder: (context, snapshot) {

if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child:
CircularProgressIndicator(),
);
}

if (snapshot.hasError) {
return Center(
child: Text(
"Error: ${snapshot.error}",
),
);
}

final restaurants =
snapshot.data ?? [];

final filteredRestaurants =
_filterRestaurants(
restaurants);
return Column(
  crossAxisAlignment:
  CrossAxisAlignment.start,
  children: [

    Text(
      "${filteredRestaurants.length} Restaurants",
      style: TextStyle(
        color: Colors.grey.shade700,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
    ),

    const SizedBox(height: 15),

    if (filteredRestaurants.isEmpty)
      const Padding(
        padding:
        EdgeInsets.symmetric(
          vertical: 50,
        ),
        child: Center(
          child: Column(
            children: [

              Icon(
                Icons.search_off,
                size: 70,
                color: Colors.grey,
              ),

              SizedBox(height: 15),

              Text(
                "No Restaurants Found",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )
    else
      ListView.separated(
        shrinkWrap: true,
        physics:
        const NeverScrollableScrollPhysics(),

        itemCount:
        filteredRestaurants.length,

        separatorBuilder:
            (_, __) =>
        const SizedBox(
          height: 15,
        ),

        itemBuilder:
            (context, index) {

          return RestaurantCard(
            restaurant:
            filteredRestaurants[
            index],
          );
        },
      ),
  ],
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
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 85,
          decoration: BoxDecoration(
            color: isSelected ? Colors.orange : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
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
                backgroundColor: isSelected
                    ? Colors.white
                    : Colors.orange.shade50,
                child: Icon(
                  icon,
                  color: Colors.orange,
                  size: 28,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isSelected
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}