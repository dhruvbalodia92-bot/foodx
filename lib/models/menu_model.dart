class MenuModel {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imagePath;
  final bool isAvailable;

  const MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.isAvailable,
  });
}