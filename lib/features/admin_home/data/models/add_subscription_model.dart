class AddSubscriptionModel {
  final int id;
  AddSubscriptionModel({required this.id});

  factory AddSubscriptionModel.fromJson(Map<String, dynamic> json) {
    return AddSubscriptionModel(id: json['id'] ?? 0);
  }
}
