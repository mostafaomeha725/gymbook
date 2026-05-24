class CreateBranchResponse {
  final int id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final int? branchType;

  CreateBranchResponse({
    required this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.branchType,
  });

  factory CreateBranchResponse.fromJson(dynamic data) {
    // API returns just the ID as int or string
    if (data is int) {
      return CreateBranchResponse(id: data);
    }
    if (data is String) {
      return CreateBranchResponse(id: int.tryParse(data) ?? 0);
    }
    // Fallback for map response
    if (data is Map<String, dynamic>) {
      return CreateBranchResponse(
        id: data['id'] ?? 0,
        name: data['name'],
        email: data['email'],
        phoneNumber: data['phoneNumber'],
        branchType: data['branchType'],
      );
    }
    return CreateBranchResponse(id: 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (branchType != null) 'branchType': branchType,
    };
  }
}
