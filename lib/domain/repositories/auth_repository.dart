import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../infrastructure/network/dio_client.dart';
import '../entities/auth/register_step1_entity.dart';
import '../entities/auth/verify_otp_entity.dart';
import '../entities/auth/login_entity.dart';
import '../entities/auth/resend_otp_entity.dart';
import '../entities/auth/forgot_password_entity.dart';
import '../entities/auth/reset_password_entity.dart';
import '../entities/auth/me_entity.dart';
import '../entities/auth/google_auth_entity.dart';
import '../entities/profile/update_profile_entity.dart';
import '../entities/profile/update_password_entity.dart';
import '../entities/profile/update_avatar_entity.dart';
import '../entities/profile/delete_account_entity.dart';
import '../enums/register_status.dart';
import '../enums/auth_status.dart';

class AuthRepository {
  final DioClient dioClient;

  AuthRepository(this.dioClient);


  Future<RegisterStep1EntityWithStatus> registerStep1({
    required String email,
    required String fullname,
    required String password,
  }) async {
    try {
      final response = await dioClient.getDio().post(
        'api/auth/client/register/step1',
        data: {
          'email': email,
          'fullname': fullname,
          'password': password,
        },
      );
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        RegisterStep1Entity entity = RegisterStep1Entity.fromJson(response.data);
        return RegisterStep1EntityWithStatus(
          entity: entity,
          registerStatus: RegisterStatus.SUCCESS,
        );
      }

      return RegisterStep1EntityWithStatus(
        registerStatus: RegisterStatus.ERROR,
      );
    } catch (e) {
      print("Erreur inattendue dans registerStep1: $e");
      return RegisterStep1EntityWithStatus(
        registerStatus: RegisterStatus.ERROR,
      );
    }
  }

  Future<({VerifyOtpEntity? entity, VerifyOtpStatus status})> verifyOtp({
    required String otp,
  }) async {
    try {
      final response = await dioClient.getDio().post(
        'api/auth/client/verify-otp',
        data: {
          'otp': otp,
        },
      );
      
      if (response.statusCode == HttpStatus.ok) {
        VerifyOtpEntity entity = VerifyOtpEntity.fromJson(response.data);
        return (entity: entity, status: VerifyOtpStatus.SUCCESS);
      }

      return (entity: null, status: VerifyOtpStatus.ERROR);
    } catch (e) {
      print("Erreur dans verifyOtp: $e");
      return (entity: null, status: VerifyOtpStatus.ERROR);
    }
  }

  Future<({ResendOtpEntity? entity, ResendOtpStatus status})> resendOtp({
    required String email,
  }) async {
    try {
      final response = await dioClient.getDio().post(
        'api/auth/client/resend-otp',
        data: {
          'email': email,
        },
      );
      
      if (response.statusCode == HttpStatus.ok) {
        ResendOtpEntity entity = ResendOtpEntity.fromJson(response.data);
        return (entity: entity, status: ResendOtpStatus.SUCCESS);
      }

      return (entity: null, status: ResendOtpStatus.ERROR);
    } catch (e) {
      print("Erreur dans resendOtp: $e");
      return (entity: null, status: ResendOtpStatus.ERROR);
    }
  }


  Future<({LoginEntity? entity, LoginStatus status})> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dioClient.getDio().post(
        'api/auth/client/login',
        data: {
          'email': email,
          'password': password,
        },
      );
      
      if (response.statusCode == HttpStatus.ok) {
        LoginEntity entity = LoginEntity.fromJson(response.data);
        return (entity: entity, status: LoginStatus.SUCCESS);
      }

      return (entity: null, status: LoginStatus.ERROR);
    } catch (e) {
      print("Erreur dans login: $e");
      if (e is DioException) {
        if (e.response?.statusCode == HttpStatus.unauthorized) {
          return (entity: null, status: LoginStatus.INVALID_CREDENTIALS);
        } else if (e.response?.statusCode == HttpStatus.forbidden) {
          return (entity: null, status: LoginStatus.ACCOUNT_LOCKED);
        }
      }
      return (entity: null, status: LoginStatus.ERROR);
    }
  }

  Future<({String? message, ApiStatus status})> logout() async {
    try {
      final response = await dioClient.getDio().post(
        'api/auth/client/logout',
      );
      
      if (response.statusCode == HttpStatus.ok) {
        return (message: response.data['message']?.toString(), status: ApiStatus.SUCCESS);
      }

      return (message: null, status: ApiStatus.ERROR);
    } catch (e) {
      print("Erreur dans logout: $e");
      return (message: null, status: ApiStatus.ERROR);
    }
  }

  Future<({MeEntity? entity, ApiStatus status})> getMe() async {
    try {
      final response = await dioClient.getDio().get(
        'api/auth/client/me',
      );
      
      if (response.statusCode == HttpStatus.ok) {
        MeEntity entity = MeEntity.fromJson(response.data);
        return (entity: entity, status: ApiStatus.SUCCESS);
      }

      return (entity: null, status: ApiStatus.ERROR);
    } catch (e) {
      print("Erreur dans getMe: $e");
      return (entity: null, status: ApiStatus.ERROR);
    }
  }

  Future<({ForgotPasswordEntity? entity, ForgotPasswordStatus status})> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await dioClient.getDio().post(
        'api/auth/client/forgot-password',
        data: {
          'email': email,
        },
      );
      
      if (response.statusCode == HttpStatus.ok) {
        ForgotPasswordEntity entity = ForgotPasswordEntity.fromJson(response.data);
        return (entity: entity, status: ForgotPasswordStatus.SUCCESS);
      }

      return (entity: null, status: ForgotPasswordStatus.ERROR);
    } catch (e) {
      print("Erreur dans forgotPassword: $e");
      if (e is DioException && e.response?.statusCode == HttpStatus.notFound) {
        return (entity: null, status: ForgotPasswordStatus.EMAIL_NOT_FOUND);
      }
      return (entity: null, status: ForgotPasswordStatus.ERROR);
    }
  }

  Future<({ResetPasswordEntity? entity, ResetPasswordStatus status})> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      final response = await dioClient.getDio().post(
        'api/auth/client/reset-password',
        data: {
          'token': token,
          'newPassword': newPassword,
        },
      );
      
      if (response.statusCode == HttpStatus.ok) {
        ResetPasswordEntity entity = ResetPasswordEntity.fromJson(response.data);
        return (entity: entity, status: ResetPasswordStatus.SUCCESS);
      }

      return (entity: null, status: ResetPasswordStatus.ERROR);
    } catch (e) {
      print("Erreur dans resetPassword: $e");
      if (e is DioException) {
        if (e.response?.statusCode == HttpStatus.badRequest) {
          return (entity: null, status: ResetPasswordStatus.INVALID_TOKEN);
        } else if (e.response?.statusCode == HttpStatus.gone) {
          return (entity: null, status: ResetPasswordStatus.TOKEN_EXPIRED);
        }
      }
      return (entity: null, status: ResetPasswordStatus.ERROR);
    }
  }

  Future<({bool isValid, String? message})> verifyResetToken({
    required String token,
  }) async {
    try {
      final response = await dioClient.getDio().get(
        'api/auth/client/verify-reset-token/$token',
      );
      
      if (response.statusCode == HttpStatus.ok) {
        return (
          isValid: response.data['data']?['valid'] as bool? ?? false,
          message: response.data['message']?.toString()
        );
      }

      return (isValid: false, message: null);
    } catch (e) {
      print("Erreur dans verifyResetToken: $e");
      return (isValid: false, message: null);
    }
  }

  Future<({GoogleAuthEntity? entity, GoogleAuthStatus status})> googleAuth({
    required String googleAccessToken,
  }) async {
    try {
      final response = await dioClient.getDio().post(
        'api/auth/google/login',
        data: {
          'token': googleAccessToken,
        },
      );
      
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        final entity = GoogleAuthEntity.fromJson(response.data);
        
        if (entity.isNewUser && entity.requiresOtp) {
          return (entity: entity, status: GoogleAuthStatus.NEW_USER_REQUIRES_OTP);
        }
        
        return (entity: entity, status: GoogleAuthStatus.SUCCESS);
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        return (entity: null, status: GoogleAuthStatus.GOOGLE_ERROR);
      }

      return (entity: null, status: GoogleAuthStatus.ERROR);
    } on DioException catch (e) {
      print("DioException dans googleAuth: $e");
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return (entity: null, status: GoogleAuthStatus.NETWORK_ERROR);
      }
      return (entity: null, status: GoogleAuthStatus.ERROR);
    } catch (e) {
      print("Erreur dans googleAuth: $e");
      return (entity: null, status: GoogleAuthStatus.ERROR);
    }
  }

  /// Mise à jour du profil (nom uniquement)
  Future<({UpdateProfileEntity? entity, UpdateProfileStatus status})> updateProfile({
    required String fullname,
  }) async {
    try {
      final response = await dioClient.getDio().put(
        'api/auth/client/update-profile',
        data: {
          'fullname': fullname,
        },
      );
      
      if (response.statusCode == HttpStatus.ok) {
        UpdateProfileEntity entity = UpdateProfileEntity.fromJson(response.data);
        return (entity: entity, status: UpdateProfileStatus.SUCCESS);
      }

      return (entity: null, status: UpdateProfileStatus.ERROR);
    } on DioException catch (e) {
      print("DioException dans updateProfile: $e");
      if (e.response?.statusCode == HttpStatus.unauthorized) {
        return (entity: null, status: UpdateProfileStatus.UNAUTHORIZED);
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return (entity: null, status: UpdateProfileStatus.NETWORK_ERROR);
      }
      return (entity: null, status: UpdateProfileStatus.ERROR);
    } catch (e) {
      print("Erreur dans updateProfile: $e");
      return (entity: null, status: UpdateProfileStatus.ERROR);
    }
  }

  /// Mise à jour du mot de passe
  Future<({UpdatePasswordEntity? entity, UpdatePasswordStatus status})> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await dioClient.getDio().put(
        'api/auth/client/update-password',
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
      
      if (response.statusCode == HttpStatus.ok) {
        UpdatePasswordEntity entity = UpdatePasswordEntity.fromJson(response.data);
        return (entity: entity, status: UpdatePasswordStatus.SUCCESS);
      }

      return (entity: null, status: UpdatePasswordStatus.ERROR);
    } on DioException catch (e) {
      print("DioException dans updatePassword: $e");
      if (e.response?.statusCode == HttpStatus.unauthorized) {
        return (entity: null, status: UpdatePasswordStatus.UNAUTHORIZED);
      }
      if (e.response?.statusCode == HttpStatus.badRequest) {
        // Le backend retourne 400 pour mot de passe actuel incorrect
        final message = e.response?.data['message']?.toString() ?? '';
        if (message.contains('actuel') || message.contains('incorrect')) {
          return (entity: null, status: UpdatePasswordStatus.INVALID_CURRENT_PASSWORD);
        }
        if (message.contains('8 caractères')) {
          return (entity: null, status: UpdatePasswordStatus.WEAK_PASSWORD);
        }
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return (entity: null, status: UpdatePasswordStatus.NETWORK_ERROR);
      }
      return (entity: null, status: UpdatePasswordStatus.ERROR);
    } catch (e) {
      print("Erreur dans updatePassword: $e");
      return (entity: null, status: UpdatePasswordStatus.ERROR);
    }
  }

  /// Mise à jour de l'avatar
  /// [imageBytes] - Les bytes de l'image à uploader
  /// [filename] - Le nom du fichier (ex: "avatar.jpg")
  Future<({UpdateAvatarEntity? entity, UpdateAvatarStatus status})> updateAvatar({
    required Uint8List imageBytes,
    required String filename,
  }) async {
    try {
      // Créer le FormData pour l'upload multipart
      final formData = FormData.fromMap({
        'avatar': MultipartFile.fromBytes(
          imageBytes,
          filename: filename,
        ),
      });

      final response = await dioClient.getDio().post(
        'api/auth/client/update-avatar',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      
      if (response.statusCode == HttpStatus.ok) {
        UpdateAvatarEntity entity = UpdateAvatarEntity.fromJson(response.data);
        return (entity: entity, status: UpdateAvatarStatus.SUCCESS);
      }

      return (entity: null, status: UpdateAvatarStatus.ERROR);
    } on DioException catch (e) {
      print("DioException dans updateAvatar: $e");
      if (e.response?.statusCode == HttpStatus.unauthorized) {
        return (entity: null, status: UpdateAvatarStatus.UNAUTHORIZED);
      }
      if (e.response?.statusCode == HttpStatus.badRequest) {
        return (entity: null, status: UpdateAvatarStatus.INVALID_FORMAT);
      }
      if (e.response?.statusCode == HttpStatus.requestEntityTooLarge) {
        return (entity: null, status: UpdateAvatarStatus.FILE_TOO_LARGE);
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return (entity: null, status: UpdateAvatarStatus.NETWORK_ERROR);
      }
      return (entity: null, status: UpdateAvatarStatus.ERROR);
    } catch (e) {
      print("Erreur dans updateAvatar: $e");
      return (entity: null, status: UpdateAvatarStatus.ERROR);
    }
  }

  /// Suppression définitive du compte
  /// [password] - Le mot de passe de l'utilisateur pour confirmer
  Future<({DeleteAccountEntity? entity, DeleteAccountStatus status})> deleteAccount({
    required String password,
  }) async {
    try {
      final response = await dioClient.getDio().delete(
        'api/auth/client/delete',
        data: {
          'password': password,
          'confirmation': 'DELETE_MY_ACCOUNT',
        },
      );
      
      if (response.statusCode == HttpStatus.ok) {
        DeleteAccountEntity entity = DeleteAccountEntity.fromJson(response.data);
        return (entity: entity, status: DeleteAccountStatus.SUCCESS);
      }

      return (entity: null, status: DeleteAccountStatus.ERROR);
    } on DioException catch (e) {
      print("DioException dans deleteAccount: $e");
      if (e.response?.statusCode == HttpStatus.unauthorized) {
        return (entity: null, status: DeleteAccountStatus.UNAUTHORIZED);
      }
      if (e.response?.statusCode == HttpStatus.badRequest) {
        final message = e.response?.data['message']?.toString() ?? '';
        if (message.contains('mot de passe') || message.contains('password')) {
          return (entity: null, status: DeleteAccountStatus.INVALID_PASSWORD);
        }
        if (message.contains('confirmation')) {
          return (entity: null, status: DeleteAccountStatus.INVALID_CONFIRMATION);
        }
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        return (entity: null, status: DeleteAccountStatus.NETWORK_ERROR);
      }
      return (entity: null, status: DeleteAccountStatus.ERROR);
    } catch (e) {
      print("Erreur dans deleteAccount: $e");
      return (entity: null, status: DeleteAccountStatus.ERROR);
    }
  }
}
