import 'dart:convert';
import 'dart:io';

import 'package:djulah/presentation/client/home/controllers/home.controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SearchModalController extends GetxController {
  final searchController = TextEditingController();
  final RxList<Map<String, dynamic>> searchResults = <Map<String, dynamic>>[].obs;
  final RxBool isSearching = false.obs;
  final RxString searchText = ''.obs;
  final RxString searchError = ''.obs; // Error message for user
  
  // Selected filters
  final Rx<Map<String, dynamic>?> selectedLocation = Rx<Map<String, dynamic>?>(null);
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final RxString selectedDateLabel = ''.obs;
  final RxString selectedLogementType = ''.obs;
  
  // Expanded states for filters
  final RxString expandedFilter = 'location'.obs; // 'location', 'date', 'type', or ''
  
  // Dynamic suggestions list (reactive)
  final RxList<Map<String, dynamic>> suggestions = <Map<String, dynamic>>[].obs;
  
  // Available logement types
  final List<Map<String, dynamic>> logementTypes = [
    {'id': 'appartement', 'label': 'Appartement', 'icon': Icons.apartment},
    {'id': 'maison', 'label': 'Maison', 'icon': Icons.home},
    {'id': 'studio', 'label': 'Studio', 'icon': Icons.single_bed},
    {'id': 'villa', 'label': 'Villa', 'icon': Icons.villa},
    {'id': 'chambre', 'label': 'Chambre', 'icon': Icons.bed},
    {'id': 'duplex', 'label': 'Duplex', 'icon': Icons.stairs},
    {'id': 'commercial', 'label': 'Commercial', 'icon': Icons.store},
  ];
  
  // OpenRouteService API Key
  static const String _orsApiKey = 'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6ImYzZWU4YjRhNWY3ZDRmMTA5MzU1MWE0MmVjMGI1NDI1IiwiaCI6Im11cm11cjY0In0=';

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchText.value = searchController.text;
    });

    debounce(
      searchText,
      (_) => onSearchChanged(),
      time: const Duration(milliseconds: 500),
    );
    
    // Build suggestions based on location
    _buildSuggestions();
    
    // Listen to HomeController location changes
    _listenToLocationChanges();
  }
  
  void _listenToLocationChanges() {
    try {
      final homeController = Get.find<HomeController>();
      
      // Listen to location permission changes
      ever(homeController.locationPermissionGranted, (_) => _buildSuggestions());
      ever(homeController.currentLocationName, (_) => _buildSuggestions());
      ever(homeController.isLoadingLocation, (_) => _buildSuggestions());
    } catch (e) {
      print("HomeController not found: $e");
    }
  }
  
  void _buildSuggestions() {
    final newSuggestions = <Map<String, dynamic>>[];
    
    try {
      final homeController = Get.find<HomeController>();
      
      // Only add "À proximité" if location permission is granted and location is loaded
      if (homeController.locationPermissionGranted.value && 
          !homeController.isLoadingLocation.value &&
          homeController.currentLocationName.value.isNotEmpty) {
        newSuggestions.add({
          'name': 'À proximité de vous',
          'address': homeController.currentLocationAddress.value.isNotEmpty 
              ? homeController.currentLocationAddress.value 
              : 'Votre position actuelle',
          'type': 'nearby',
          'iconColor': 0xFF22C55E,
          'backgroundColor': 0xFFDCFCE7,
          'latitude': homeController.currentPosition.value?.latitude ?? 0.0,
          'longitude': homeController.currentPosition.value?.longitude ?? 0.0,
        });
      }
    } catch (e) {
      // HomeController not found
    }
    
    // Add other default suggestions
    newSuggestions.addAll([
      {
        'name': 'Douala, Littoral',
        'address': 'Parceque vous avez enregistré des logement en favoris pour cette destination : Douala',
        'type': 'building',
        'iconColor': 0xFFF59E0B,
        'backgroundColor': 0xFFFEF3C7,
        'latitude': 4.0511,
        'longitude': 9.7679,
      },
      {
        'name': 'Yaoundé, Bastos',
        'address': 'Le top du top',
        'type': 'star',
        'iconColor': 0xFFF59E0B,
        'backgroundColor': 0xFFFEF3C7,
        'latitude': 3.8880,
        'longitude': 11.5174,
      },
    ]);
    
    suggestions.value = newSuggestions;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void onSearchChanged() {
    final query = searchText.value;

    if (query.isEmpty) {
      searchResults.clear();
      searchError.value = '';
      isSearching.value = false;
      return;
    }

    if (query.length < 3) return;

    isSearching.value = true;
    searchError.value = '';
    searchWithORS(query);
  }

  Future<void> searchWithORS(String query) async {
    try {
      final url = Uri.parse(
        'https://api.openrouteservice.org/geocode/search'
        '?text=${Uri.encodeComponent(query)}'
        '&boundary.country=CM'
        '&size=5',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': _orsApiKey,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List features = (data['features'] ?? []) as List;

        final results = features.map((f) {
          final props = f['properties'] as Map<String, dynamic>? ?? {};
          final geom = f['geometry'] as Map<String, dynamic>? ?? {};
          final coords = (geom['coordinates'] as List?) ?? [null, null];
          final double? lon = (coords.isNotEmpty && coords[0] != null) ? (coords[0] as num).toDouble() : null;
          final double? lat = (coords.length > 1 && coords[1] != null) ? (coords[1] as num).toDouble() : null;

          final name = (props['name'] ?? props['locality'] ?? props['street'] ?? props['county'] ?? props['region'] ?? props['label'] ?? '').toString();
          final address = (props['label'] ?? '').toString();
          final type = _getLocationType(props);

          return {
            'name': name,
            'address': address,
            'latitude': lat ?? 0.0,
            'longitude': lon ?? 0.0,
            'type': type,
            'iconColor': _getIconColorForType(type),
            'backgroundColor': _getBackgroundColorForType(type),
          };
        }).toList();

        searchResults.value = results.cast<Map<String, dynamic>>();
        searchError.value = '';
        isSearching.value = false;
      } else {
        searchResults.clear();
        searchError.value = 'Erreur du serveur. Réessayez plus tard.';
        isSearching.value = false;
      }
    } on SocketException catch (_) {
      print("Search error: No internet connection");
      searchResults.clear();
      searchError.value = 'Pas de connexion internet. Vérifiez votre réseau.';
      isSearching.value = false;
    } on http.ClientException catch (_) {
      print("Search error: Network error");
      searchResults.clear();
      searchError.value = 'Pas de connexion internet. Vérifiez votre réseau.';
      isSearching.value = false;
    } catch (e) {
      print("Search error: $e");
      searchResults.clear();
      if (e.toString().contains('TimeoutException')) {
        searchError.value = 'La requête a pris trop de temps. Réessayez.';
      } else {
        searchError.value = 'Une erreur est survenue. Réessayez.';
      }
      isSearching.value = false;
    }
  }

  String _getLocationType(Map<String, dynamic> props) {
    final category = (props['category'] ?? '').toString().toLowerCase();
    final layer = (props['layer'] ?? '').toString().toLowerCase();
    
    if (layer.contains('venue') || category.contains('amenity')) return 'building';
    if (layer.contains('locality') || layer.contains('neighbourhood')) return 'place';
    if (category.contains('transport')) return 'transport';
    if (category.contains('tourism')) return 'monument';
    return 'place';
  }

  int _getIconColorForType(String type) {
    switch (type) {
      case 'nearby':
        return 0xFF22C55E;
      case 'building':
        return 0xFFF59E0B;
      case 'calendar':
        return 0xFFEF4444;
      case 'star':
        return 0xFFF59E0B;
      case 'place':
        return 0xFF3B82F6;
      case 'transport':
        return 0xFF8B5CF6;
      case 'monument':
        return 0xFFEC4899;
      default:
        return 0xFF6B7280;
    }
  }

  int _getBackgroundColorForType(String type) {
    switch (type) {
      case 'nearby':
        return 0xFFDCFCE7;
      case 'building':
        return 0xFFFEF3C7;
      case 'calendar':
        return 0xFFFEE2E2;
      case 'star':
        return 0xFFFEF3C7;
      case 'place':
        return 0xFFDBEAFE;
      case 'transport':
        return 0xFFEDE9FE;
      case 'monument':
        return 0xFFFCE7F3;
      default:
        return 0xFFF3F4F6;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchText.value = '';
    searchResults.clear();
    isSearching.value = false;
  }
  
  void clearAllFilters() {
    clearSearch();
    selectedLocation.value = null;
    selectedDate.value = null;
    selectedDateLabel.value = '';
    selectedLogementType.value = '';
    expandedFilter.value = 'location';
  }

  void selectLocation(Map<String, dynamic> location) {
    selectedLocation.value = location;
    expandedFilter.value = ''; // Close location filter after selection
    print("Selected location: ${location['name']} - ${location['address']}");
  }
  
  void toggleFilter(String filterName) {
    if (expandedFilter.value == filterName) {
      expandedFilter.value = '';
    } else {
      expandedFilter.value = filterName;
    }
  }
  
  void selectDate(DateTime date, String label) {
    selectedDate.value = date;
    selectedDateLabel.value = label;
    expandedFilter.value = ''; // Close date filter after selection
  }
  
  void selectLogementType(String type) {
    selectedLogementType.value = type;
    expandedFilter.value = ''; // Close type filter after selection
  }
  
  String getFormattedDate() {
    if (selectedDate.value == null) return '';
    if (selectedDateLabel.value.isNotEmpty) return selectedDateLabel.value;
    
    final date = selectedDate.value!;
    final months = ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Jun', 'Jul', 'Aoû', 'Sep', 'Oct', 'Nov', 'Déc'];
    return '${date.day} ${months[date.month - 1]}';
  }
  
  String getLogementTypeLabel() {
    if (selectedLogementType.value.isEmpty) return '';
    final type = logementTypes.firstWhere(
      (t) => t['id'] == selectedLogementType.value,
      orElse: () => {'label': ''},
    );
    return type['label'] as String;
  }
}
