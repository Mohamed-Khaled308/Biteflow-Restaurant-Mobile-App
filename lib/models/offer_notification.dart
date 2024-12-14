class OfferNotification {
  String id;
  String title;
  OfferNotification({required this.id, required this.title});

  OfferNotification.fromData(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
