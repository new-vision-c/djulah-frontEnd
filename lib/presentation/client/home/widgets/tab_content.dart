import 'package:djulah/domain/entities/logement.dart';
import 'package:djulah/domain/enums/mockupFilter.dart';
import 'package:djulah/domain/enums/type_logement.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/presentation/client/home/controllers/home.controller.dart';
import 'package:djulah/presentation/components/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../infrastructure/theme/client_theme.dart';
import '../../components/card.dart';

/// Simule la réponse du backend
/// Structure:
/// {
///   'categories': [{'image': ..., 'titre': ...}],
///   'a_proximite_de_vous': [...],  // Seulement si localisation acceptée
///   'les_plus_reserves': [...],
///   'recommandes_pour_vous': [...],
/// }
class BackendResponse {
  final List<Map<String, dynamic>> categories;
  final List<Logement>? aProximiteDeVous; // null si localisation refusée
  final List<Logement> lesPlusReserves;
  final List<Logement> recommandesPourVous;
  
  BackendResponse({
    required this.categories,
    this.aProximiteDeVous,
    required this.lesPlusReserves,
    required this.recommandesPourVous,
  });
}

class TabContentController extends GetxController {
  final TypeLogement typeLogement;

  TabContentController({required this.typeLogement});

  // Categories avec image et titre
  final categories = <Map<String, dynamic>>[].obs;
  // Logements à proximité (null si pas de localisation)
  final Rx<List<Logement>?> logementByDistance = Rx<List<Logement>?>(null);
  // Les plus réservés
  final logementByUse = <Logement>[].obs;
  // Recommandés pour vous
  final logementRecommandes = <Logement>[].obs;
  
  final isLoading = true.obs;
  final RxBool hasLocationPermission = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkLocationAndLoadData();
  }
  
  Future<void> _checkLocationAndLoadData() async {
    isLoading.value = true;
    
    try {
      final homeController = Get.find<HomeController>();
      
      // Attendre la fin du chargement de la localisation
      if (homeController.isLoadingLocation.value) {
        await Future.doWhile(() async {
          await Future.delayed(const Duration(milliseconds: 100));
          return homeController.isLoadingLocation.value;
        });
      }
      
      hasLocationPermission.value = homeController.locationPermissionGranted.value;
    } catch (e) {
      hasLocationPermission.value = false;
    }
    
    await _loadDataFromBackend();
  }

  Future<void> _loadDataFromBackend() async {
    await Future.delayed(const Duration(seconds: 2));
    
    final backendResponse = _simulateBackendResponse();
    
    categories.value = backendResponse.categories;
    logementByDistance.value = backendResponse.aProximiteDeVous;
    logementByUse.value = backendResponse.lesPlusReserves;
    logementRecommandes.value = backendResponse.recommandesPourVous;
    
    isLoading.value = false;
  }

  BackendResponse _simulateBackendResponse() {
    final allLogements = MockupLogements.logementsByFilter(Mockupfilter.categories)
        .where((l) => l.typeLogement == typeLogement)
        .toList();
    
    final splashImages = [
      'assets/images/client/imagesSplash/1.jpg',
      'assets/images/client/imagesSplash/2.jpg',
      'assets/images/client/imagesSplash/3.jpg',
      'assets/images/client/imagesSplash/4.jpg',
    ];
    
    final categoriesData = allLogements.asMap().entries.map((entry) {
      final index = entry.key;
      final logement = entry.value;
      return {
        'image': splashImages[index % splashImages.length],
        'titre': logement.category,
        'logement': logement,
      };
    }).toList();
    
    // Les plus réservés (toujours renvoyés)
    final mostReserved = MockupLogements.logementsByFilter(Mockupfilter.most_reserve)
        .where((l) => l.typeLogement == typeLogement)
        .toList();
    
    // Recommandés pour vous (toujours renvoyés)
    final recommended = MockupLogements.logementsByFilter(Mockupfilter.categories)
        .where((l) => l.typeLogement == typeLogement)
        .take(5)
        .toList();
    
    List<Logement>? nearbyLogements;
    if (hasLocationPermission.value) {
      nearbyLogements = MockupLogements.logementsByFilter(Mockupfilter.proximite)
          .where((l) => l.typeLogement == typeLogement)
          .toList();
    }
    
    return BackendResponse(
      categories: categoriesData,
      aProximiteDeVous: nearbyLogements,
      lesPlusReserves: mostReserved,
      recommandesPourVous: recommended,
    );
  }
  
  /// Méthode de rafraîchissement pour le pull-to-refresh
  Future<void> onRefresh() async {
    await _checkLocationAndLoadData();
  }
}

class TabContent extends StatelessWidget {
  final TypeLogement typeLogement;

  const TabContent(this.typeLogement, {super.key});

  String get _tag => typeLogement.name;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabContentController>(
      tag: _tag,
      init: TabContentController(typeLogement: typeLogement),
      autoRemove: false,
      builder: (controller) {
        return Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerLoading(controller.hasLocationPermission.value);
          }
          
          bool isEmpty = controller.categories.isEmpty &&
              controller.logementByDistance.value == null &&
              controller.logementByUse.isEmpty;

          if (isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: controller.onRefresh,
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 28.r),
              children: [
                _buildCategorySection(
                  title: 'home.categories'.tr,
                  items: controller.categories,
                ),
              
              if (controller.logementByDistance.value != null &&
                  controller.logementByDistance.value!.isNotEmpty)
                _buildSection(
                  title: 'home.near_you'.tr,
                  height: 249.h,
                  itemCount: controller.logementByDistance.value!.length,
                  itemBuilder: (index) {
                    final item = controller.logementByDistance.value![index];
                    return AppCard(item: item, key: Key(item.id.toString()));
                  },
                ),
              
              _buildSection(
                title: 'home.most_booked'.tr,
                height: 249.h,
                itemCount: controller.logementByUse.length,
                itemBuilder: (index) {
                  final item = controller.logementByUse[index];
                  return AppCard(item: item, key: Key(item.id.toString()));
                },
              ),
              
              if (controller.logementRecommandes.isNotEmpty)
                _buildSection(
                  title: 'home.recommended'.tr,
                  height: 249.h,
                  itemCount: controller.logementRecommandes.length,
                  itemBuilder: (index) {
                    final item = controller.logementRecommandes[index];
                    return AppCard(item: item, key: Key(item.id.toString()));
                  },
                ),
            ],
            ),
          );
        });
      },
    );
  }

  Widget _buildCategorySection({
    required String title,
    required List<Map<String, dynamic>> items,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.r, bottom: 28.r, top: 12.h),
          child: Row(
            spacing: 4.r,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1.r,
                  height: 24.sp / 20.sp,
                  color: ClientTheme.textPrimaryColor,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: ClientTheme.primaryColor,
                size: 16.r,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => SizedBox(width: 16.r),
            itemBuilder: (_, index) {
              final item = items[index];
              return _buildCategoryItemFromMap(item);
            },
          ),
        ),
        SizedBox(height: 28.h),
      ],
    );
  }

  Widget _buildCategoryItemFromMap(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        // Navigate to result search with category filter
        Get.toNamed(
          RouteNames.clientResultSearch,
          arguments: {
            'category': item['titre'],
            'logement': item['logement'],
          },
        );
      },
      child: Container(
        width: 108.r,
        child: Column(
          spacing: 8.r,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.asset(
                item['image'] as String,
                width: 108.r,
                height: 102.r,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              item['titre'] as String,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.8.r,
                height: 20.sp / 16.sp,
                color: ClientTheme.textPrimaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home_work_outlined, size: 64.r, color: const Color(0xFFC9C9C9)),
          SizedBox(height: 16.h),
          Text(
            'home.no_property_found'.tr,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: ClientTheme.textPrimaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 16.r),
            child: Text(
              'home.no_property_message'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: ClientTheme.textTertiaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required double height,
    required int itemCount,
    required Widget Function(int) itemBuilder,
  }) {
    if (itemCount == 0) return const SizedBox.shrink();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.r, bottom: 28.r, top: 12.h),
          child: Row(
            spacing: 4.r,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1.r,
                  height: 24.sp / 20.sp,
                  color: ClientTheme.textPrimaryColor,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: ClientTheme.primaryColor,
                size: 16.r,
              ),
            ],
          ),
        ),
        SizedBox(
          height: height,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            separatorBuilder: (_, __) => SizedBox(width: 16.r),
            itemBuilder: (_, index) => itemBuilder(index),
          ),
        ),
        SizedBox(height: 28.h),
      ],
    );
  }

  Widget _buildShimmerLoading(bool hasLocationPermission) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 28.r),
      children: [
        _buildShimmerSection(title: "Categories", height: 130.h, itemWidth: 108.r),
        SizedBox(height: 28.r),
        // Afficher shimmer "À proximité" seulement si localisation acceptée
        if (hasLocationPermission) ...[
          _buildShimmerSection(title: "À proximité de vous", height: 249.h, itemWidth: 177.r),
          SizedBox(height: 28.r),
        ],
        _buildShimmerSection(title: "Les plus réservés cette semaine", height: 249.h, itemWidth: 177.r),
        SizedBox(height: 28.r),
        _buildShimmerSection(title: "Recommandés pour vous", height: 249.h, itemWidth: 177.r),
      ],
    );
  }

  Widget _buildShimmerSection({required String title, required double height, required double itemWidth}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16.r, bottom: 28.r),
          child: ShimmerBox(width: 150.w, height: 24.sp, borderRadius: 4.r),
        ),
        SizedBox(
          height: height,
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (_, __) => Container(
              margin: EdgeInsets.only(right: 23.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: itemWidth, height: itemWidth == 108.r ? 102.r : 177.r, borderRadius: itemWidth == 108.r ? 12.r : 20.r),
                  SizedBox(height: 10.r),
                  ShimmerBox(width: itemWidth * 0.8, height: 16.sp, borderRadius: 4.r),
                  if (itemWidth != 108.r) ...[
                    SizedBox(height: 8.r),
                    ShimmerBox(width: itemWidth * 0.5, height: 14.sp, borderRadius: 4.r),
                  ]
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
