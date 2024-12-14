import 'package:biteflow/models/item.dart';
class MenuItem extends Item {
  final double discountPercentage;

  MenuItem({
    required super.id,
    required super.title,
    required super.price,
    required super.imageUrl,
    required super.description,
    required super.rating,
    required super.categoryId,
    required super.restaurantId,
    this.discountPercentage = 0.0, // Default to no discount
  });

  MenuItem.fromData(super.data)
      : discountPercentage = (data['discountPercentage'] ?? 0.0).toDouble(),
        super.fromData();

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['discountPercentage'] = discountPercentage;
    return json;
  }

  MenuItem copyWith({
    String? id,
    String? title,
    double? price,
    String? imageUrl,
    String? description,
    double? rating,
    String? categoryId,
    String? restaurantId,
    double? discountPercentage,
  }) {
    return MenuItem(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      categoryId: categoryId ?? this.categoryId,
      restaurantId: restaurantId ?? this.restaurantId,
      discountPercentage: discountPercentage ?? this.discountPercentage,
    );
  }
}
