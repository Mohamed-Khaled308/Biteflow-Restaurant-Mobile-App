class Restaurant {
  final String imageUrl;
  final String name;
  final String location;
  final double rating;
  final int reviewCount;
  final bool isTableAvailable;
  final String description;

  Restaurant({
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.isTableAvailable,
    required this.description,
  });
}
