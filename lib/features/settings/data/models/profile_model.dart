class ProfileBranchModel {
  final int id;
  final String name;

  ProfileBranchModel({required this.id, required this.name});

  factory ProfileBranchModel.fromJson(Map<String, dynamic> json) {
    return ProfileBranchModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

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
  final String? userRole;
  final List<ProfileBranchModel> branches;

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
    this.userRole,
    this.branches = const [],
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
      userRole: json['userRole'],
      branches:
          (json['branches'] as List<dynamic>?)
              ?.map(
                (e) => ProfileBranchModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'address': address,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'emailConfirmed': emailConfirmed,
      'userType': userType,
      'userRole': userRole,
      'branches': branches.map((e) => e.toJson()).toList(),
    };
  }
}
