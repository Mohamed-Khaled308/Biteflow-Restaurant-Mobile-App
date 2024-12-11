import 'package:biteflow/models/menu_item.dart';

class Cart {
  final String id;
  final String restaurantId;
  final List<CartParticipant> participants;
  final List<CartItem> items;

  Cart({
    required this.id,
    required this.restaurantId,
    required this.participants,
    required this.items,
  });

  factory Cart.fromData(Map<String, dynamic> data) {
    return Cart(
      id: data['id'],
      restaurantId: data['restaurantId'],
      participants: (data['participants'] as List)
          .map((participant) => CartParticipant.fromData(participant))
          .toList(),
      items: (data['items'] as List)
          .map((item) => CartItem.fromData(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'participants': participants.map((p) => p.toJson()).toList(),
      'items': items.map((i) => i.toJson()).toList(),
    };
  }
}

class CartParticipant {
  final String id;
  final String name;

  CartParticipant({required this.id, required this.name});

  factory CartParticipant.fromData(Map<String, dynamic> data) {
    return CartParticipant(
      id: data['id'],
      name: data['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class CartItem {
  final MenuItem menuItem;
  final String userId;
  final String userName;
  int quantity;
  String notes;

  CartItem({
    required this.menuItem,
    required this.userId,
    required this.userName,
    this.quantity = 1,
    this.notes = '',
  });

  factory CartItem.fromData(Map<String, dynamic> data) {
    return CartItem(
      menuItem: MenuItem.fromData(data['menuItem']),
      userId: data['userId'],
      userName: data['userName'],
      quantity: data['quantity'] ?? 1,
      notes: data['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem.toJson(),
      'userId': userId,
      'userName': userName,
      'quantity': quantity,
      'notes': notes,
    };
  }
}
