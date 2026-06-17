class ProfileModel {
  final int id;
  final String phoneNumber;
  final String address;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final bool emailConfirmed;
  final int userType;

  ProfileModel({
    required this.id,
    required this.phoneNumber,
    required this.address,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.emailConfirmed,
    required this.userType,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? 0,
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      emailConfirmed: json['emailConfirmed'] ?? false,
      userType: json['userType'] ?? 0,
    );
  }
}
