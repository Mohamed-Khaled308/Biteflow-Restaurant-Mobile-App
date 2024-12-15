class OfferNotification {
  String id;
  String title;
  DateTime endDate;

  OfferNotification({
    required this.id,
    required this.title,
    required this.endDate,
  });

  OfferNotification.fromData(Map<String, dynamic> data)
      : id = data['id'],
        title = data['title'],
        endDate = DateTime.parse(data['endDate']); // Parse endDate from String

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'endDate': endDate.toIso8601String(), // Convert endDate to String
    };
  }
}
