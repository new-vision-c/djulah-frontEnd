import '../../enums/register_status.dart';

class RegisterStep1EntityWithStatus {
  RegisterStep1Entity? entity;
  RegisterStatus registerStatus;
  
  RegisterStep1EntityWithStatus({
    this.entity,
    required this.registerStatus,
  });
}

class RegisterStep1Entity {
  final int timestamp;
  final int statusCode;
  final String error;
  final int? responseStatusCode;
  final String message;
  final String messageDev;
  final String? path;
  final String? status;
  final bool success;
  final RegisterStep1Data? data;

  RegisterStep1Entity({
    required this.timestamp,
    required this.statusCode,
    required this.error,
    this.responseStatusCode,
    required this.message,
    required this.messageDev,
    this.path,
    this.status,
    required this.success,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      "timestamp": timestamp,
      "statusCode": statusCode,
      "error": error,
      "responseStatusCode": responseStatusCode,
      "message": message,
      "messageDev": messageDev,
      "path": path,
      "status": status,
      "success": success,
      "data": data?.toJson(),
    };
  }

  factory RegisterStep1Entity.fromJson(Map<String, dynamic> map) {
    return RegisterStep1Entity(
      timestamp: map["timestamp"] != null
          ? (map["timestamp"] is int
              ? map["timestamp"]
              : int.tryParse(map["timestamp"].toString()) ?? 0)
          : DateTime.now().millisecondsSinceEpoch,
      statusCode: map["statusCode"] is int
          ? map["statusCode"]
          : int.tryParse(map["statusCode"].toString()) ?? 0,
      error: map["error"]?.toString() ?? "",
      responseStatusCode: map["responseStatusCode"] != null
          ? int.tryParse(map["responseStatusCode"].toString())
          : null,
      message: map["message"]?.toString() ?? "",
      messageDev: map["messageDev"]?.toString() ?? "",
      path: map["path"]?.toString(),
      status: map["status"]?.toString(),
      success: map["success"] == true || map["success"] == "true",
      data: map["data"] != null ? RegisterStep1Data.fromJson(map["data"]) : null,
    );
  }
}

class RegisterStep1Data {
  final int step;
  final UserEntity user;
  final String token;
  final String message;
  final bool requiresOtp;
  final String? otpCode;

  RegisterStep1Data({
    required this.step,
    required this.user,
    required this.token,
    required this.message,
    required this.requiresOtp,
    this.otpCode,
  });

  factory RegisterStep1Data.fromJson(Map<String, dynamic> json) {
    return RegisterStep1Data(
      step: json['step'] ?? 0,
      user: UserEntity.fromJson(json['user'] ?? {}),
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

class UserEntity {
  final String id;
  final String fullname;
  final String email;
  final String? otpCode;

  UserEntity({
    required this.id,
    required this.fullname,
    required this.email,
    this.otpCode,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
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
