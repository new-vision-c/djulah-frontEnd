import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/favorite_property.model.dart';
import '../models/pending_message.model.dart';
import '../models/cached_conversation.model.dart';

/// Service d'initialisation du stockage local
/// Initialise Hive et GetStorage au démarrage de l'application
class LocalStorageInitializer {
  static const String _favoritesBoxName = 'favorites';
  static const String _pendingMessagesBoxName = 'pending_messages';
  static const String _conversationsBoxName = 'conversations';
  static const String _settingsContainer = 'djulah_settings';

  static bool _isInitialized = false;

  /// Initialise tous les systèmes de stockage local
  static Future<void> init() async {
    if (_isInitialized) return;

    // Initialiser Hive
    await Hive.initFlutter();

    // Enregistrer les adaptateurs Hive
    _registerAdapters();

    // Ouvrir les boxes Hive
    await _openBoxes();

    // Initialiser GetStorage
    await GetStorage.init(_settingsContainer);

    _isInitialized = true;
  }

  /// Enregistre tous les adaptateurs Hive
  static void _registerAdapters() {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FavoritePropertyAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MessageSyncStatusAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(PendingMessageAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(CachedMessageAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(CachedConversationAdapter());
    }
  }

  /// Ouvre toutes les boxes Hive nécessaires
  static Future<void> _openBoxes() async {
    await Future.wait([
      Hive.openBox<FavoriteProperty>(_favoritesBoxName),
      Hive.openBox<PendingMessage>(_pendingMessagesBoxName),
      Hive.openBox<CachedConversation>(_conversationsBoxName),
    ]);
  }

  /// Récupère le nom de la box des favoris
  static String get favoritesBoxName => _favoritesBoxName;

  /// Récupère le nom de la box des messages en attente
  static String get pendingMessagesBoxName => _pendingMessagesBoxName;

  /// Récupère le nom de la box des conversations
  static String get conversationsBoxName => _conversationsBoxName;

  /// Récupère le nom du container de paramètres
  static String get settingsContainer => _settingsContainer;

  /// Ferme tous les systèmes de stockage
  static Future<void> close() async {
    await Hive.close();
    _isInitialized = false;
  }

  /// Efface toutes les données locales (pour déconnexion par exemple)
  static Future<void> clearAll() async {
    final favoritesBox = Hive.box<FavoriteProperty>(_favoritesBoxName);
    final pendingMessagesBox = Hive.box<PendingMessage>(_pendingMessagesBoxName);
    final conversationsBox = Hive.box<CachedConversation>(_conversationsBoxName);
    final settings = GetStorage(_settingsContainer);

    await Future.wait([
      favoritesBox.clear(),
      pendingMessagesBox.clear(),
      conversationsBox.clear(),
      settings.erase(),
    ]);
  }
}
