class PromotionalOffer {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String title;
  final String description;
  final String imageUrl;
  final DateTime startDate;
  final DateTime endDate;
  final double discount;
  final bool isActive;

  PromotionalOffer({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.startDate,
    required this.endDate,
    required this.discount,
    this.isActive = true,
  });

  factory PromotionalOffer.fromData(Map<String, dynamic> data) {
    return PromotionalOffer(
      id: data['id'],
      restaurantId: data['restaurantId'],
      restaurantName: data['restaurantName'],
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      startDate: DateTime.parse(data['startDate']),
      endDate: DateTime.parse(data['endDate']),
      discount: data['discount'].toDouble(),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'discount': discount,
      'isActive': isActive,
    };
  }
}