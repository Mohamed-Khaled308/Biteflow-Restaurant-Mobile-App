class Restaurant {
  final String id;
  final String name;
  final String managerId;
  final String imageUrl;
  final String location;
  final List<String> itemsIds;
  final double rating;
  final int reviewCount;
  final bool isTableAvailable;
  final String description;

  Restaurant({
    required this.id,
    required this.name,
    required this.managerId,
    required this.imageUrl,
    required this.location,
    this.itemsIds = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isTableAvailable = true,
    this.description = '',
  });

  factory Restaurant.fromData(Map<String, dynamic> data) {
    return Restaurant(
      id: data['id'],
      name: data['name'],
      managerId: data['managerId'],
      imageUrl: data['imageUrl'] ?? '',
      location: data['location'] ?? '',
      itemsIds: (data['itemsIds'] != null && data['itemsIds'] is List)
          ? List<String>.from(data['itemsIds'] as List)
          : [],
      rating: data['rating'].toDouble() ?? 0.0,
      reviewCount: data['reviewCount'] ?? 0,
      isTableAvailable: data['isTableAvailable'] ?? true,
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'managerId': managerId,
      'imageUrl': imageUrl,
      'location': location,
      'itemsIds': itemsIds,
      'rating': rating,
      'reviewCount': reviewCount,
      'isTableAvailable': isTableAvailable,
      'description': description,
    };
  }
}
