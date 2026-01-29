import 'dart:math';
import 'dart:ui' as ui;

import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class POI {
  final String name;
  final String category;
  final LatLng position;
  final IconData icon;
  final Color color;

  const POI({
    required this.name,
    required this.category,
    required this.position,
    required this.icon,
    required this.color,
  });
}

/// Modèle pour les marqueurs de propriétés/logements
class PropertyLocation {
  final String id;
  final String title;
  final String price;
  final double latitude;
  final double longitude;
  final Color? markerColor;

  const PropertyLocation({
    required this.id,
    required this.title,
    required this.price,
    required this.latitude,
    required this.longitude,
    this.markerColor,
  });

  LatLng get position => LatLng(latitude, longitude);
}

class MapWidgetController extends GetxController with GetTickerProviderStateMixin {
  final double latitude;
  final double longitude;
  final List<PropertyLocation> propertyLocations;
  final MapController mapController = MapController();
  final RxList<POI> pois = <POI>[].obs;
  final Rx<String?> selectedPropertyId = Rx<String?>(null);
  
  late AnimationController pulseController;
  late Animation<double> pulseAnimation;
  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  MapWidgetController({
    required this.latitude,
    required this.longitude,
    this.propertyLocations = const [],
  });

  @override
  void onInit() {
    super.onInit();
    _initAnimation();
    if (propertyLocations.isEmpty) {
      _generatePOIs();
    }
  }
  
  void _initAnimation() {
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeOut),
    );
    
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.easeInOut),
    );
  }

  void _generatePOIs() {
    final random = Random();
    final categories = [
      {'name': 'Restaurant', 'icon': Icons.restaurant, 'color': Colors.orange},
      {'name': 'Café', 'icon': Icons.local_cafe, 'color': Colors.brown},
      {'name': 'Supermarché', 'icon': Icons.shopping_cart, 'color': Colors.green},
      {'name': 'Pharmacie', 'icon': Icons.local_pharmacy, 'color': Colors.red},
      {'name': 'Banque', 'icon': Icons.account_balance, 'color': Colors.blue},
      {'name': 'Station essence', 'icon': Icons.local_gas_station, 'color': Colors.purple},
      {'name': 'Hôpital', 'icon': Icons.local_hospital, 'color': Colors.pink},
      {'name': 'École', 'icon': Icons.school, 'color': Colors.indigo},
      {'name': 'Parc', 'icon': Icons.park, 'color': Colors.teal},
      {'name': 'Hôtel', 'icon': Icons.hotel, 'color': Colors.amber},
    ];

    // Générer 8-12 POIs aléatoires autour du point central
    final poiCount = 8 + random.nextInt(5);
    final generatedPois = <POI>[];

    for (int i = 0; i < poiCount; i++) {
      final category = categories[random.nextInt(categories.length)];
      // Offset aléatoire entre 0.001 et 0.005 degrés (environ 100m à 500m)
      final latOffset = (random.nextDouble() - 0.5) * 0.008;
      final lngOffset = (random.nextDouble() - 0.5) * 0.008;

      generatedPois.add(POI(
        name: '${category['name']} ${i + 1}',
        category: category['name'] as String,
        position: LatLng(latitude + latOffset, longitude + lngOffset),
        icon: category['icon'] as IconData,
        color: category['color'] as Color,
      ));
    }

    pois.value = generatedPois;
  }

  void openFullscreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenMapPage(
          latitude: latitude,
          longitude: longitude,
        ),
      ),
    );
  }

  void recenterMap() {
    mapController.move(
      LatLng(latitude, longitude),
      16,
    );
  }

  @override
  void onClose() {
    pulseController.dispose();
    scaleController.dispose();
    mapController.dispose();
    super.onClose();
  }
}

class MapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double height;
  final Color markerColor;
  final Color overlayColor;
  final double overlayOpacity;
  final List<LatLng>? routePoints;
  final List<PropertyLocation> propertyLocations;
  final bool showFullscreenButton;
  final bool showPOIs;
  final double? initialZoom;
  final Function(PropertyLocation)? onPropertyTap;

  const MapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 468,
    this.markerColor = Colors.black,
    this.overlayColor = Colors.white,
    this.overlayOpacity = 0.15,
    this.routePoints,
    this.propertyLocations = const [],
    this.showFullscreenButton = true,
    this.showPOIs = true,
    this.initialZoom,
    this.onPropertyTap,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late MapWidgetController _controller;

  @override
  void initState() {
    super.initState();
    
    // Entrance animation controller
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // Fade animation
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    // Scale animation (subtle zoom effect)
    _scaleAnimation = Tween<double>(begin: 1.05, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    
    _controller = Get.put(
      MapWidgetController(
        latitude: widget.latitude,
        longitude: widget.longitude,
        propertyLocations: widget.propertyLocations,
      ),
      tag: 'map_${widget.latitude}_${widget.longitude}_${widget.propertyLocations.length}',
    );
    
    // Start entrance animation after a brief delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: widget.height == double.infinity ? double.infinity : widget.height.h,
        width: double.infinity,
        color: const Color(0xFFF5F5F5),
        child: AnimatedBuilder(
          animation: _entranceController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Stack(
            children: [
              FlutterMap(
                mapController: _controller.mapController,
                options: MapOptions(
                  initialCenter: LatLng(widget.latitude, widget.longitude),
                  initialZoom: widget.initialZoom ?? (widget.propertyLocations.isNotEmpty ? 14.0 : 16.5),
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}{r}.png?api_key=3a80b064-ed46-458e-9d9c-15f3f7802048",
                    userAgentPackageName: 'com.djulah.app',
                    tileProvider: NetworkTileProvider(),
                  ),
                  // Overlay des routes colorées avec primaryColor
                  TileLayer(
                    urlTemplate:
                        "https://tiles.stadiamaps.com/tiles/stamen_toner_lines/{z}/{x}/{y}{r}.png?api_key=3a80b064-ed46-458e-9d9c-15f3f7802048",
                    userAgentPackageName: 'com.djulah.app',
                    tileProvider: NetworkTileProvider(),
                    tileBuilder: (context, tileWidget, tile) {
                      return ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          ClientTheme.primaryColor.withOpacity(0.3),
                          BlendMode.srcIn,
                        ),
                        child: tileWidget,
                      );
                    },
                  ),
                  // Routes avec couleur primaryColor
                  if (widget.routePoints != null && widget.routePoints!.isNotEmpty)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: widget.routePoints!,
                          strokeWidth: 5.0,
                          color: ClientTheme.primaryColor,
                          borderStrokeWidth: 2.0,
                          borderColor: ClientTheme.primaryColor.withOpacity(0.5),
                        ),
                      ],
                    ),
                  // Property Markers (logements)
                  if (widget.propertyLocations.isNotEmpty)
                    Obx(() => MarkerLayer(
                      markers: widget.propertyLocations.map((property) => Marker(
                        point: property.position,
                        width: 80.r,
                        height: 80.r,
                        child: GestureDetector(
                          onTap: () {
                            _controller.selectedPropertyId.value = property.id;
                            if (widget.onPropertyTap != null) {
                              widget.onPropertyTap!(property);
                            }
                          },
                          child: _PropertyMarkerWidget(
                            property: property,
                            isSelected: _controller.selectedPropertyId.value == property.id,
                          ),
                        ),
                      )).toList(),
                    )),
                  // POI Markers (only if no property locations and showPOIs is true)
                  if (widget.propertyLocations.isEmpty && widget.showPOIs)
                    Obx(() => MarkerLayer(
                      markers: _controller.pois.map((poi) => Marker(
                        point: poi.position,
                        width: 32.r,
                        height: 32.r,
                        child: GestureDetector(
                          onTap: () => _showPOIInfo(context, poi),
                          child: Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: poi.color.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                              border: Border.all(
                                color: poi.color,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              poi.icon,
                              size: 14.r,
                              color: poi.color,
                            ),
                          ),
                        ),
                      )).toList(),
                    )),
                  // Marqueur principal avec animation ping - seulement si pas de propriétés
                  if (widget.propertyLocations.isEmpty)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(widget.latitude, widget.longitude),
                          width: 80.r,
                          height: 80.r,
                          child: _buildAnimatedMarker(),
                        ),
                      ],
                    ),
                ],
              ),
              
              IgnorePointer(
                child: Container(
                  color: widget.overlayColor.withOpacity(widget.overlayOpacity),
                ),
              ),

              if (widget.showFullscreenButton)
                Positioned(
                  top: 16.r,
                  right: 16.r,
                  child: _FullscreenButton(
                    onTap: () => _controller.openFullscreen(context),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedMarker() {
    return AnimatedBuilder(
      animation: _controller.pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Cercles de pulsation
            ...List.generate(2, (index) {
              final delay = index * 0.5;
              final animValue = ((_controller.pulseAnimation.value + delay) % 1.0);
              return Container(
                width: (44.r + (animValue * 36.r)),
                height: (44.r + (animValue * 36.r)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(
                    (1.0 - animValue) * 0.4,
                  ),
                ),
              );
            }),
            // Marqueur central avec animation scale
            ScaleTransition(
              scale: _controller.scaleAnimation,
              child: Container(
                width: 32.r,
                height: 32.r,
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: widget.markerColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  "assets/images/client/BottomNavImages/house.svg",
                  width: 20.r,
                  height: 20.r,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPOIInfo(BuildContext context, POI poi) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(poi.icon, color: Colors.white, size: 20.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    poi.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    poi.category,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: poi.color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(16.r),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _FullscreenButton extends StatelessWidget {
  final VoidCallback onTap;
  const _FullscreenButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
          ],
        ),
        child: Icon(Icons.fullscreen, color: Colors.blue, size: 24.r),
      ),
    );
  }
}

class FullscreenMapPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  final List<PropertyLocation> propertyLocations;

  const FullscreenMapPage({
    super.key,
    required this.latitude,
    required this.longitude,
    this.propertyLocations = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MapWidget(
            latitude: latitude,
            longitude: longitude,
            height: double.infinity,
            markerColor: Colors.black,
            overlayOpacity: 0.2,
            propertyLocations: propertyLocations,
            showFullscreenButton: false,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                style: IconButton.styleFrom(backgroundColor: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget pour afficher un marqueur de propriété avec animation (même style que le marqueur principal)
class _PropertyMarkerWidget extends StatefulWidget {
  final PropertyLocation property;
  final bool isSelected;

  const _PropertyMarkerWidget({
    required this.property,
    this.isSelected = false,
  });

  @override
  State<_PropertyMarkerWidget> createState() => _PropertyMarkerWidgetState();
}

class _PropertyMarkerWidgetState extends State<_PropertyMarkerWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Color _getMarkerColor(String id) {
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.property.markerColor ?? _getMarkerColor(widget.property.id);
    final markerColor = widget.isSelected ? ClientTheme.primaryColor : color;

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Cercles de pulsation
            ...List.generate(2, (index) {
              final delay = index * 0.5;
              final animValue = ((_pulseAnimation.value + delay) % 1.0);
              return Container(
                width: (32.r + (animValue * 24.r)),
                height: (32.r + (animValue * 24.r)),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: markerColor.withOpacity(
                    (1.0 - animValue) * 0.4,
                  ),
                ),
              );
            }),
            // Marqueur central avec animation scale
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 28.r,
                height: 28.r,
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: markerColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  "assets/images/client/BottomNavImages/house.svg",
                  width: 16.r,
                  height: 16.r,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
