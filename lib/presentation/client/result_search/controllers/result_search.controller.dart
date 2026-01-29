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
  final RxInt totalLogements = 0.obs;
  final Rx<Map<String, dynamic>?> selectedLocation = Rx<Map<String, dynamic>?>(null);
  final DraggableScrollableController sheetController = DraggableScrollableController();
  final RxDouble sheetPosition = 0.45.obs;
  final RxBool isFullMapMode = false.obs;

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
    
    _generatePropertyLocations();
    
    isLoading.value = false;
  }

  void _generatePropertyLocations() {
    double baseLat = 3.8480;
    double baseLng = 11.5021;
    
    if (selectedLocation.value != null) {
      baseLat = (selectedLocation.value!['latitude'] ?? selectedLocation.value!['lat']) as double? ?? baseLat;
      baseLng = (selectedLocation.value!['longitude'] ?? selectedLocation.value!['lng']) as double? ?? baseLng;
    }
    
    final locations = <PropertyLocation>[];
    final random = Random();
    for (int i = 0; i < logements.length; i++) {
      final logement = logements[i];
      final angle = random.nextDouble() * 2 * pi;
      final distance = 0.001 + random.nextDouble() * 0.003;
      final latOffset = distance * cos(angle);
      final lngOffset = distance * sin(angle);
      
      locations.add(PropertyLocation(
        id: logement.id,
        title: logement.title,
        price: logement.priceText,
        latitude: baseLat + latOffset,
        longitude: baseLng + lngOffset,
        markerColor: Colors.black,
      ));
    }
    
    propertyLocations.assignAll(locations);
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
