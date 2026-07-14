import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../cart/cart_screen.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  final String restaurantName;
  final String cuisine;
  final String rating;
  final String deliveryTime;

  const RestaurantDetailsScreen({
    super.key,
    required this.restaurantName,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: Text(
          restaurantName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // VIEW CART BAR
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${cart.totalQuantity} item${cart.totalQuantity > 1 ? 's' : ''}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 3),

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
                          builder: (context) => const CartScreen(),
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant Image Placeholder
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.restaurant,
                  size: 80,
                  color: Colors.orange,
                ),
              ),

              const SizedBox(height: 25),

              Text(
                restaurantName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                cuisine,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  ),

                  const SizedBox(width: 5),

                  Text(
                    rating,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 20),

                  const Icon(
                    Icons.access_time,
                    color: Colors.grey,
                    size: 20,
                  ),

                  const SizedBox(width: 5),

                  Text(deliveryTime),
                ],
              ),

              const SizedBox(height: 30),

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

              const _MenuItem(
                name: "Margherita Pizza",
                description: "Classic pizza with cheese and tomato sauce",
                price: 199,
                imagePath: "assets/images/pizza.jpg",
              ),

              const SizedBox(height: 15),

              const _MenuItem(
                name: "Veg Burger",
                description: "Crispy veg patty with fresh vegetables",
                price: 99,
                imagePath: "assets/images/veg burger.jpg",
              ),

              const SizedBox(height: 15),

              const _MenuItem(
                name: "Paneer Tikka",
                description: "Spicy grilled paneer with vegetables",
                price: 249,
                imagePath: "assets/images/paneer tika.jpg",
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final String imagePath;

  const _MenuItem({
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final quantity = cart.getQuantity(name);

    return Container(
      width: double.infinity,
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
                // Veg Indicator
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
                    ),
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
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "₹$price",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Dish Image + ADD Button
          Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: 100,
                  height: 85,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 8),

              quantity == 0
                  ? OutlinedButton(
                onPressed: () {
                  context.read<CartProvider>().addItem(
                    name,
                    price,
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
                            .removeOneItem(name);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),

                    Text(
                      quantity.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        context.read<CartProvider>().addItem(
                          name,
                          price,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
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