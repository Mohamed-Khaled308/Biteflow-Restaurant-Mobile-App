class Restaurant {
  final String id;
  final String name;
  final String managerId;
  final List<String> itemsIds;

  Restaurant({
    required this.id,
    required this.name,
    required this.managerId,
    this.itemsIds = const [],
  });

  factory Restaurant.fromData(Map<String, dynamic> data) {
    return Restaurant(
      id: data['id'],
      name: data['name'] as String,
      managerId: data['managerId'] as String,
      itemsIds: (data['itemsIds'] != null && data['itemsIds'] is List)
          ? List<String>.from(data['orderIds'] as List)
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'managerId': managerId,
      'itemsIds': itemsIds,
    };
  }
}
