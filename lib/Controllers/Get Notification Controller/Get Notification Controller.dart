import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;
import 'package:sonata/Models/HomeModel/HomeModel.dart';
import 'package:sonata/Models/LatestNoteModel/latest-notes-model.dart';
import 'package:web_socket_channel/io.dart';

import '../../Models/GetNotificationModel/GetNotiicationModel.dart';
import '../../Models/ViewNotesModel/ViewNotesModel.dart';
import '../../Views/View Notes/View Notes.dart';
import '../../api/api_checker.dart';
import '../../api/api_client.dart';
import '../../utils/functions.dart';
import '../auth_controller.dart';
import 'dart:convert';

class getNotificationController extends GetxController {
  late SharedPreferences prefs;
  String? token;
  var auth = Get.find<AuthController>();
  RxList<LatestNotesModel> latestnote = <LatestNotesModel>[].obs;
  dynamic noteId;
  String? notificationId;
  bool isRefresh = true;
  ViewNotesModel? viewNotesModel;
  RxList<GetNotificationModel> getNoti = <GetNotificationModel>[].obs;
  bool isLoading = false;
  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    await notifications();
  }

  Future<void> notifications() async {
    final channel = IOWebSocketChannel.connect(
        'ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "notifications",
      "user_handle": auth.user?.userHandle ?? "",
      'token': auth.user?.token ?? "",
      "timezone": "Asia/Karachi",
    };
    channel.sink.add(jsonEncode(appUsername));
    showLoader();
    // Listen to incoming messages
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
          getNoti = <GetNotificationModel>[].obs;
          json['data'].forEach((v) {
            getNoti.add(GetNotificationModel.fromJson(v));
          });
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
        channel.sink.close();
      }
    });
  }


  Future<void> viewNotes() async {
    final channel = IOWebSocketChannel.connect(
        'ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "view_note",
      "note_id": noteId,
      "user_handle": auth.user?.userHandle ?? "",
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
          print(json);
          print("jfcienclijefcoielwf");
          viewNotesModel = ViewNotesModel.fromJson(json);
          // json.forEach((v) {
          //   home.add(HomeModel.fromJson(v));
          // });
          Get.to(ViewNotes(
            viewNotesModel: viewNotesModel!,
          ));
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
        channel.sink.close();
      }
    });
  }

  Future<void> viewNotification() async {
    final channel = IOWebSocketChannel.connect(
        'ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "notification_view",
      "user_handle": auth.user?.userHandle,
      "notification_id": notificationId,
      "token": auth.user?.token
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
        } else {
          // Handle other status cases if needed
        }
      } catch (e) {
        // Handle parsing errors or unexpected message format
        print('Error parsing message: $e');
      }

      finally {
        hideLoader();
        // Close the WebSocket connection when done
      //  channel.sink.close();
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