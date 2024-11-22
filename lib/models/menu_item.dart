import 'package:biteflow/models/item.dart';

class MenuItem extends Item {
  final String categoryId;

  MenuItem({
    required super.id,
    required super.title,
    required super.price,
    required super.imageUrl,
    required super.description,
    required super.rating,
    required this.categoryId,
  });
}