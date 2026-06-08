class RegisterResponse {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String fullName;
  final int role;
  final bool emailConfirmed;

  RegisterResponse({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.role,
    required this.emailConfirmed,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? 0,
      emailConfirmed: json['emailConfirmed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'role': role,
      'emailConfirmed': emailConfirmed,
    };
  }
}
