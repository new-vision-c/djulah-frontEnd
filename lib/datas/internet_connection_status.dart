// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:get/get.dart';
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
//
// import '../constants/constants.dart';
// import '../utils/GlobalVar.dart';
//
// class ConnectionController extends GetxController {
//   final internetConnectionChecker = InternetConnection.createInstance(
//     checkInterval: const Duration(seconds: 60),
//     useDefaultOptions: false,
//     customCheckOptions: [
//       InternetCheckOption(
//         timeout: const Duration(seconds: 10),
//         uri: Uri.parse("${Assets.dev_server_url}"),
//         responseStatusFn: (response) {
//           print("response to internet connection ${response.statusCode}");
//           return response.statusCode >= 200 && response.statusCode < 500;
//         },
//       ),
//     ],
//   );
//
//   final RxBool isConnected = true.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     internetConnectionChecker.onStatusChange.listen((InternetStatus status) async {
//       final bool hasConnection = await internetConnectionChecker.hasInternetAccess;
//       isConnected.value = hasConnection;
//     });
//
//     ever(isConnected, (bool connected) {
//       GlobalVariables.isConnectedToInternet.value = connected;
//       if (!connected) {
//         EasyLoading.dismiss();
//       }
//     });
//   }
//
//   Future<RxBool> hasInternetAccess() async {
//     final result = await internetConnectionChecker.hasInternetAccess;
//     isConnected.value = result;
//     return result.obs;
//   }
// }
