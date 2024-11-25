class Category {
  String id;
  String title;
  Category({required this.id, required this.title});

  Category.fromData(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'];
}
