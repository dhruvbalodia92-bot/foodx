class MenuModel {
  final String id;
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final String category;
  final bool available;

  const MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.available,
  });
}