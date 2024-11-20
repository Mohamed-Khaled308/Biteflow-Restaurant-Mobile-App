import 'package:biteflow/models/item.dart';

class OrderItem extends Item{
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
    this.notes = '',
  });
}