import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import '../../Models/userUsingSonataModel/userUsingSonataModel.dart';
import '../../api/api_checker.dart';
import '../../api/api_client.dart';
import '../../utils/functions.dart';
import '../auth_controller.dart';
import 'dart:convert';

class userUsingSonataController extends GetxController {
  late SharedPreferences prefs;
  String? token;
  var auth = Get.find<AuthController>();
  UserUsingSonataModel? userUsingSonataModel;
  JsonSideArray? jsonSideArray;
  // RxList<userUsingSonataModel> userUsing = <userUsingSonataModel>[].obs;
  File? imageFile;
  String errorMessage = "";
  File? noteImage;
  bool isRefresh = true;
  String? text;
  String? followHandle;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    await userUsingSonata();
    await createUserFollow();
  }

  Future<void> userUsingSonata() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "view_side_bar",
      "user_handle": auth.user?.userHandle ?? "",
      "page": "1",
      "timezone": "Asia/Karachi",
    };
    channel.sink.add(jsonEncode(appUsername));

    showLoader();
    channel.stream.listen((response) {
      // Handle incoming messages here
      print('Received: $response');

      try {
        if (response.startsWith('This is server')) {
          // Skip the initial server message
          return;
        }

        final json = jsonDecode(response);
        if (json != null) {

          userUsingSonataModel = UserUsingSonataModel.fromJson(json);

          update();

        } else {
          // Handle other status cases if needed
        }
      } catch (e) {
        // Handle parsing errors or unexpected message format
        print('Error parsing message: $e');
      }

      finally {
        // Hide the loader after receiving the API response
        hideLoader();

        // Close the WebSocket connection when done
       // channel.sink.close();
      }
    });
  }


  Future<void> createUserFollow() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "user_follow_unfollow",
      "user_handle": auth.user?.userHandle ?? "",
      "followed_handle": followHandle ?? "",
      "token": auth.user?.token ?? ""
    };
    channel.sink.add(jsonEncode(appUsername));

    showLoader();
    channel.stream.listen((response) {
      // Handle incoming messages here
      print('Received: $response');

      try {
        if (response.startsWith('This is server')) {
          // Skip the initial server message
          return;
        }

        final json = jsonDecode(response);
        if (json != null) {
          update();

          if (userUsingSonataModel?.jsonSideArray != null) {
            final index = userUsingSonataModel!.jsonSideArray!
                .indexWhere((element) => element.userHandle == followHandle);
            if (index != -1) {
              userUsingSonataModel!.jsonSideArray![index].isFollowing = true;
            }
          }

        } else {
          // Handle other status cases if needed
        }
      } catch (e) {
        // Handle parsing errors or unexpected message format
        print('Error parsing message: $e');
      }
      finally {
        // Hide the loader after receiving the API response
        hideLoader();

        // Close the WebSocket connection when done
       // channel.sink.close();
      }
    });
  }


  void showLoader() {
    // Check if the loader is already shown
    if (isLoading) {
      return;
    }

    isLoading = true;

    Get.dialog(
      Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Center(
          child: AnimatedCircleAnimation(),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void hideLoader() {
    // Check if the loader is currently shown
    if (!isLoading) {
      return;
    }

    isLoading = false;

    Get.back();
  }
}
