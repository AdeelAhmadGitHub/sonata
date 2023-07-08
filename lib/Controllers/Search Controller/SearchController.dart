import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonata/Models/LatestNoteModel/latest-notes-model.dart';
import 'package:web_socket_channel/io.dart';

import '../../Models/SearchModel/SearchModel.dart';
import '../../Models/userUsingSonataModel/userUsingSonataModel.dart';
import '../../api/api_checker.dart';
import '../../api/api_client.dart';
import '../../utils/functions.dart';
import '../auth_controller.dart';
import 'dart:convert';

class SearchingController extends GetxController {
  late SharedPreferences prefs;
  String? token;
  TextEditingController search = TextEditingController(text: "");

  var auth = Get.find<AuthController>();
  RxList<LatestNotesModel> latestnote = <LatestNotesModel>[].obs;
  RxList<SearchModel> searchModel = <SearchModel>[].obs;
  String? followHandle;
  bool isRefresh = true;
  var isSearchingVisible = false.obs;
  var searchQuery = ''.obs;
  bool isLoading = false;
  void onQueryChanged(String text) {
    searchQuery.value = text;
  }

  void showSearch() {
    isSearchingVisible.value = true;
  }

  void hideSearch() {
    isSearchingVisible.value = false;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    // await latestNotes();
  }

  Future<void> latestNotes() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "latest_notes",
      "user_handle": auth.user?.userHandle ?? "",
      "page": "1",
      'token': auth.user?.token ?? ""
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
          latestnote = <LatestNotesModel>[].obs;
          json['data'].forEach((v) {
            latestnote.add(LatestNotesModel.fromJson(v));
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
       // channel.sink.close();
      }
    });
  }

  Future<void> searchUser(String searchName) async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "search_user", "user_name": searchName
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
          searchModel = <SearchModel>[].obs;
          json['data'].forEach((v) {
            searchModel.add(SearchModel.fromJson(v));
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
