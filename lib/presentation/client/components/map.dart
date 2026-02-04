import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:djulah/infrastructure/theme/client_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

enum PropertyType { furnished, unfurnished, commercial }

class PropertyLocation {
  final String id;
  final String title;
  final String price;
  final double latitude;
  final double longitude;
  final Color? markerColor;
  final PropertyType propertyType;

  const PropertyLocation({
    required this.id,
    required this.title,
    required this.price,
    required this.latitude,
    required this.longitude,
    this.markerColor,
    this.propertyType = PropertyType.furnished,
  });

  LatLng get position => LatLng(latitude, longitude);

  Color get defaultColor {
    switch (propertyType) {
      case PropertyType.furnished:
        return const Color(0xFF000000); // Noir
      case PropertyType.unfurnished:
        return const Color(0xFF3B82F6); // Bleu
      case PropertyType.commercial:
        return const Color(0xFFF59E0B); // Orange
    }
  }

  String get iconAsset {
    switch (propertyType) {
      case PropertyType.furnished:
        return "assets/images/client/BottomNavImages/house.svg";
      case PropertyType.unfurnished:
        return "assets/images/client/BottomNavImages/house.svg";
      case PropertyType.commercial:
        return "assets/images/client/hotel.svg";
    }
  }
}

/// Classe pour représenter les limites visibles de la carte
class MapBounds {
  final double north;
  final double south;
  final double east;
  final double west;
  final double zoom;
  final LatLng center;

  const MapBounds({
    required this.north,
    required this.south,
    required this.east,
    required this.west,
    required this.zoom,
    required this.center,
  });
}

/// Style MapTiler personnalisé avec couleur primaire
String _getMapTilerStyleUrl() {
  // Utiliser le style streets-v2 de MapTiler
  return "https://api.maptiler.com/maps/streets-v2/style.json?key=eQ9CXghnN1xTOQyGPAVn";
}

class MapWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double height;
  final Color markerColor;
  final Color overlayColor;
  final double overlayOpacity;
  final List<PropertyLocation> propertyLocations;
  final bool showFullscreenButton;
  final double? initialZoom;
  final Function(PropertyLocation)? onPropertyTap;
  final bool disableMarkerAnimation;
  final double? markerSize;
  /// Callback appelé quand la caméra s'arrête de bouger (zone visible changée)
  final Function(MapBounds)? onCameraIdle;
  /// Afficher le marqueur central (pour la position de recherche)
  final bool showCenterMarker;

  const MapWidget({
    super.key,
    required this.latitude,
    required this.longitude,
    this.height = 468,
    this.markerColor = Colors.black,
    this.overlayColor = Colors.white,
    this.overlayOpacity = 0.15,
    this.propertyLocations = const [],
    this.showFullscreenButton = true,
    this.initialZoom,
    this.onPropertyTap,
    this.disableMarkerAnimation = false,
    this.markerSize,
    this.onCameraIdle,
    this.showCenterMarker = true,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with TickerProviderStateMixin {
  MapLibreMapController? _mapController;
  bool _styleLoaded = false;
  bool _markersAdded = false;
  String? _selectedPropertyId;
  final Map<String, Symbol> _symbols = {};
  
  /// Garde une trace des propriétés actuellement affichées pour détecter les changements
  List<PropertyLocation> _currentPropertyLocations = [];

  // Animation controllers
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    // Entrance animation
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOut,
      ),
    );

    // Pulse animation for main marker
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    // Scale animation for main marker
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Start entrance animation
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _entranceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Détecter si les propriétés ont changé
    if (_styleLoaded && _mapController != null) {
      final newPropertyIds = widget.propertyLocations.map((p) => p.id).toSet();
      final oldPropertyIds = _currentPropertyLocations.map((p) => p.id).toSet();
      
      // Si les IDs sont différents ou si les positions ont changé, mettre à jour les markers
      final hasChanged = !_arePropertyListsEqual(widget.propertyLocations, _currentPropertyLocations);
      
      if (hasChanged) {
        debugPrint('MapWidget: Properties changed, updating markers (${widget.propertyLocations.length} properties)');
        _updatePropertyMarkers();
      }
    }
  }

  /// Compare deux listes de PropertyLocation
  bool _arePropertyListsEqual(List<PropertyLocation> list1, List<PropertyLocation> list2) {
    if (list1.length != list2.length) return false;
    
    final ids1 = list1.map((p) => '${p.id}_${p.latitude}_${p.longitude}').toSet();
    final ids2 = list2.map((p) => '${p.id}_${p.latitude}_${p.longitude}').toSet();
    
    return ids1.difference(ids2).isEmpty && ids2.difference(ids1).isEmpty;
  }

  /// Met à jour les marqueurs de propriétés (supprime les anciens et ajoute les nouveaux)
  Future<void> _updatePropertyMarkers() async {
    if (_mapController == null) return;
    
    try {
      // Supprimer tous les anciens symbols
      for (final symbol in _symbols.values) {
        await _mapController!.removeSymbol(symbol);
      }
      _symbols.clear();
      
      // Ajouter les nouveaux markers
      if (widget.propertyLocations.isNotEmpty) {
        await _addPropertyMarkers();
      }
      
      // Mettre à jour la liste courante
      _currentPropertyLocations = List.from(widget.propertyLocations);
      
      debugPrint('MapWidget: Markers updated successfully');
    } catch (e) {
      debugPrint('MapWidget: Error updating markers: $e');
    }
  }

  void _onMapCreated(MapLibreMapController controller) {
    _mapController = controller;
    
    controller.onSymbolTapped.add(_onSymbolTapped);
  }

  /// Appelé quand la caméra s'arrête de bouger
  Future<void> _onCameraIdle() async {
    if (_mapController == null || widget.onCameraIdle == null) return;
    
    try {
      final bounds = await _mapController!.getVisibleRegion();
      final cameraPosition = _mapController!.cameraPosition;
      
      final mapBounds = MapBounds(
        north: bounds.northeast.latitude,
        south: bounds.southwest.latitude,
        east: bounds.northeast.longitude,
        west: bounds.southwest.longitude,
        zoom: cameraPosition?.zoom ?? 15.0,
        center: cameraPosition?.target ?? LatLng(widget.latitude, widget.longitude),
      );
      
      widget.onCameraIdle!(mapBounds);
    } catch (e) {
      debugPrint('Error getting visible region: $e');
    }
  }

  void _onSymbolTapped(Symbol symbol) {
    final propertyId = symbol.data?['id'] as String?;
    if (propertyId != null) {
      setState(() {
        _selectedPropertyId = propertyId;
      });
      
      final property = widget.propertyLocations.firstWhere(
        (p) => p.id == propertyId,
        orElse: () => widget.propertyLocations.first,
      );
      
      if (widget.onPropertyTap != null) {
        widget.onPropertyTap!(property);
      }
    }
  }

  Future<void> _onStyleLoaded() async {
    setState(() {
      _styleLoaded = true;
    });
    
    // Personnaliser les couleurs des routes avec la couleur primaire
    await _customizeMapStyle();
    
    // Ajouter les marqueurs de propriétés
    if (widget.propertyLocations.isNotEmpty) {
      await _addPropertyMarkers();
      _currentPropertyLocations = List.from(widget.propertyLocations);
    } else if (widget.showCenterMarker) {
      // Ajouter le marqueur central comme Symbol MapLibre (suit la carte)
      await _addCenterMarker();
    }
    
    setState(() {
      _markersAdded = true;
    });
    
    // Notifier la zone visible initiale
    _onCameraIdle();
  }

  /// Ajoute le marqueur central comme un Symbol MapLibre
  Future<void> _addCenterMarker() async {
    if (_mapController == null) return;
    
    // Créer l'image du marqueur central (grande taille pour bonne visibilité)
    final markerImage = await _createCenterMarkerImage();
    
    await _mapController!.addImage('center_marker', markerImage);
    
    await _mapController!.addSymbol(
      SymbolOptions(
        geometry: LatLng(widget.latitude, widget.longitude),
        iconImage: 'center_marker',
        iconSize: 1.0, // Taille normale, l'image est déjà grande
        iconAnchor: 'center',
      ),
    );
  }

  /// Crée l'image du marqueur central avec le style primaire - GRANDE TAILLE
  Future<Uint8List> _createCenterMarkerImage() async {
    // Taille beaucoup plus grande pour une bonne visibilité
    final size = 120; // 120 pixels pour une bonne visibilité
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    final primaryColor = ClientTheme.primaryColor;
    
    // Ombre portée
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    
    // Fond blanc
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    // Bordure couleur primaire (plus épaisse)
    final borderPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    
    // Cercle intérieur couleur primaire
    final innerPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill;
    
    final center = Offset(size / 2, size / 2);
    final radius = size / 2 - 12;
    
    canvas.drawCircle(center + const Offset(0, 4), radius, shadowPaint);
    
    canvas.drawCircle(center, radius, bgPaint);
    
    canvas.drawCircle(center, radius - 3, borderPaint);
    
    canvas.drawCircle(center, radius * 0.45, innerPaint);
    
    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return byteData!.buffer.asUint8List();
  }

  Future<void> _customizeMapStyle() async {
    if (_mapController == null) return;
    
    try {
      final primaryColorHex = '#${ClientTheme.primaryColor.value.toRadixString(16).substring(2)}';
      final primaryLightHex = '#${ClientTheme.primaryColor.withOpacity(0.3).value.toRadixString(16).substring(2)}';
      
      await _mapController!.setLayerProperties(
        'road_primary',
        LineLayerProperties(lineColor: primaryColorHex, lineOpacity: 0.8),
      );
      
      await _mapController!.setLayerProperties(
        'road_secondary',
        LineLayerProperties(lineColor: primaryColorHex, lineOpacity: 0.6),
      );
      
      await _mapController!.setLayerProperties(
        'road_trunk',
        LineLayerProperties(lineColor: primaryColorHex, lineOpacity: 0.9),
      );
    } catch (e) {
      debugPrint('Style customization info: $e');
    }
  }

  Future<void> _addPropertyMarkers() async {
    if (_mapController == null) return;
    
    debugPrint('MapWidget: Adding ${widget.propertyLocations.length} property markers');
    
    for (final property in widget.propertyLocations) {
      final color = property.markerColor ?? property.defaultColor;
      
      final markerImage = await _createMarkerImage(color, property.propertyType);
      
      final imageName = 'marker_${property.id}_${property.latitude.hashCode}';
      
      try {
        await _mapController!.addImage(imageName, markerImage);
        
        final symbol = await _mapController!.addSymbol(
          SymbolOptions(
            geometry: property.position,
            iconImage: imageName,
            iconSize: 1.0,
            iconAnchor: 'center',
          ),
          {'id': property.id},
        );
        
        _symbols[property.id] = symbol;
      } catch (e) {
        debugPrint('MapWidget: Error adding marker for ${property.id}: $e');
      }
    }
    
    debugPrint('MapWidget: Property markers added successfully');
  }

  Future<Uint8List> _createMarkerImage(Color color, PropertyType type) async {
    final size = 80;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.25)
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    
    final center = Offset(size / 2, size / 2);
    final radius = size / 2 - 8;
    
    // Ombre
    canvas.drawCircle(center + const Offset(0, 3), radius, shadowPaint);
    
    // Cercle blanc de fond
    canvas.drawCircle(center, radius, bgPaint);
    
    // Bordure colorée
    canvas.drawCircle(center, radius - 2, borderPaint);
    
    // Dessiner l'icône selon le type de logement
    final iconPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final iconSize = radius * 0.7;
    final iconCenter = center;
    
    switch (type) {
      case PropertyType.furnished:
        // Maison meublée : icône maison avec un intérieur plein
        _drawHouseIcon(canvas, iconCenter, iconSize, iconPaint);
        break;
      case PropertyType.unfurnished:
        // Non meublé : icône maison avec contour uniquement
        _drawHouseOutlineIcon(canvas, iconCenter, iconSize, iconPaint);
        break;
      case PropertyType.commercial:
        // Commercial : icône immeuble/hotel
        _drawBuildingIcon(canvas, iconCenter, iconSize, iconPaint);
        break;
    }
    
    final picture = recorder.endRecording();
    final image = await picture.toImage(size, size);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    return byteData!.buffer.asUint8List();
  }

  /// Dessine une icône de maison pleine (meublé)
  void _drawHouseIcon(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final halfSize = size / 2;
    
    // Toit (triangle)
    path.moveTo(center.dx, center.dy - halfSize * 0.9);
    path.lineTo(center.dx - halfSize * 0.8, center.dy - halfSize * 0.1);
    path.lineTo(center.dx + halfSize * 0.8, center.dy - halfSize * 0.1);
    path.close();
    
    // Corps de la maison (rectangle)
    path.addRect(Rect.fromCenter(
      center: Offset(center.dx, center.dy + halfSize * 0.35),
      width: size * 0.6,
      height: size * 0.5,
    ));
    
    canvas.drawPath(path, paint);
  }

  /// Dessine une icône de maison en contour (non meublé)
  void _drawHouseOutlineIcon(Canvas canvas, Offset center, double size, Paint paint) {
    final strokePaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    
    final path = Path();
    final halfSize = size / 2;
    
    // Toit (triangle)
    path.moveTo(center.dx, center.dy - halfSize * 0.9);
    path.lineTo(center.dx - halfSize * 0.8, center.dy - halfSize * 0.1);
    path.lineTo(center.dx + halfSize * 0.8, center.dy - halfSize * 0.1);
    path.close();
    
    // Corps de la maison (rectangle)
    path.addRect(Rect.fromCenter(
      center: Offset(center.dx, center.dy + halfSize * 0.35),
      width: size * 0.6,
      height: size * 0.5,
    ));
    
    canvas.drawPath(path, strokePaint);
  }

  /// Dessine une icône d'immeuble (commercial)
  void _drawBuildingIcon(Canvas canvas, Offset center, double size, Paint paint) {
    final halfSize = size / 2;
    
    // Bâtiment principal (rectangle)
    final buildingRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + halfSize * 0.1),
      width: size * 0.65,
      height: size * 0.9,
    );
    canvas.drawRect(buildingRect, paint);
    
    // Fenêtres (petits carrés blancs)
    final windowPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    
    final windowSize = size * 0.12;
    final windowSpacingX = size * 0.2;
    final windowSpacingY = size * 0.22;
    
    // 2 colonnes x 3 rangées de fenêtres
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 2; col++) {
        final windowX = center.dx - windowSpacingX / 2 + col * windowSpacingX;
        final windowY = center.dy - halfSize * 0.35 + row * windowSpacingY;
        
        canvas.drawRect(
          Rect.fromCenter(
            center: Offset(windowX, windowY),
            width: windowSize,
            height: windowSize,
          ),
          windowPaint,
        );
      }
    }
  }

  void _openFullscreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullscreenMapPage(
          latitude: widget.latitude,
          longitude: widget.longitude,
          propertyLocations: widget.propertyLocations,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: widget.height == double.infinity
            ? double.infinity
            : widget.height.h,
        width: double.infinity,
        color: ClientTheme.primaryColor.withOpacity(0.05),
        child: AnimatedBuilder(
          animation: _entranceController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: child,
            );
          },
          child: Stack(
            children: [
              MapLibreMap(
                styleString: _getMapTilerStyleUrl(),
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.latitude, widget.longitude),
                  zoom: widget.initialZoom ??
                      (widget.propertyLocations.isNotEmpty ? 15.0 : 15.5),
                ),
                onMapCreated: _onMapCreated,
                onStyleLoadedCallback: _onStyleLoaded,
                onCameraIdle: _onCameraIdle,
                rotateGesturesEnabled: true,
                tiltGesturesEnabled: true,
                scrollGesturesEnabled: true,
                zoomGesturesEnabled: true,
                compassEnabled: false,
                attributionButtonPosition: AttributionButtonPosition.bottomLeft,
                attributionButtonMargins: const Point(-100, -100),
                logoViewMargins: const Point(-100, -100),
              ),

              if (widget.showFullscreenButton)
                Positioned(
                  top: 16.r,
                  right: 16.r,
                  child: _FullscreenButton(onTap: _openFullscreen),
                ),
            ],
          ),
        ),
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
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: ClientTheme.primaryColor.withOpacity(0.1),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: ClientTheme.primaryColor.withOpacity(0.1),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.fullscreen_rounded,
          color: ClientTheme.primaryColor,
          size: 20.r,
        ),
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
      backgroundColor: ClientTheme.primaryColor.withOpacity(0.05),
      body: Stack(
        children: [
          MapWidget(
            latitude: latitude,
            longitude: longitude,
            height: double.infinity,
            markerColor: Colors.black,
            overlayOpacity: 0.1,
            propertyLocations: propertyLocations,
            showFullscreenButton: false,
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: ClientTheme.primaryColor.withOpacity(0.1),
                        width: 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ClientTheme.primaryColor.withOpacity(0.1),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: ClientTheme.primaryColor,
                      size: 20.r,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
