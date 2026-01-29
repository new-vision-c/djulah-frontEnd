// import 'package:get/get_connect/http/src/status/http_status.dart';
//
// import '../../infrastructure/network/dio_client.dart';
// import '../user_model.dart';
//
// class UserProvider{
//   DioClient dioClient;
//
//   UserProvider(this.dioClient);
//
//   Future<User?> createAccount(String phone, String name, String password) async {
//     final response = await dioClient.dio.post('/api/auth/signup', data: {'phone': phone, 'name': name, 'password': password});
//     if(response.statusCode == HttpStatus.ok){
//       return User.fromJson(response.data);
//     }else{
//
//     }
//   }
// }
