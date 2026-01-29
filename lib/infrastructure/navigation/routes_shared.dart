import 'package:djulah/infrastructure/navigation/route_names.dart';
import 'package:get/get.dart';
import '../../presentation/shared/successPage/success_page.screen.dart';
import 'bindings/controllers/success_page.controller.binding.dart';
class RoutesShared {
  static List<GetPage> get pages => <GetPage>[
        GetPage(
          name: RouteNames.sharedSuccessPage,
          page: () => const SuccessPageScreen(),
          binding: SuccessPageControllerBinding(),
        ),
      ];
}


