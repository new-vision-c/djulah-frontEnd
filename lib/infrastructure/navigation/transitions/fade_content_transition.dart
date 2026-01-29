import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FadeContentTransition extends CustomTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Curve? curve,
    Alignment? alignment,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // Animation de fade pour la page sortante
    final fadeOutAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: secondaryAnimation,
        curve: curve ?? Curves.easeInOut,
      ),
    );

    // Animation de fade pour la page entrante
    final fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: curve ?? Curves.easeInOut,
      ),
    );

    // Animation de translation légère pour le contenu sortant (vers le haut)
    final slideOutAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.05), // Léger mouvement vers le haut
    ).animate(
      CurvedAnimation(
        parent: secondaryAnimation,
        curve: curve ?? Curves.easeInOut,
      ),
    );

    // Animation de translation légère pour le contenu entrant (depuis le bas)
    final slideInAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.05), // Commence légèrement en bas
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: curve ?? Curves.easeInOut,
      ),
    );

    // Si c'est la page entrante
    if (animation.status != AnimationStatus.dismissed) {
      return FadeTransition(
        opacity: fadeInAnimation,
        child: SlideTransition(
          position: slideInAnimation,
          child: child,
        ),
      );
    }

    // Si c'est la page sortante
    return FadeTransition(
      opacity: fadeOutAnimation,
      child: SlideTransition(
        position: slideOutAnimation,
        child: child,
      ),
    );
  }
}
