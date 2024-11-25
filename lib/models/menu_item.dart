import 'package:biteflow/models/item.dart';

class MenuItem extends Item {
  MenuItem({
    required super.id,
    required super.title,
    required super.price,
    required super.imageUrl,
    required super.description,
    required super.rating,
    required super.categoryId,
  });

  
  MenuItem.fromData(super.data)
      : super.fromData();
  
}
