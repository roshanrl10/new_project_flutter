class Equipment {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final String imageUrl;
  final int quantity;
  final String brand;
  final bool available;
  final String condition;
  final String location;

  Equipment({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.brand,
    required this.available,
    required this.condition,
    required this.location,
  });
}
