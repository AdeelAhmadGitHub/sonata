import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';

import '../../Models/Explore Model/ExploreModel.dart';
import '../../Models/UserData.dart';
import '../../Models/View Thread Model/ViewThreadModel.dart';
import '../../Views/Thread View/Thread View.dart';
import '../../api/api_checker.dart';
import '../../api/api_client.dart';
import '../auth_controller.dart';

class ExploreController extends GetxController {
  TextEditingController desCont = TextEditingController(text: "");
  TextEditingController locCont = TextEditingController(text: "");
  TextEditingController workCont = TextEditingController(text: "");
  /////////////////////////////////////////////////////////////////
  int lengthExploreList = 0;
  late SharedPreferences prefs;
  var auth = Get.find<AuthController>();
  Rx<ViewThreadModel>? setViewThreadModel;
  Rx<ViewThreadModel>? get viewThreadModel => setViewThreadModel;
  String? token;
  RxList<ExploreModel> explore = <ExploreModel>[].obs;
  UserData? user;
  bool apiHit = true;
  bool isRefreshApi = true;
  ApiClient api = ApiClient(appBaseUrl: baseUrl);

  ApiChecker apichecker = ApiChecker();
  bool isRefresh = true;
  int? threadNoteId;
  int explorePage = 1;
  bool hitApi = true;
  bool isLoading = false;

  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
    // apiHit ? await exploreUser() : null;
  }

  Future<void> exploreUser() async {
    lengthExploreList = 0;
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "explore_feeds",
      "page": "$explorePage",
      "user_handle":"",
      "timezone": "Asia/Karachi"
    };

    channel.sink.add(jsonEncode(appUsername));
    isLoading = true;
    showLoader();
    channel.stream.listen((response) {
      print('Received: $response');

      try {
        if (response.startsWith('This is server')) {
          return;
        }

        final json = jsonDecode(response);
        if (json != null) {
          if (isRefreshApi) {
            explore = <ExploreModel>[].obs;
          }

          json['data'].forEach((v) {
            lengthExploreList++;
            explore.add(ExploreModel.fromJson(v));
          });

          update();
        } else {
        }
      } catch (e) {
        print('Error parsing message: $e');
      } finally {
        isLoading = false;
        hideLoader();
      }
    });

  }



  Future<void> viewThread() async {
    print("/?????????????????$threadNoteId");
    final response = await api.postData(
      "api/view-thread",
      {
        "request_type": "view_thread",
        "user_handle": auth.user?.userHandle ?? "",
        "thread_note_id": threadNoteId,
        "timezone": "Asia/Karachi",
      },
      showdialog: false,
    );
    if (response.statusCode == 200) {
      final json = response.body;
      //print(json[0]);
      setViewThreadModel = ViewThreadModel.fromJson(json).obs;
      print("viewThreadModel?.value.noteTimeAgo");
      print(viewThreadModel?.value.noteTimeAgo);
      // setViewsThread = <ViewThreadModel>[].obs;
      // json.forEach((v) {
      //   viewsThread.add(ViewThreadModel.fromJson(v));
      // });

      Get.to(ThreadView(
        viewCont: viewThreadModel?.value,
      ));
      update();
    }
  }
  void showLoader() {
    if (isLoading) {
      Get.dialog(Dialog(
        elevation: 0,
        // surfaceColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: AnimatedCircleAnimation(),
      ));
    }
  }

  void hideLoader() {
    Get.back();
  }

}
