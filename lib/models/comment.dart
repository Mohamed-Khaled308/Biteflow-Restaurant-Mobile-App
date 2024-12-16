class Comment {
  final String id;
  final String userId;
  final String restaurantId;
  final String text;
  final DateTime createdAt;
  final double rating;

  Comment({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.text,
    required this.rating,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Comment.fromData(Map<String, dynamic> data) {
    return Comment(
      id: data['id'],
      userId: data['userId'],
      restaurantId: data['restaurantId'],
      text: data['text'],
      rating: data['rating'].toDouble(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'text': text,
      'rating': rating,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}