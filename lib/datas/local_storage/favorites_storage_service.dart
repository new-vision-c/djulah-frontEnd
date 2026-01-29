import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/logement.dart';
import '../models/favorite_property.model.dart';
import 'local_storage_initializer.dart';

/// Service de gestion des favoris localement
/// Utilise Hive pour la persistence et GetStorage pour les settings rapides
class FavoritesStorageService extends GetxService {
  late Box<FavoriteProperty> _favoritesBox;
  late GetStorage _quickStorage;

  /// Liste observable des IDs des favoris (pour accès rapide)
  final RxSet<String> favoriteIds = <String>{}.obs;

  /// Liste observable des favoris complets
  final RxList<FavoriteProperty> favorites = <FavoriteProperty>[].obs;

  /// Favoris non synchronisés avec le backend
  final RxList<FavoriteProperty> unsyncedFavorites = <FavoriteProperty>[].obs;

  @override
  void onInit() {
    super.onInit();
    _favoritesBox = Hive.box<FavoriteProperty>(
      LocalStorageInitializer.favoritesBoxName,
    );
    _quickStorage = GetStorage(LocalStorageInitializer.settingsContainer);
    _loadFavorites();
  }

  /// Charge les favoris depuis le stockage local
  void _loadFavorites() {
    final allFavorites = _favoritesBox.values.toList();
    favorites.assignAll(allFavorites);
    favoriteIds.assignAll(allFavorites.map((f) => f.propertyId));
    unsyncedFavorites.assignAll(
      allFavorites.where((f) => !f.isSyncedWithBackend),
    );
  }

  /// Vérifie si une propriété est en favoris
  bool isFavorite(String propertyId) {
    return favoriteIds.contains(propertyId);
  }

  /// Ajoute une propriété aux favoris
  Future<void> addFavorite(Logement logement, {String? userId}) async {
    if (isFavorite(logement.id)) return;

    final favorite = FavoriteProperty(
      propertyId: logement.id,
      title: logement.title,
      imagePath: logement.imagePath,
      priceText: logement.priceText,
      rating: logement.rating,
      category: logement.category,
      addedAt: DateTime.now(),
      isSyncedWithBackend: false,
      userId: userId,
    );

    // Utiliser l'ID comme clé pour faciliter la recherche
    await _favoritesBox.put(logement.id, favorite);
    
    favorites.add(favorite);
    favoriteIds.add(logement.id);
    unsyncedFavorites.add(favorite);

    // Sauvegarder les IDs dans GetStorage pour accès ultra-rapide
    _saveQuickIds();
  }

  /// Retire une propriété des favoris
  Future<void> removeFavorite(String propertyId) async {
    await _favoritesBox.delete(propertyId);
    
    favorites.removeWhere((f) => f.propertyId == propertyId);
    favoriteIds.remove(propertyId);
    unsyncedFavorites.removeWhere((f) => f.propertyId == propertyId);

    _saveQuickIds();
  }

  /// Toggle un favori (ajoute si absent, retire si présent)
  Future<bool> toggleFavorite(Logement logement, {String? userId}) async {
    if (isFavorite(logement.id)) {
      await removeFavorite(logement.id);
      return false;
    } else {
      await addFavorite(logement, userId: userId);
      return true;
    }
  }

  /// Marque un favori comme synchronisé avec le backend
  Future<void> markAsSynced(String propertyId, {String? serverId}) async {
    final favorite = _favoritesBox.get(propertyId);
    if (favorite == null) return;

    final updatedFavorite = favorite.copyWith(isSyncedWithBackend: true);
    await _favoritesBox.put(propertyId, updatedFavorite);

    // Mettre à jour les listes
    final index = favorites.indexWhere((f) => f.propertyId == propertyId);
    if (index != -1) {
      favorites[index] = updatedFavorite;
    }
    unsyncedFavorites.removeWhere((f) => f.propertyId == propertyId);
  }

  /// Récupère tous les favoris non synchronisés pour sync avec backend
  List<FavoriteProperty> getUnsyncedFavorites() {
    return _favoritesBox.values
        .where((f) => !f.isSyncedWithBackend)
        .toList();
  }

  /// Synchronise les favoris depuis le backend (merge)
  Future<void> syncFromBackend(List<FavoriteProperty> backendFavorites) async {
    for (final backendFav in backendFavorites) {
      final localFav = _favoritesBox.get(backendFav.propertyId);
      
      if (localFav == null) {
        // Favori du backend non présent localement, l'ajouter
        final synced = backendFav.copyWith(isSyncedWithBackend: true);
        await _favoritesBox.put(backendFav.propertyId, synced);
      } else if (!localFav.isSyncedWithBackend) {
        // Favori local non synchronisé, garder la version locale
        // mais marquer comme synchronisé si le backend l'a
        await markAsSynced(localFav.propertyId);
      }
    }

    _loadFavorites();
  }

  /// Récupère les favoris récents (pour affichage)
  List<FavoriteProperty> getRecentFavorites({int limit = 10}) {
    final sorted = favorites.toList()
      ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
    return sorted.take(limit).toList();
  }

  /// Récupère les favoris par catégorie
  List<FavoriteProperty> getFavoritesByCategory(String category) {
    return favorites.where((f) => f.category == category).toList();
  }

  /// Sauvegarde les IDs dans GetStorage pour accès rapide
  void _saveQuickIds() {
    _quickStorage.write('favorite_ids', favoriteIds.toList());
  }

  /// Charge les IDs depuis GetStorage (pour démarrage rapide)
  Set<String> loadQuickIds() {
    final ids = _quickStorage.read<List<dynamic>>('favorite_ids');
    if (ids != null) {
      return ids.cast<String>().toSet();
    }
    return {};
  }

  /// Efface tous les favoris locaux
  Future<void> clearAll() async {
    await _favoritesBox.clear();
    favorites.clear();
    favoriteIds.clear();
    unsyncedFavorites.clear();
    _quickStorage.remove('favorite_ids');
  }

  /// Nombre total de favoris
  int get count => favorites.length;

  /// Nombre de favoris non synchronisés
  int get unsyncedCount => unsyncedFavorites.length;
}
