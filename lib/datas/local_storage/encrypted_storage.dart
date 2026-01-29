import 'dart:async';
import 'package:encrypt_shared_preferences/provider.dart';

class EncryptedStorage {
  final EncryptedSharedPreferences _storage;
  static Completer<EncryptedStorage>? _completer;
  EncryptedStorage._(this._storage);

  static Future<EncryptedStorage> init() async {
    if(_completer == null){
      final key = "xxxxxxxxxxxxXXXX";
      await EncryptedSharedPreferences.initialize(key);
      var sharedPref = EncryptedSharedPreferences.getInstance();

      final Completer<EncryptedStorage> completer = Completer<EncryptedStorage>();
      _completer = completer;

      completer.complete(EncryptedStorage._(sharedPref));
    }
    return _completer!.future;
  }


  Future<void> saveToken(String token) async {
    await _storage.setString('user_token', token);
  }

  Future<String?> getToken() async {
    // initDio();
    String? token = await _storage.getString('user_token');

    if (token == null){
      return '';
    }
    return token;
  }

  Future<void> removeToken() async {
    await _storage.remove('user_token');
  }

  Future<void> saveRefreshToken(String refreshToken) async{
    await _storage.setString('refresh_token', refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return  _storage.getString('refresh_token');
  }

  Future<void> removeRefreshToken() async {
    await _storage.remove('refresh_token');
  }


}
