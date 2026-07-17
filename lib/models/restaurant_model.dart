class RestaurantModel {
  final String id;
  final String name;
  final String cuisine;
  final String rating;
  final String deliveryTime;
  final String imagePath;
  final bool isOpen;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.deliveryTime,
    required this.imagePath,
    required this.isOpen,
  });
}