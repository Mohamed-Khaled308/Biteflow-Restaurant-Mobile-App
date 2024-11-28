abstract class Item {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final String description;
  final double rating;
  final String categoryId;
  final String restaurantId;

  Item({
    required this.id,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.categoryId,
    required this.restaurantId,
  });

  Item.fromData(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        price = data['price'],
        imageUrl = data['imageUrl'],
        description = data['description'],
        rating = data['rating'],
        categoryId = data['categoryId'],
        restaurantId = data['restaurantId'];
}
