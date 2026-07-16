class RestaurantModel {
  final String name;
  final String cuisine;
  final String rating;
  final String deliveryTime;
  final String imagePath;
  final bool isOpen;

  const RestaurantModel({
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.imagePath,
    required this.isOpen,
  });
}