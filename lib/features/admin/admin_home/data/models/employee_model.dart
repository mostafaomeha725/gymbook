class EmployeeModel {
  final int id;
  final int branchId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final int roleId;
  final String roleName;
  final bool isActive;
  final String createdAt;

  EmployeeModel({
    required this.id,
    required this.branchId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.roleId,
    required this.roleName,
    required this.isActive,
    required this.createdAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] ?? 0,
      branchId: json['branchId'] ?? 0,
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      roleId: json['roleId'] ?? 0,
      roleName: json['roleName'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branchId': branchId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'roleId': roleId,
      'roleName': roleName,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}

class BranchEmployeesResponse {
  final List<EmployeeModel> data;
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  BranchEmployeesResponse({
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory BranchEmployeesResponse.fromJson(Map<String, dynamic> json) {
    return BranchEmployeesResponse(
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => EmployeeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalCount: json['totalCount'] ?? 0,
      pageSize: json['pageSize'] ?? 10,
      hasPreviousPage: json['hasPreviousPage'] ?? false,
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalCount': totalCount,
      'pageSize': pageSize,
      'hasPreviousPage': hasPreviousPage,
      'hasNextPage': hasNextPage,
    };
  }
}
