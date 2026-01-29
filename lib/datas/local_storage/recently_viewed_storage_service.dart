import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../domain/entities/logement.dart';
import 'local_storage_initializer.dart';

/// Modèle pour stocker un logement vu récemment avec sa date
class RecentlyViewedItem {
  final String logementId;
  final DateTime viewedAt;

  RecentlyViewedItem({
    required this.logementId,
    required this.viewedAt,
  });

  /// Texte relatif pour affichage (ex: "Hier", "Il y a 3 jours")
  String get relativeDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final viewedDay = DateTime(viewedAt.year, viewedAt.month, viewedAt.day);
    final diff = today.difference(viewedDay).inDays;

    if (diff == 0) {
      return "Aujourd'hui";
    } else if (diff == 1) {
      return "Hier";
    } else if (diff < 7) {
      return "Il y a $diff jours";
    } else if (diff < 30) {
      final weeks = (diff / 7).floor();
      return "Il y a $weeks semaine${weeks > 1 ? 's' : ''}";
    } else {
      final months = (diff / 30).floor();
      return "Il y a $months mois";
    }
  }

  Map<String, dynamic> toJson() => {
    'logementId': logementId,
    'viewedAt': viewedAt.toIso8601String(),
  };

  factory RecentlyViewedItem.fromJson(Map<String, dynamic> json) => RecentlyViewedItem(
    logementId: json['logementId'] as String,
    viewedAt: DateTime.parse(json['viewedAt'] as String),
  );
}

/// Service de gestion des logements vus récemment
/// Utilise GetStorage pour un stockage rapide et léger
class RecentlyViewedStorageService extends GetxService {
  late GetStorage _storage;
  
  static const String _recentlyViewedKey = 'recently_viewed_v2';
  static const int _maxRecentItems = 20;

  /// Liste observable des items vus récemment (avec dates)
  final RxList<RecentlyViewedItem> recentlyViewedItems = <RecentlyViewedItem>[].obs;
  
  /// Liste observable des IDs vus récemment (pour compatibilité)
  RxList<String> get recentlyViewedIds => 
      RxList<String>(recentlyViewedItems.map((item) => item.logementId).toList());

  @override
  void onInit() {
    super.onInit();
    _storage = GetStorage(LocalStorageInitializer.settingsContainer);
    _loadRecentlyViewed();
  }

  /// Charge les items vus récemment depuis le stockage
  void _loadRecentlyViewed() {
    final data = _storage.read<String>(_recentlyViewedKey);
    if (data != null) {
      try {
        final List<dynamic> jsonList = jsonDecode(data);
        recentlyViewedItems.assignAll(
          jsonList.map((json) => RecentlyViewedItem.fromJson(json as Map<String, dynamic>)).toList()
        );
      } catch (_) {
        // Migration depuis l'ancien format (liste d'IDs)
        _migrateFromOldFormat();
      }
    }
  }
  
  /// Migre depuis l'ancien format (liste d'IDs simple)
  void _migrateFromOldFormat() {
    final oldData = _storage.read<List<dynamic>>('recently_viewed');
    if (oldData != null) {
      final now = DateTime.now();
      recentlyViewedItems.assignAll(
        oldData.cast<String>().asMap().entries.map((entry) => 
          RecentlyViewedItem(
            logementId: entry.value,
            viewedAt: now.subtract(Duration(hours: entry.key)), // Espacer artificiellement
          )
        ).toList()
      );
      _save();
      _storage.remove('recently_viewed'); // Supprimer l'ancien format
    }
  }

  /// Ajoute un logement aux vus récemment
  Future<void> addToRecentlyViewed(String logementId) async {
    // Retirer si déjà présent (pour le remettre en premier avec nouvelle date)
    recentlyViewedItems.removeWhere((item) => item.logementId == logementId);
    
    // Ajouter en premier avec la date actuelle
    recentlyViewedItems.insert(0, RecentlyViewedItem(
      logementId: logementId,
      viewedAt: DateTime.now(),
    ));
    
    // Limiter la taille
    if (recentlyViewedItems.length > _maxRecentItems) {
      recentlyViewedItems.removeRange(_maxRecentItems, recentlyViewedItems.length);
    }
    
    await _save();
  }

  /// Supprime un logement des vus récemment
  Future<void> removeFromRecentlyViewed(String logementId) async {
    recentlyViewedItems.removeWhere((item) => item.logementId == logementId);
    await _save();
  }

  /// Efface tout l'historique
  Future<void> clearAll() async {
    recentlyViewedItems.clear();
    await _storage.remove(_recentlyViewedKey);
  }

  /// Sauvegarde dans le stockage
  Future<void> _save() async {
    final jsonList = recentlyViewedItems.map((item) => item.toJson()).toList();
    await _storage.write(_recentlyViewedKey, jsonEncode(jsonList));
  }

  /// Récupère les propriétés vues récemment depuis les mockups
  List<Propriete> getRecentLogements({int limit = 7}) {
    final allProprietes = MockupProprietes.logements;
    
    return recentlyViewedItems
        .take(limit)
        .map((item) => allProprietes.firstWhereOrNull((p) => p.id == item.logementId))
        .whereType<Propriete>()
        .toList();
  }
  
  /// Alias pour rétrocompatibilité
  @Deprecated('Utiliser getRecentProprietes à la place')
  List<Propriete> getRecentProprietes({int limit = 7}) => getRecentLogements(limit: limit);
  
  /// Récupère les items avec leurs dates
  List<RecentlyViewedItem> getRecentItems({int limit = 7}) {
    return recentlyViewedItems.take(limit).toList();
  }
  
  /// Récupère la date relative d'une propriété vue
  String? getViewedDateFor(String proprieteId) {
    final item = recentlyViewedItems.firstWhereOrNull(
      (item) => item.logementId == proprieteId
    );
    return item?.relativeDate;
  }

  /// Récupère les 4 premières images pour l'affichage grille
  List<String> getRecentImages({int count = 4}) {
    final proprietes = getRecentLogements(limit: count);
    final images = proprietes.map((p) => p.imagePath).toList();
    
    // Compléter avec des images par défaut si nécessaire
    final defaults = [
      "assets/images/client/imagesSplash/1.jpg",
      "assets/images/client/imagesSplash/2.jpg",
      "assets/images/client/imagesSplash/3.jpg",
      "assets/images/client/imagesSplash/4.jpg"
    ];
    
    while (images.length < count) {
      images.add(defaults[images.length % defaults.length]);
    }
    
    return images.take(count).toList();
  }

  /// Nombre de logements vus récemment
  int get count => recentlyViewedIds.length;

  /// Vérifie si la liste est vide
  bool get isEmpty => recentlyViewedIds.isEmpty;
}
