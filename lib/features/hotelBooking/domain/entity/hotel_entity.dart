class Hotel {
  final String id;
  final String name;
  final String location;
  final String description;
  final List<String> services;
  final double price;
  final String imageUrl;
  final double rating;
  final bool available;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.services,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.available,
  });
}
