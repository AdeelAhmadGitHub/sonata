import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonata/api/ws_api_client.dart' show ApiClientWs, Response;
import '../../Models/Explore Model/ExploreModel.dart';
import '../../Models/HomeModel/HomeModel.dart';
import '../../Models/HomeTreadModel/HomeTreadModel.dart';
import '../../Models/ProfileModel/UserChannelsModel.dart';
import '../../Models/ProfileModel/UserMediaModel.dart';
import '../../Models/ProfileModel/UserMoreModel.dart';
import '../../Models/ProfileModel/UserNotesModel.dart';
import '../../Models/ProfileModel/UserRenotesModel.dart';
import '../../Models/ThreadModel.dart';
import '../../Models/UploadImageModel/UploadImageMModel.dart';
import '../../Models/UserData.dart';
import '../../Models/View Thread Model/ViewThreadModel.dart';
import '../../Models/ViewNotesModel/ViewNotesModel.dart';
import '../../Models/getChannel Model.dart';
import '../../Models/threadlenght.dart';
import '../auth_controller.dart';

class HomesController extends GetxController {
  TextEditingController desCont = TextEditingController(text: "");
  TextEditingController locCont = TextEditingController(text: "");
  TextEditingController workCont = TextEditingController(text: "");

  /////////////////////////////////////////////////////////////////
  TextEditingController noteBodyReply = TextEditingController(text: "");
  TextEditingController noteBodyRenote = TextEditingController(text: "");
  TextEditingController createNotes = TextEditingController(text: "");
  TextEditingController details = TextEditingController(text: "");
  RxBool isNoteSaved = false.obs;

  late SharedPreferences prefs;
  int lengthHomeList = 0;
  int lengthExploreList = 0;
  String? token;
  var auth = Get.find<AuthController>();
  RxList<HomeModel> home = <HomeModel>[].obs;
  RxList<ViewNotesModel> viewsNotes = <ViewNotesModel>[].obs;

  RxList<ViewThreadModel> get viewsThread => setViewsThread;
  RxList<ViewThreadModel> setViewsThread = <ViewThreadModel>[].obs;
  RxList<ExploreModel> explore = <ExploreModel>[].obs;
  RxList<UserNotesModel> userNotesModel = <UserNotesModel>[].obs;
  RxList<UserRenotesModel> userRenotesModel = <UserRenotesModel>[].obs;
  RxList<UserMediaModel> userMediaModel = <UserMediaModel>[].obs;
  RxList<UserMoreModel> userMoreModel = <UserMoreModel>[].obs;
  UserChannelsModel? userChannelsModel;
  JsonChannelsArray? jsonChannelsArray;
  List<GetChannelMode> channels = [];
  List<ThreadModel> threadmodel = [];
  UserData? user;
  HomeTreadModel? homeThread;

  ExploreModel? selectedHomePostt;
  GetChannelMode? getChannelMode;
  ThreadNotes? threadNotes;
  var selectedIndex = 0.obs;
  ViewNotesModel? viewNotesModel;
  JsonRenoteArray? jsonRenoteArray;
  Rx<ViewThreadModel>? setViewThreadModel;

  Rx<ViewThreadModel>? get viewThreadModel => setViewThreadModel;
  int? noteId;
  int? threadNoteId;
  int? viewId;
  String? userHandle;
  List<String> threads = [];
  int? channelIdCreatePost;
  int? channelIdCreateThread;

  int? renoteId;

  String? userName;
  String? otherHandle;
  String? channelName;
  String? BodyNote;
  File? imageFile;
  String errorMessage = "";
  File? renoteImage;
  File? noteImage;
  File? createNoteImage;
  List<File?> createThreadImage = List.generate(10, (_) => null);
  bool isRefresh = true;
  bool isRefreshApi = true;
  final getChannel = false.obs;
  var isEmojiVisible = false.obs;
  var isTextFieldEmpty = true.obs;
  var isTextFieldEmptyThread = true.obs;
  FocusNode focusNode = FocusNode();
  RxDouble progressValue = 0.0.obs;
  String? text;
  String? selectedFilter;
  String? selectedSort;
  UploadImageModel? uploadImageModel;
  List<TextEditingController> threadList = [];
  int homePage = 1;
  int explorePage = 1;
  String? reportType;
  bool hitApi = true;

  final ApiClientWs apis = ApiClientWs(appBaseUrl: 'ws://sonata.seromatic.com:9501');

  @override
  Future<void> onInit() async {
    prefs = await SharedPreferences.getInstance();
    if (hitApi) {
      // await homeUser();
      // await exploreUserLogin();
    }
  }

  void checkTextFieldEmpty(String text) {
    isTextFieldEmpty.value = text.trim().isEmpty;
  }

  void updateProgressValue(String text) {
    progressValue.value = text.length / 200;
  }

  Future<void> exploreUserLogin() async {
    lengthExploreList = 0;
    var response = await apis.postData(
      {
        "request_type": "explore_feeds",
        "user_handle": auth.user?.userHandle ?? "",
        "page": "1",
        "timezone": "Asia/Karachi",
      },
      showdialog: isRefresh,
    );

    if (response.statusCode == 200) {
      try {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse is List<dynamic>) {
          if (isRefreshApi) {
            explore.clear();
          }

          for (var item in decodedResponse) {
            lengthExploreList++;
            explore.add(ExploreModel.fromJson(item));
          }

          update();
        } else {
          print('Invalid response format');
        }
      } catch (e) {
        print('Error parsing response: $e');
      }
    } else {
      print('Connection to API server failed due to internet connection');
    }
  }







// Other controller methods...

}
