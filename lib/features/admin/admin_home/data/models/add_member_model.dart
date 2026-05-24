class AddMemberModel {
  final int id;
  AddMemberModel({required this.id});

  factory AddMemberModel.fromJson(Map<String, dynamic> json) {
    return AddMemberModel(id: json['id'] ?? 0);
  }
}
