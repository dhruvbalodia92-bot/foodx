import '../models/restaurant_model.dart';

const List<RestaurantModel> dummyRestaurants = [
  RestaurantModel(
    id: "1",
    name: "FoodX Kitchen",
    cuisine: "North Indian • Chinese • Fast Food",
    rating: "4.5",
    deliveryTime: "25-30 min",
    imagePath: "assets/images/restaurants/foodx_kitchen.jpg",
    isOpen: true,
  ),

  RestaurantModel(
    id: "2",
    name: "Shree Restaurant",
    cuisine: "Indian • Rajasthani • Thali",
    rating: "4.3",
    deliveryTime: "30-35 min",
    imagePath: "assets/images/restaurants/shree_restaurant.jpg",
    isOpen: true,
  ),

  RestaurantModel(
    id: "3",
    name: "Pizza Hub",
    cuisine: "Pizza • Burger • Fast Food",
    rating: "4.2",
    deliveryTime: "20-25 min",
    imagePath: "assets/images/restaurants/pizza_hub.jpg",
    isOpen: false,
  ),
];