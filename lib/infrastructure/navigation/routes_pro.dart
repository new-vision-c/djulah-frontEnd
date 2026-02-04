import 'package:get/get.dart';
import 'route_names.dart';
import '../../presentation/pro/test/test.screen.dart';
import 'bindings/controllers/pro.test.controller.binding.dart';
class RoutesPro {
  static List<GetPage> get pages => <GetPage>[
        GetPage(
          name: RouteNames.proTest,
          page: () => const TestScreen(),
          binding: ProTestControllerBinding(),
        ),
  ];
}

