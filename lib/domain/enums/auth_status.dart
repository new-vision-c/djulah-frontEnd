enum LoginStatus {
  SUCCESS,
  ERROR,
  INVALID_CREDENTIALS,
  ACCOUNT_LOCKED,
  NOT_VERIFIED,
  NETWORK_ERROR,
}

enum VerifyOtpStatus {
  SUCCESS,
  ERROR,
  INVALID_OTP,
  USER_NOT_FOUND,
  ALREADY_VERIFIED,
  EXPIRED_OTP,
  NETWORK_ERROR,
}

enum ForgotPasswordStatus {
  SUCCESS,
  ERROR,
  EMAIL_NOT_FOUND,
  NETWORK_ERROR,
}

enum ResetPasswordStatus {
  SUCCESS,
  ERROR,
  INVALID_TOKEN,
  TOKEN_EXPIRED,
  NETWORK_ERROR,
}

enum ApiStatus {
  SUCCESS,
  ERROR,
  NETWORK_ERROR,
}

enum ResendOtpStatus {
  SUCCESS,
  ERROR,
  USER_NOT_FOUND,
  ALREADY_VERIFIED,
  TOO_MANY_REQUESTS,
  NETWORK_ERROR,
}

enum GoogleAuthStatus {
  SUCCESS,
  NEW_USER_REQUIRES_OTP,
  ERROR,
  CANCELLED,
  GOOGLE_ERROR,
  NETWORK_ERROR,
}

/// Statut pour la mise à jour du profil (nom)
enum UpdateProfileStatus {
  SUCCESS,
  ERROR,
  UNAUTHORIZED,
  NETWORK_ERROR,
}

/// Statut pour la mise à jour du mot de passe
enum UpdatePasswordStatus {
  SUCCESS,
  ERROR,
  UNAUTHORIZED,
  INVALID_CURRENT_PASSWORD,
  WEAK_PASSWORD,
  NETWORK_ERROR,
}

/// Statut pour la mise à jour de l'avatar
enum UpdateAvatarStatus {
  SUCCESS,
  ERROR,
  UNAUTHORIZED,
  FILE_TOO_LARGE,
  INVALID_FORMAT,
  NETWORK_ERROR,
}

/// Statut pour la suppression du compte
enum DeleteAccountStatus {
  SUCCESS,
  ERROR,
  UNAUTHORIZED,
  INVALID_PASSWORD,
  INVALID_CONFIRMATION,
  NETWORK_ERROR,
}
