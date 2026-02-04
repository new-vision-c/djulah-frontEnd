import 'package:djulah/domain/entities/logement.dart';
import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:djulah/presentation/client/components/card2.dart';
import 'package:djulah/presentation/client/components/map.dart';
import 'package:djulah/presentation/client/favoris/controllers/favoris.controller.dart';
import 'package:djulah/presentation/client/home/widgets/search_modal.dart';
import 'package:djulah/presentation/components/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import 'controllers/result_search.controller.dart';

class ResultSearchScreen extends GetView<ResultSearchController> {
  const ResultSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Obx(() => MapWidget(
                latitude: controller.mapCenterLat,
                longitude: controller.mapCenterLng,
                height: double.infinity,
                propertyLocations: controller.propertyLocations.toList(),
                showFullscreenButton: false,
                markerColor: Colors.black,
                overlayOpacity: 0.2,
                initialZoom: 18,
                disableMarkerAnimation: true,
                markerSize: 40.r,
                showCenterMarker: false,
                onCameraIdle: (bounds) {
                  controller.onMapBoundsChanged(bounds);
                },
                onPropertyTap: (property) {
                  final logement = controller.logements.firstWhereOrNull(
                    (l) => l.id == property.id,
                  );
                  if (logement != null) {
                    Get.toNamed(RouteNames.clientDetailsLogement, arguments: logement);
                  }
                },
              )),
            ),
            DraggableScrollableSheet(
              controller: controller.sheetController,
              initialChildSize: 0.45,
              minChildSize: 0.08,
              maxChildSize: 0.92,
              snap: true,
              snapSizes: const [0.08, 0.45, 0.92],
              builder: (context, scrollController) {
                return NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    controller.onSheetPositionChanged(notification.extent);
                    return true;
                  },
                  child: GestureDetector(
                    onVerticalDragUpdate: (details) {
                      if (controller.isFullMapMode.value && details.delta.dy < 0) {
                        controller.sheetController.animateTo(
                          0.45,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (controller.isFullMapMode.value) {
                                controller.sheetController.animateTo(
                                  0.45,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                );
                              } else {
                                controller.toggleFullMap();
                              }
                            },
                            onVerticalDragUpdate: (details) {
                              final screenHeight = MediaQuery.of(context).size.height;
                              final dragDelta = -details.delta.dy / screenHeight;
                              final currentSize = controller.sheetPosition.value;
                              final newSize = (currentSize + dragDelta).clamp(0.08, 0.92);
                              controller.sheetController.jumpTo(newSize);
                            },
                            onVerticalDragEnd: (details) {
                              final currentSize = controller.sheetPosition.value;
                              double targetSize;
                              if (currentSize < 0.25) {
                                targetSize = 0.08;
                              } else if (currentSize < 0.68) {
                                targetSize = 0.45;
                              } else {
                                targetSize = 0.92;
                              }
                              controller.sheetController.animateTo(
                                targetSize,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              color: Colors.transparent,
                              child: Center(
                                child: Container(
                                  width: 47.w,
                                  height: 4.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE2E2E2),
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Content
                          Expanded(
                            child: Obx(() => _buildSheetContent(scrollController)),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            // AppBar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildAppBar(context),
            ),
            Obx(() => controller.sheetPosition.value > 0.3
                ? Positioned(
              bottom:  50.h,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => controller.toggleFullMap(),
                  child: Image.asset(
                    "assets/images/client/bouton_map.png",
                  ),
                ),
              ),
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                size: 20.r,
                color: ClientTheme.primaryColor,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () {
              SearchModal.show(
                context,
                onLocationSelected: (location) {
                  controller.refreshSearch({
                    'location': location,
                    ...?controller.filters.value,
                  });
                },
              );
            },
            child: Container(
              width: 270.w,
              height: 56.h,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 16.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(1000.r),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 0),
                    blurRadius: 17.2,
                    spreadRadius: 6,
                    color: Colors.black.withOpacity(0.05),
                  ),
                  BoxShadow(
                    offset: Offset(0, 33),
                    blurRadius: 9,
                    spreadRadius: 0,
                    color: Color(0xFFC9C9C9).withOpacity(0.00),
                  ),
                  BoxShadow(
                    offset: Offset(0, 21),
                    blurRadius: 8,
                    spreadRadius: 0,
                    color: Color(0xFFC9C9C9).withOpacity(0.03),
                  ),
                  BoxShadow(
                    offset: Offset(0, 12),
                    blurRadius: 7,
                    spreadRadius: 0,
                    color: Color(0xFFC9C9C9).withOpacity(0.09),
                  ),
                  BoxShadow(
                    offset: Offset(0, 5),
                    blurRadius: 5,
                    spreadRadius: 0,
                    color: Color(0xFFC9C9C9).withOpacity(0.15),
                  ),
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    spreadRadius: 0,
                    color: Color(0xFFC9C9C9).withOpacity(0.18),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                spacing: 10.r,
                children: [
                  Container(
                    padding: EdgeInsets.all(3.r),
                    child: Image.asset(
                        "assets/images/client/BottomNavImages/search.png",
                        width: 18.r, height: 18.r),
                  ),
                  Text(
                    "Commencer ma recherche",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.9.r,
                      height: 24.sp / 18.sp,
                      color: Color(0xFF6A6A6A),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () {
            },
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                Icons.tune,
                size: 20.r,
                color: ClientTheme.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetContent(ScrollController scrollController) {
    if (controller.isLoading.value) {
      return _buildLoadingState();
    }
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Obx(() => Text(
              "Plus de ${controller.totalLogements.value} logements",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
                height: 20.sp/16.sp,
                letterSpacing: -0.48.r,
              ),
              textAlign: TextAlign.center,
            )),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index >= controller.logements.length) return null;
                final logement = controller.logements[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: AppCard2(
                    item: _logementToEnregistrement(logement),
                  ),
                );
              },
              childCount: controller.logements.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Center(
              child: ShimmerBox(
                width: 180.w,
                height: 20.h,
                borderRadius: 10.r,
              ),
            ),
          ),
        ),
        // Logements shimmer list
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 24.h),
                  child: _buildShimmerCard(),
                );
              },
              childCount: 4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerBox(
          width: double.infinity,
          height: 280.h,
          borderRadius: 12.r,
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                    width: 200.w,
                    height: 18.h,
                    borderRadius: 4.r,
                  ),
                  SizedBox(height: 8.h),
                  ShimmerBox(
                    width: 120.w,
                    height: 14.h,
                    borderRadius: 4.r,
                  ),
                  SizedBox(height: 4.h),
                  ShimmerBox(
                    width: 160.w,
                    height: 14.h,
                    borderRadius: 4.r,
                  ),
                  SizedBox(height: 4.h),
                  ShimmerBox(
                    width: 100.w,
                    height: 14.h,
                    borderRadius: 4.r,
                  ),
                ],
              ),
            ),
            ShimmerBox(
              width: 40.w,
              height: 18.h,
              borderRadius: 4.r,
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // Price shimmer
        ShimmerBox(
          width: 140.w,
          height: 18.h,
          borderRadius: 4.r,
        ),
      ],
    );
  }
}

EnregistrementModel _logementToEnregistrement(Logement logement) {
  return EnregistrementModel(
    id: logement.id,
    title: logement.title,
    ownerName: "Nom du proprio",
    details: "nbre de chambre  -  nbre de lit",
    price: logement.priceText,
    rating: logement.rating,
    images: [
      logement.imagePath,
      'assets/images/client/imagesSplash/1.jpg',
      'assets/images/client/imagesSplash/2.jpg',
      'assets/images/client/imagesSplash/3.jpg',
    ],
  );
}
