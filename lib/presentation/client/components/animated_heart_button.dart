import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../datas/local_storage/favorites_storage_service.dart';
import '../../../domain/entities/logement.dart';

/// Bouton cœur animé pour les favoris
/// Affiche une animation de battement de cœur lors de l'ajout aux favoris
class AnimatedHeartButton extends StatefulWidget {
  final String propertyId;
  final Propriete? logement;
  final double size;
  
  const AnimatedHeartButton({
    super.key,
    required this.propertyId,
    this.logement,
    this.size = 24,
  });

  @override
  State<AnimatedHeartButton> createState() => _AnimatedHeartButtonState();
}

class _AnimatedHeartButtonState extends State<AnimatedHeartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late FavoritesStorageService _favoritesService;
  bool _wasActive = false;

  @override
  void initState() {
    super.initState();
    _favoritesService = Get.find<FavoritesStorageService>();
    _wasActive = _favoritesService.isFavorite(widget.propertyId);
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 0.9)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.15)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    final currentState = _favoritesService.isFavorite(widget.propertyId);
    
    if (currentState) {
      // Retirer des favoris
      _favoritesService.removeFavorite(widget.propertyId);
    } else {
      // Ajouter aux favoris avec animation
      Propriete? logementToAdd = widget.logement;
      
      // Si pas de logement fourni, chercher dans MockupLogements
      if (logementToAdd == null) {
        logementToAdd = MockupLogements.logements.firstWhereOrNull(
          (l) => l.id == widget.propertyId
        );
      }
      
      // Si on trouve le logement, l'ajouter
      if (logementToAdd != null) {
        _favoritesService.addFavorite(logementToAdd);
        _controller.forward(from: 0);
      } else {
        print('Warning: Could not find logement with ID ${widget.propertyId} to add to favorites');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFavorite,
      behavior: HitTestBehavior.opaque,
      child: Obx(() {
        final isFav = _favoritesService.isFavorite(widget.propertyId);
        
        // Déclencher l'animation si on vient de passer à favori
        if (isFav && !_wasActive) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_controller.isAnimating) {
              _controller.forward(from: 0);
            }
          });
        }
        _wasActive = isFav;
        
        return AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: isFav ? 0.0 : 1.0,
                  end: isFav ? 1.0 : 0.0,
                ),
                duration: const Duration(milliseconds: 200),
                builder: (context, value, child) {
                  return isFav
                      ? Image.asset(
                          "assets/images/client/heart_fill.png",
                          width: widget.size.r,
                          height: widget.size.r,
                        )
                      : SvgPicture.asset(
                          "assets/images/client/heart_card.svg",
                          width: widget.size.r,
                          height: widget.size.r,
                        );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
