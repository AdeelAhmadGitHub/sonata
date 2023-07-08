import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/api_checker.dart';
import '../../api/api_client.dart';

class PieChartController extends GetxController {
  late SharedPreferences prefs;
  String? token;

  ApiClient api = ApiClient(appBaseUrl: baseUrl);
  ApiChecker apichecker = ApiChecker();
  var isEmojiVisible = false.obs;
  var isTextFieldEmpty = true.obs;
  FocusNode focusNode = FocusNode();
  RxDouble progressValue = 0.0.obs;
  RxDouble progressValueReply = 0.0.obs;
  RxDouble progressValueThread = 0.0.obs;
  RxDouble progressValueTagline = 0.0.obs;
  RxDouble progressValueDes = 0.0.obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isEmojiVisible.value = false;
      }
    });
    prefs = await SharedPreferences.getInstance();
  }

  void checkTextFieldEmpty(String text) {
    isTextFieldEmpty.value = text.isEmpty;
  }

  void updateProgressValue(String text) {
    progressValue.value = text.length / 450;
  }

  void updateProgressValueReply(String text) {
    progressValueReply.value = text.length / 440;
  }

  void updateProgressValueThread(String text) {
    progressValueThread.value = text.length / 440;
  }

  void updateProgressTagline(String text) {
    progressValueTagline.value = text.length / 100;
  }

  void updateProgressDesp(String text) {
    progressValueDes.value = text.length / 200;
  }

  @override
  void onReady() {
    super.onReady();
  }
}
