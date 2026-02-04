import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleSignInService {
  static final GoogleSignInService _instance = GoogleSignInService._internal();
  factory GoogleSignInService() => _instance;
  GoogleSignInService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  
  GoogleSignInAccount? _currentUser;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;
  Completer<GoogleSignInResult?>? _signInCompleter;
  bool _isInitialized = false;

  Future<void> initialize({String? clientId, String? serverClientId}) async {
    if (_isInitialized) return;
    
    try {
      await _googleSignIn.initialize(
        clientId: clientId,
        serverClientId: serverClientId,
      );
      _authSubscription = _googleSignIn.authenticationEvents.listen(
        _handleAuthenticationEvent,
        onError: _handleAuthenticationError,
      );
      
      _isInitialized = true;
    } catch (e) {
      print('Erreur initialisation Google Sign-In: $e');
      rethrow;
    }
  }

  void _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) {
    GoogleSignInAccount? account;
    
    if (event is GoogleSignInAuthenticationEventSignIn) {
      account = event.user;
      _currentUser = account;
      
      if (_signInCompleter != null && !_signInCompleter!.isCompleted && account != null) {
        _completeSignInWithAccount(account);
      }
    } else if (event is GoogleSignInAuthenticationEventSignOut) {
      _currentUser = null;
    }
  }

  void _handleAuthenticationError(Object error) {
    print('Erreur Google Sign-In: $error');
    if (_signInCompleter != null && !_signInCompleter!.isCompleted) {
      _signInCompleter!.completeError(error);
    }
  }

  Future<void> _completeSignInWithAccount(GoogleSignInAccount account) async {
    if (_signInCompleter == null || _signInCompleter!.isCompleted) return;
    
    try {
      const List<String> scopes = <String>['email', 'profile'];
      
      final authorization = await account.authorizationClient.authorizationForScopes(scopes);
      
      if (authorization != null && authorization.accessToken != null) {
        _signInCompleter!.complete(GoogleSignInResult(
          accessToken: authorization.accessToken!,
          email: account.email,
          displayName: account.displayName,
          photoUrl: account.photoUrl,
        ));
      } else {
        final newAuth = await account.authorizationClient.authorizeScopes(scopes);
        _signInCompleter!.complete(GoogleSignInResult(
          accessToken: newAuth.accessToken,
          email: account.email,
          displayName: account.displayName,
          photoUrl: account.photoUrl,
        ));
      }
    } catch (e) {
      print('Erreur lors de l\'obtention de l\'access token: $e');
      _signInCompleter!.completeError(e);
    }
  }
  GoogleSignInAccount? get currentUser => _currentUser;
  Future<GoogleSignInResult?> signIn() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      _signInCompleter = Completer<GoogleSignInResult?>();

      if (_googleSignIn.supportsAuthenticate()) {
        await _googleSignIn.authenticate();
      } else {
        await _googleSignIn.attemptLightweightAuthentication();
      }

      final result = await _signInCompleter!.future.timeout(
        const Duration(minutes: 2),
        onTimeout: () => null,
      );

      return result;
    } catch (e) {
      print('Erreur Google Sign-In: $e');
      if (e.toString().contains('canceled') || e.toString().contains('cancelled')) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      _currentUser = null;
    } catch (e) {
      print('Erreur lors de la déconnexion Google: $e');
    }
  }

  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      _currentUser = null;
    } catch (e) {
      print('Erreur lors de la déconnexion complète Google: $e');
    }
  }

  Future<GoogleSignInResult?> signInSilently() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      _signInCompleter = Completer<GoogleSignInResult?>();
      
      await _googleSignIn.attemptLightweightAuthentication();
      
      final result = await _signInCompleter!.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () => null,
      );

      return result;
    } catch (e) {
      print('Erreur Google Sign-In Silently: $e');
      return null;
    }
  }

  void dispose() {
    _authSubscription?.cancel();
  }
}

class GoogleSignInResult {
  final String accessToken;
  final String email;
  final String? displayName;
  final String? photoUrl;

  GoogleSignInResult({
    required this.accessToken,
    required this.email,
    this.displayName,
    this.photoUrl,
  });
}

class GoogleSignInException implements Exception {
  final String message;
  GoogleSignInException(this.message);

  @override
  String toString() => 'GoogleSignInException: $message';
}
