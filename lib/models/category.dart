class Category {
  String id;
  String title;
  String restaurantId ;
  Category({required this.id, required this.title, required this.restaurantId});

  Category.fromData(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        restaurantId = data['restaurantId'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'restaurantId': restaurantId,
    };
  }
}
