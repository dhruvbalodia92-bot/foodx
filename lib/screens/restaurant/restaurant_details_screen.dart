import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/menu_model.dart';
import '../../providers/cart_provider.dart';
import '../../services/menu_service.dart';
import '../cart/cart_screen.dart';

class RestaurantDetailsScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;
  final String cuisine;
  final String rating;
  final String deliveryTime;
  final String imagePath;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.imagePath,
  });

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
final MenuService _menuService = MenuService();

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.grey[100],

appBar: AppBar(
title: Text(
widget.restaurantName,
style: const TextStyle(
fontWeight: FontWeight.bold,
),
),
),

bottomNavigationBar: Consumer<CartProvider>(
builder: (context, cart, child) {
if (cart.totalQuantity == 0) {
return const SizedBox.shrink();
}

return SafeArea(
child: Container(
margin: const EdgeInsets.all(15),
padding: const EdgeInsets.symmetric(
horizontal: 20,
vertical: 15,
),
decoration: BoxDecoration(
color: Colors.orange,
borderRadius: BorderRadius.circular(15),
),
child: Row(
children: [
Expanded(
child: Column(
mainAxisSize: MainAxisSize.min,
crossAxisAlignment:
CrossAxisAlignment.start,
children: [
Text(
"${cart.totalQuantity} item${cart.totalQuantity > 1 ? 's' : ''}",
style: const TextStyle(
color: Colors.white,
),
),

const SizedBox(height: 4),

Text(
"₹${cart.totalPrice}",
style: const TextStyle(
color: Colors.white,
fontSize: 18,
fontWeight: FontWeight.bold,
),
),
],
),
),

TextButton(
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(
builder: (_) => const CartScreen(),
),
);
},
child: const Row(
children: [
Text(
"VIEW CART",
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
SizedBox(width: 5),
Icon(
Icons.arrow_forward,
color: Colors.white,
),
],
),
),
],
),
),
);
},
),

body: FutureBuilder<List<MenuModel>>(
future: _menuService.getMenu(widget.restaurantId),

builder: (context, snapshot) {

if (snapshot.connectionState ==
ConnectionState.waiting) {
return const Center(
child: CircularProgressIndicator(),
);
}

if (snapshot.hasError) {
return Center(
child: Text(snapshot.error.toString()),
);
}

final menu = snapshot.data ?? [];

return SingleChildScrollView(
child: Padding(
padding: const EdgeInsets.all(20),

child: Column(
crossAxisAlignment:
CrossAxisAlignment.start,

children: [

ClipRRect(
borderRadius:
BorderRadius.circular(20),

child: Image.network(
widget.imagePath,
height: 180,
width: double.infinity,
fit: BoxFit.cover,
),
),

const SizedBox(height: 25),

Text(
widget.restaurantName,
style: const TextStyle(
fontSize: 28,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 8),

Text(
widget.cuisine,
style: const TextStyle(
color: Colors.grey,
),
),

const SizedBox(height: 15),

Row(
children: [

const Icon(
Icons.star,
color: Colors.orange,
),

const SizedBox(width: 5),

Text(widget.rating),

const SizedBox(width: 20),

const Icon(
Icons.access_time,
color: Colors.grey,
),

const SizedBox(width: 5),

Text(widget.deliveryTime),
],
),

const SizedBox(height: 25),

const Divider(),

const SizedBox(height: 20),

const Text(
"Menu",
style: TextStyle(
fontSize: 24,
fontWeight: FontWeight.bold,
),
),

const SizedBox(height: 20),

if (menu.isEmpty)
const Center(
child: Text(
"No Menu Available",
),
),

// 👇 Part 2 yahin se continue hoga
  if (menu.isNotEmpty)
    ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menu.length,
      separatorBuilder: (context, index) =>
      const SizedBox(height: 15),
      itemBuilder: (context, index) {
        return _MenuItem(menu: menu[index]);
      },
    ),
],
),
),
);
},
),
);
}
}

class _MenuItem extends StatelessWidget {
  final MenuModel menu;

  const _MenuItem({
    required this.menu,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final quantity = cart.getQuantity(menu.name);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: const Center(
                    child: CircleAvatar(
                      radius: 4,
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  menu.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  menu.description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "₹${menu.price}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                if (!menu.isAvailable)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      "Currently Unavailable",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  menu.imagePath,
                  width: 100,
                  height: 85,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 85,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.fastfood),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              if (menu.isAvailable)
                quantity == 0
                    ? OutlinedButton(
                  onPressed: () {
                    context.read<CartProvider>().addItem(
                      menu.name,
                      menu.price,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    side: const BorderSide(
                      color: Colors.orange,
                    ),
                  ),
                  child: const Text(
                    "ADD",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          context
                              .read<CartProvider>()
                              .removeOneItem(menu.name);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      Text(
                        quantity.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          context.read<CartProvider>().addItem(
                            menu.name,
                            menu.price,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}