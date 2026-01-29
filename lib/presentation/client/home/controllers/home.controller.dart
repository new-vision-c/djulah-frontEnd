import 'package:djulah/domain/entities/logement.dart';
import 'package:djulah/domain/enums/mockupFilter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';




class HomeController extends GetxController with GetSingleTickerProviderStateMixin {
  late final TabController tabController;
  final currentTab = 0.obs;
  
  // Location data
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxString currentLocationName = ''.obs;
  final RxString currentLocationAddress = ''.obs;
  final RxBool locationPermissionGranted = false.obs;
  final RxBool isLoadingLocation = true.obs;

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 3, vsync: this);

    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        currentTab.value = tabController.index;
      }
    });
    
    // Request location before loading data
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    isLoadingLocation.value = true;
    
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationPermissionGranted.value = false;
        isLoadingLocation.value = false;
        return;
      }

      // Check permission status
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationPermissionGranted.value = false;
          isLoadingLocation.value = false;
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        locationPermissionGranted.value = false;
        isLoadingLocation.value = false;
        return;
      }

      // Permission granted, get current position
      locationPermissionGranted.value = true;
      await _getCurrentLocation();
      
    } catch (e) {
      print("Location permission error: $e");
      locationPermissionGranted.value = false;
    } finally {
      isLoadingLocation.value = false;
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      
      currentPosition.value = position;
      
      // Reverse geocoding to get address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        currentLocationName.value = place.locality ?? place.subAdministrativeArea ?? 'Position actuelle';
        currentLocationAddress.value = '${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}'.trim();
        
        // Clean up address
        if (currentLocationAddress.value.startsWith(',')) {
          currentLocationAddress.value = currentLocationAddress.value.substring(1).trim();
        }
      }
      
    } catch (e) {
      print("Get current location error: $e");
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
