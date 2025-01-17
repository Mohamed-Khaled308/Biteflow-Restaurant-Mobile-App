class DialogRequest {
  final String title;
  final String description;
  final String buttonTitle;
  final String cancelTitle;

  DialogRequest(
      {required this.title,
      required this.description,
      required this.buttonTitle,
      required this.cancelTitle});
}

class DialogResponse {
  final String fieldOne;
  final String fieldTwo;
  final bool confirmed;

  DialogResponse({
    required this.fieldOne,
    required this.fieldTwo,
    required this.confirmed,
  });
}
