class RegisterStep1ResponseDto {
  final bool success;
  final String message;
  final RegisterStep1DataDto data;
  final String timestamp;

  RegisterStep1ResponseDto({
    required this.success,
    required this.message,
    required this.data,
    required this.timestamp,
  });

  factory RegisterStep1ResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterStep1ResponseDto(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: RegisterStep1DataDto.fromJson(json['data'] ?? {}),
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
      'timestamp': timestamp,
    };
  }
}

class RegisterStep1DataDto {
  final int step;
  final UserDto user;
  final String token;
  final String message;
  final bool requiresOtp;
  final String? otpCode;

  RegisterStep1DataDto({
    required this.step,
    required this.user,
    required this.token,
    required this.message,
    required this.requiresOtp,
    this.otpCode,
  });

  factory RegisterStep1DataDto.fromJson(Map<String, dynamic> json) {
    return RegisterStep1DataDto(
      step: json['step'] ?? 0,
      user: UserDto.fromJson(json['user'] ?? {}),
      token: json['token'] ?? '',
      message: json['message'] ?? '',
      requiresOtp: json['requiresOtp'] ?? false,
      otpCode: json['otpCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step': step,
      'user': user.toJson(),
      'token': token,
      'message': message,
      'requiresOtp': requiresOtp,
      'otpCode': otpCode,
    };
  }
}

class UserDto {
  final String id;
  final String fullname;
  final String email;
  final String? otpCode;

  UserDto({
    required this.id,
    required this.fullname,
    required this.email,
    this.otpCode,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      otpCode: json['otpCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'email': email,
      'otpCode': otpCode,
    };
  }
}
