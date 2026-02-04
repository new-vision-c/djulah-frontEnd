class UserData {
  final String id;
  final String email;
  final String fullname;
  final String? phoneNumber;
  final String? avatar;
  final String? role;
  final bool? isVerified;
  final DateTime? createdAt;

  UserData({
    required this.id,
    required this.email,
    required this.fullname,
    this.phoneNumber,
    this.avatar,
    this.role,
    this.isVerified,
    this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    // role peut être un String ou un objet {name: "CLIENT"}
    String? roleValue;
    if (json['role'] is String) {
      roleValue = json['role'] as String;
    } else if (json['role'] is Map) {
      roleValue = (json['role'] as Map)['name']?.toString();
    }
    
    return UserData(
      id: json['id'] ?? json['_id'] ?? '',
      email: json['email'] ?? '',
      fullname: json['fullname'] ?? '',
      phoneNumber: json['phoneNumber'],
      avatar: json['avatar'],
      role: roleValue,
      isVerified: json['isVerified'] ?? json['otpVerified'],
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'fullname': fullname,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'role': role,
      'isVerified': isVerified,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
