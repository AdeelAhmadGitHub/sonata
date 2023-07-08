// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as Http;
// import '../api/api_checker.dart';
// import '../api/api_client.dart';
// import '../utils/app_constants.dart';
// import '../utils/functions.dart';
// import 'auth_controller.dart';
//
// class ExploreController extends GetxController {
//   RxBool loading = false.obs;
//   ApiClient api = ApiClient(appBaseUrl: baseUrl);
//   ApiChecker apichecker = ApiChecker();
//   var auth = Get.find<AuthController>();
//   DateTime selectedDate = DateTime.now();
//   int selectedD = 0;
//   String? date;
//   bool selected = true;
//
//   @override
//   Future<void> onInit() async {
//     // api.updateHeader(tokenMain ?? "");
//
//     super.onInit();
//   }
//
//   Future<dynamic> bookAppointment(BuildContext context) async {
//     Response response = await api.postData(
//         ":/api/explore",
//         {
//           'user_id': auth.user?.userId,
//         },
//         showdialog: true);
//     if (response == null) {
//       errorAlert('Check your internet connection.');
//     } else if (response.statusCode == 200) {
//       var json = response.body;
//     } else {
//       errorAlert('Something went wrong\nPlease try again!');
//     }
//     update();
//   }
// }
