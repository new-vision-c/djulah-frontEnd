import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../app/config/app_config.dart';
import '../../config.dart';
import 'routes_client.dart';
import 'routes_pro.dart';
import 'routes_shared.dart';

class EnvironmentsBadge extends StatelessWidget {
  final Widget child;
  EnvironmentsBadge({required this.child});
  @override
  Widget build(BuildContext context) {
    var env = ConfigEnvironments.getEnvironments()['env'];
    return env != Environments.PRODUCTION
        ? Banner(
            location: BannerLocation.topStart,
            message: env!,
            color: env == Environments.QAS ? Colors.blue : Colors.purple,
            child: child,
          )
        : SizedBox(child: child);
  }
}

class Nav {
  static List<GetPage>? _cachedRoutes;
  
  static List<GetPage> get routes {
    _cachedRoutes ??= <GetPage>[
      ...RoutesShared.pages,
      ...(AppConfig.isClient ? RoutesClient.pages : RoutesPro.pages),
    ];
    return _cachedRoutes!;
  }
}







































