import 'package:djulah/presentation/client/favoris/favoris.screen.dart';
import 'package:djulah/presentation/client/home/home.screen.dart';
import 'package:djulah/presentation/client/messages/messages.screen.dart';
import 'package:djulah/presentation/client/profil/profil.screen.dart';
import 'package:djulah/presentation/client/reservations/reservations.screen.dart';
import 'package:djulah/presentation/components/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/dashboard.controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Obx(() =>
            IndexedStack(
              index: controller.currentIndex.value,
              children: [
                _lazyTab(0, const HomeScreen()),
                _lazyTab(1, const ReservationsScreen()),
                _lazyTab(2, const FavorisScreen()),
                _lazyTab(3, const MessagesScreen()),
                _lazyTab(4, const ProfilScreen()),
              ],
            )),
        bottomNavigationBar: BottomNavigation(
          currentIndex: controller.currentIndex,
          onChanged: controller.onChangIndex,
        )
    );
  }
  Widget _lazyTab(int index, Widget child) {
    return Obx(() {
      return controller.openedTabs.contains(index)
          ? child
          : const SizedBox.shrink();
    });
  }
}
