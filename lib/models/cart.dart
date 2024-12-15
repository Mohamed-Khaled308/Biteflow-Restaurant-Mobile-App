import 'package:biteflow/models/menu_item.dart';

class Cart {
  final String id;
  final String restaurantId;
  final String creatorId; // New field for the user who created the cart
  final List<CartParticipant> participants;
  final List<CartItem> items;
  bool isDeleted;

  Cart({
    required this.id,
    required this.restaurantId,
    required this.creatorId, // Accept creatorId in the constructor
    this.participants = const [],
    this.items = const [],
    this.isDeleted = false,
  });

  factory Cart.fromData(Map<String, dynamic> data) {
    return Cart(
      id: data['id'],
      restaurantId: data['restaurantId'],
      creatorId: data['creatorId'], // Extract creatorId from the data
      participants: (data['participants'] as List<dynamic>?)
              ?.map((participant) =>
                  CartParticipant.fromData(participant as Map<String, dynamic>))
              .toList() ??
          [],
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromData(item as Map<String, dynamic>))
              .toList() ??
          [],
      isDeleted: data['isDeleted'] ?? false, // Handle isDeleted field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'creatorId': creatorId, // Include creatorId in the JSON representation
      'participants': participants.map((p) => p.toJson()).toList(),
      'items': items.map((i) => i.toJson()).toList(),
      'isDeleted': isDeleted, // Include isDeleted in the JSON representation
    };
  }
}

enum ParticipantStatus { pending, done }

class CartParticipant {
  final String id;
  final String name;
  ParticipantStatus status;

  CartParticipant({
    required this.id,
    required this.name,
    this.status = ParticipantStatus.pending,
  });

  factory CartParticipant.fromData(Map<String, dynamic> data) {
    return CartParticipant(
      id: data['id'],
      name: data['name'],
      status: data['status'] == 'done'
          ? ParticipantStatus.done
          : ParticipantStatus.pending,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status == ParticipantStatus.done ? 'done' : 'pending',
    };
  }
}

class CartItem {
  final MenuItem menuItem;
  final String userId;
  int quantity;
  String notes;
  List<CartParticipant> participants;

  CartItem({
    required this.menuItem,
    required this.userId,
    this.quantity = 1,
    this.notes = '',
    this.participants = const [],
  });

  factory CartItem.fromData(Map<String, dynamic> data) {
    return CartItem(
      menuItem: MenuItem.fromData(data['menuItem']),
      userId: data['userId'],
      quantity: data['quantity'] ?? 1,
      notes: data['notes'] ?? '',
      participants: (data['participants'] as List<dynamic>?)
              ?.map((participant) =>
                  CartParticipant.fromData(participant as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem.toJson(),
      'userId': userId,
      'quantity': quantity,
      'notes': notes,
      'participants': participants.map((p) => p.toJson()).toList(),
    };
  }
}
