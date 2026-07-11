class CheckInResultModel {
  final String memberName;
  final String packageName;
  final String lastCheckIn;

  const CheckInResultModel({
    required this.memberName,
    required this.packageName,
    required this.lastCheckIn,
  });

  factory CheckInResultModel.fromJson(Map<String, dynamic> json) {
    return CheckInResultModel(
      memberName: (json['memberName'] ?? '').toString(),
      packageName: (json['packageName'] ?? '').toString(),
      lastCheckIn: (json['lastCheckIn'] ?? '').toString(),
    );
  }
}
