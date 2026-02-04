import 'dart:typed_data';
import 'package:get/get.dart';
import '../../../domain/entities/auth/register_step1_entity.dart';
import '../../../domain/entities/auth/verify_otp_entity.dart';
import '../../../domain/entities/auth/login_entity.dart';
import '../../../domain/entities/auth/resend_otp_entity.dart';
import '../../../domain/entities/auth/forgot_password_entity.dart';
import '../../../domain/entities/auth/reset_password_entity.dart';
import '../../../domain/entities/auth/me_entity.dart';
import '../../../domain/entities/auth/google_auth_entity.dart';
import '../../../domain/entities/profile/update_profile_entity.dart';
import '../../../domain/entities/profile/update_password_entity.dart';
import '../../../domain/entities/profile/update_avatar_entity.dart';
import '../../../domain/entities/profile/delete_account_entity.dart';
import '../../../domain/enums/auth_status.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../network/dio_client.dart';

class AuthService {
  AuthRepository authRepository = Get.put<AuthRepository>(
    AuthRepository(Get.find<DioClient>()),
  );

  Future<RegisterStep1EntityWithStatus> registerStep1({
    required String email,
    required String fullname,
    required String password,
  }) async {
    return await authRepository.registerStep1(
      email: email,
      fullname: fullname,
      password: password,
    );
  }

  Future<({VerifyOtpEntity? entity, VerifyOtpStatus status})> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return await authRepository.verifyOtp(
      otp: otp,
    );
  }

  Future<({ResendOtpEntity? entity, ResendOtpStatus status})> resendOtp({
    required String email,
  }) async {
    return await authRepository.resendOtp(email: email);
  }



  Future<({LoginEntity? entity, LoginStatus status})> login({
    required String email,
    required String password,
  }) async {
    return await authRepository.login(
      email: email,
      password: password,
    );
  }

  Future<({String? message, ApiStatus status})> logout() async {
    return await authRepository.logout();
  }

  Future<({MeEntity? entity, ApiStatus status})> getMe() async {
    return await authRepository.getMe();
  }

  Future<({ForgotPasswordEntity? entity, ForgotPasswordStatus status})> forgotPassword({
    required String email,
  }) async {
    return await authRepository.forgotPassword(email: email);
  }

  Future<({ResetPasswordEntity? entity, ResetPasswordStatus status})> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    return await authRepository.resetPassword(
      token: token,
      newPassword: newPassword,
    );
  }

  Future<({bool isValid, String? message})> verifyResetToken({
    required String token,
  }) async {
    return await authRepository.verifyResetToken(token: token);
  }

  /// Authentification via Google
  Future<({GoogleAuthEntity? entity, GoogleAuthStatus status})> googleAuth({
    required String googleAccessToken,
  }) async {
    return await authRepository.googleAuth(googleAccessToken: googleAccessToken);
  }

  /// Mise à jour du profil (nom uniquement)
  Future<({UpdateProfileEntity? entity, UpdateProfileStatus status})> updateProfile({
    required String fullname,
  }) async {
    return await authRepository.updateProfile(fullname: fullname);
  }

  /// Mise à jour du mot de passe
  Future<({UpdatePasswordEntity? entity, UpdatePasswordStatus status})> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return await authRepository.updatePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  /// Mise à jour de l'avatar
  Future<({UpdateAvatarEntity? entity, UpdateAvatarStatus status})> updateAvatar({
    required Uint8List imageBytes,
    required String filename,
  }) async {
    return await authRepository.updateAvatar(
      imageBytes: imageBytes,
      filename: filename,
    );
  }

  /// Suppression définitive du compte
  Future<({DeleteAccountEntity? entity, DeleteAccountStatus status})> deleteAccount({
    required String password,
  }) async {
    return await authRepository.deleteAccount(password: password);
  }
}
