import 'dart:math';

import 'package:djulah/domain/entities/logement.dart';
import 'package:djulah/presentation/client/components/map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResultSearchController extends GetxController {
  final Rx<Map<String, dynamic>?> filters = Rx<Map<String, dynamic>?>(null);
  final RxList<Logement> logements = <Logement>[].obs;
  final RxList<PropertyLocation> propertyLocations = <PropertyLocation>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isRefreshingMarkers = false.obs;
  final RxInt totalLogements = 0.obs;
  final Rx<Map<String, dynamic>?> selectedLocation = Rx<Map<String, dynamic>?>(null);
  final DraggableScrollableController sheetController = DraggableScrollableController();
  final RxDouble sheetPosition = 0.45.obs;
  final RxBool isFullMapMode = false.obs;
  
  /// Zone visible actuelle de la carte
  final Rx<MapBounds?> currentMapBounds = Rx<MapBounds?>(null);
  
  /// Dernière position de caméra pour éviter les rafraîchissements inutiles
  double? _lastCenterLat;
  double? _lastCenterLng;
  double? _lastZoom;
  
  /// Seed pour la génération aléatoire (pour avoir des positions cohérentes)
  int _randomSeed = 42;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args is Map<String, dynamic>) {
      filters.value = args;
      selectedLocation.value = args['location'] as Map<String, dynamic>?;
    }
    _loadLogements();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    sheetController.dispose();
    super.onClose();
  }

  Future<void> _loadLogements() async {
    isLoading.value = true;
    
    await Future.delayed(const Duration(milliseconds: 800));
    
    logements.assignAll(MockupLogements.logements);
    totalLogements.value = logements.length;
    
    // Les propriétés seront générées quand la carte enverra ses bounds initiaux
    // via onCameraIdle -> onMapBoundsChanged
    
    isLoading.value = false;
  }

  /// Génère les positions des propriétés dans la zone visible de la carte
  /// Les propriétés sont distribuées dans toute la zone visible
  void _generatePropertyLocations() {
    if (currentMapBounds.value == null) {
      debugPrint('ResultSearchController: No map bounds yet, skipping property generation');
      return;
    }
    
    final bounds = currentMapBounds.value!;
    debugPrint('ResultSearchController: Generating properties for bounds - zoom: ${bounds.zoom.toStringAsFixed(1)}, center: (${bounds.center.latitude.toStringAsFixed(4)}, ${bounds.center.longitude.toStringAsFixed(4)})');
    
    // Calculer la zone visible
    final centerLat = bounds.center.latitude;
    final centerLng = bounds.center.longitude;
    
    // Le spread dépend du zoom : plus on est zoomé, plus les propriétés sont proches
    // Les propriétés sont distribuées dans 80% de la zone visible
    final latRange = (bounds.north - bounds.south) * 0.4; // 40% de chaque côté du centre
    final lngRange = (bounds.east - bounds.west) * 0.4;
    
    final locations = <PropertyLocation>[];
    
    // Utiliser un seed basé sur le centre pour avoir des positions cohérentes
    // mais qui changent quand on se déplace significativement
    final seedLat = (centerLat * 1000).round();
    final seedLng = (centerLng * 1000).round();
    final random = Random(seedLat + seedLng + _randomSeed);
    
    for (int i = 0; i < logements.length; i++) {
      final logement = logements[i];
      
      // Distribution uniforme dans la zone visible
      final latOffset = (random.nextDouble() * 2 - 1) * latRange;
      final lngOffset = (random.nextDouble() * 2 - 1) * lngRange;
      
      locations.add(PropertyLocation(
        id: logement.id,
        title: logement.title,
        price: logement.priceText,
        latitude: centerLat + latOffset,
        longitude: centerLng + lngOffset,
        markerColor: Colors.black,
      ));
    }
    
    propertyLocations.assignAll(locations);
    debugPrint('ResultSearchController: Generated ${locations.length} property locations');
  }

  /// Appelé quand la zone visible de la carte change (zoom ou déplacement)
  void onMapBoundsChanged(MapBounds bounds) {
    // Calculer le rayon visible actuel (approximatif en km)
    final currentRadius = _calculateVisibleRadius(bounds);
    final previousRadius = _lastZoom != null ? _calculateRadiusFromZoom(_lastZoom!) : null;
    
    // Vérifier si le centre a bougé significativement (plus de 20% du rayon visible)
    final significantMove = _lastCenterLat == null ||
        _lastCenterLng == null ||
        _calculateDistance(
          bounds.center.latitude, 
          bounds.center.longitude, 
          _lastCenterLat!, 
          _lastCenterLng!
        ) > currentRadius * 0.2;
    
    // Vérifier si le zoom a changé significativement (plus de 0.3 niveau)
    final significantZoom = _lastZoom == null || (bounds.zoom - _lastZoom!).abs() > 0.3;
    
    if (significantMove || significantZoom) {
      debugPrint('ResultSearchController: Map bounds changed significantly - move: $significantMove, zoom: $significantZoom');
      
      _lastCenterLat = bounds.center.latitude;
      _lastCenterLng = bounds.center.longitude;
      _lastZoom = bounds.zoom;
      
      currentMapBounds.value = bounds;
      
      // Rafraîchir les propriétés pour la nouvelle zone
      _refreshPropertiesForBounds(bounds);
    }
  }

  /// Calcule le rayon visible approximatif en km
  double _calculateVisibleRadius(MapBounds bounds) {
    final latDiff = bounds.north - bounds.south;
    final lngDiff = bounds.east - bounds.west;
    // Approximation: 1 degré = 111 km
    return ((latDiff + lngDiff) / 2) * 111 / 2;
  }

  /// Calcule le rayon approximatif basé sur le niveau de zoom
  double _calculateRadiusFromZoom(double zoom) {
    // À zoom 15, environ 1km de rayon visible
    return 40000 / pow(2, zoom);
  }

  /// Calcule la distance entre deux points en km (formule Haversine simplifiée)
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    final latDiff = (lat2 - lat1).abs();
    final lngDiff = (lng2 - lng1).abs();
    // Approximation: 1 degré = 111 km
    return sqrt(latDiff * latDiff + lngDiff * lngDiff) * 111;
  }

  /// Rafraîchit les propriétés pour la zone visible
  Future<void> _refreshPropertiesForBounds(MapBounds bounds) async {
    if (isRefreshingMarkers.value) return;
    
    isRefreshingMarkers.value = true;
    
    // Simuler un délai réseau (dans une vraie app, ce serait un appel API)
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Changer le seed pour avoir de nouvelles positions
    _randomSeed = DateTime.now().millisecondsSinceEpoch;
    
    // Régénérer les positions des propriétés
    _generatePropertyLocations();
    
    isRefreshingMarkers.value = false;
  }

  double get mapCenterLat {
    if (selectedLocation.value != null) {
      return (selectedLocation.value!['latitude'] ?? selectedLocation.value!['lat']) as double? ?? 3.8480;
    }
    return 3.8480;
  }

  double get mapCenterLng {
    if (selectedLocation.value != null) {
      return (selectedLocation.value!['longitude'] ?? selectedLocation.value!['lng']) as double? ?? 11.5021;
    }
    return 11.5021;
  }

  String get locationName {
    if (selectedLocation.value != null) {
      return selectedLocation.value!['name'] as String? ?? 'Lieu recherché';
    }
    return 'Tous les lieux';
  }


  void toggleFullMap() {
    if (isFullMapMode.value) {
      sheetController.animateTo(
        0.45,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      isFullMapMode.value = false;
    } else {
      sheetController.animateTo(
        0.08,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      isFullMapMode.value = true;
    }
  }

  void onSheetPositionChanged(double position) {
    sheetPosition.value = position;
    isFullMapMode.value = position < 0.15;
  }

  Future<void> refreshSearch(Map<String, dynamic> newFilters) async {
    filters.value = newFilters;
    selectedLocation.value = newFilters['location'] as Map<String, dynamic>?;
    
    logements.clear();
    propertyLocations.clear();
    
    sheetController.animateTo(
      0.45,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    
    await _loadLogements();
  }
}
