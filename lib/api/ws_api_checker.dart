// import 'dart:convert';
//
// import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/request/request.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import '../utils/functions.dart';
//
// class ApiCheckerWs {
//   Future<Response> checkApi({
//     required dynamic respons,
//     bool showUserError = true,
//     bool showSystemError = true,
//   }) async {
//     Response response = Response(
//       body: respons is String ? jsonDecode(respons) : respons,
//       bodyString: respons.toString(),
//       // Modify other properties as needed
//     );
//     print(response.body);
//     print("status code: ${response.statusCode}");
//     if (response.body == null) {
//       if (showSystemError) {
//         errorAlert('Check your internet connection and try again');
//       }
//     } else if (response.statusCode == 200) {
//       return response;
//     } else if (response.statusCode == 401 || response.statusCode == 403) {
//       // if (showUserError) {
//       //   await AuthController().logoutUser();
//       //   Get.offAll(() => CreateProfile());
//       //   errorAlert(response.body['message']);
//       // }
//     } else if (response.statusCode! >= 500) {
//       if (showSystemError) {
//         errorAlert(
//           'Server Error!\nPlease try again...',
//         );
//       }
//     } else if (response.statusCode! >= 400) {
//       if (showUserError) {
//         errorAlert(response.body.toString());
//       }
//     }
//     return Response(
//       statusCode: response.statusCode,
//       statusText: response.body,
//     );
//   }
//
// }
//
