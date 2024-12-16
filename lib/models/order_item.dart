import 'package:biteflow/models/item.dart';
import 'package:biteflow/models/order_item_participant.dart';

class OrderItem extends Item {
  final int quantity;
  final String notes;
  final double discountPercentage;
  final List<OrderItemParticipant> participants;

  OrderItem({
    required super.id,
    required super.title,
    required this.quantity,
    required super.price,
    required super.imageUrl,
    required super.description,
    required super.rating,
    required super.categoryId,
    required super.restaurantId,
    required this.participants,
    this.notes = '',
    this.discountPercentage = 0.0,
  });

  OrderItem.fromData(Map<String, dynamic> data)
      : quantity = data['quantity'],
        notes = data['notes'],
        discountPercentage = (data['discountPercentage'] ?? 0.0).toDouble(),
        participants = (data['participants'] as List<dynamic>? ?? [])
            .map((participant) => OrderItemParticipant.fromData(participant))
            .toList(),
        super(
            id: data['id'],
            title: data['title'],
            price: data['price'],
            imageUrl: data['imageUrl'],
            description: data['description'],
            rating: data['rating'],
            categoryId: data['categoryId'],
            restaurantId: data['restaurantId']
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
      restaurantId: restaurantId,
      participants: participants,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = super.toJson();
    data['quantity'] = quantity;
    data['notes'] = notes;
    data['discountPercentage'] = discountPercentage;
    data['participants'] = participants.map((participant) => participant.toJson()).toList();
    return data;
  }
}
