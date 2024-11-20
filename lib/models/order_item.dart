class OrderItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageUrl;
  final String description;
  final double rating;
  final String notes;
  
  OrderItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.rating,
    this.notes = '',
  });
}