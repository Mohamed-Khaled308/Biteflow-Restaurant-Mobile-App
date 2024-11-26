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
    required this.location,
    this.imageUrl = '',
    this.description = '',
    this.itemsIds = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isTableAvailable = true,
  });

  factory Restaurant.fromData(Map<String, dynamic> data) {
    return Restaurant(
      id: data['id'],
      name: data['name'],
      managerId: data['managerId'],
      location: data['location'],
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      itemsIds: (data['itemsIds'] != null && data['itemsIds'] is List)
          ? List<String>.from(data['itemsIds'] as List)
          : [],
      rating: data['rating'].toDouble() ?? 0.0,
      reviewCount: data['reviewCount'] ?? 0,
      isTableAvailable: data['isTableAvailable'] ?? true,
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
