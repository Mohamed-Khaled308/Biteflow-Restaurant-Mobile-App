import 'package:biteflow/models/item.dart';

class OrderItem extends Item {
  final int quantity;
  final String notes;

  OrderItem({
    required super.id,
    required super.title,
    required this.quantity,
    required super.price,
    required super.imageUrl,
    required super.description,
    required super.rating,
    required super.categoryId,
    this.notes = '',
  });

  OrderItem.fromData(Map<String, dynamic> data)
      : quantity = data['quantity'],
        notes = data['notes'],
        super(
            id: data['id'],
            title: data['title'],
            price: data['price'],
            imageUrl: data['imageUrl'],
            description: data['description'],
            rating: data['rating'],
            categoryId: data['categoryId'],
            );

  OrderItem copyWith({
    int? updatedQuantity,
    String? updatedNotes,
    double? updatedRating,
  }) {
    return OrderItem(
      id: id,
      title: title,
      price: price,
      imageUrl: imageUrl,
      description: description,
      rating: updatedRating ?? rating,
      quantity: updatedQuantity ?? quantity,
      notes: updatedNotes ?? notes,
      categoryId: categoryId,
    );
  }
}
