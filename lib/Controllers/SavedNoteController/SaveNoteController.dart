import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sonata/Models/HomeModel/HomeModel.dart';

import '../../Models/Explore Model/ExploreModel.dart';
import '../../Models/SavedNoteModel/SavedNoteModel.dart';
import '../../Models/ThreadModel/thread-model.dart';
import '../../Models/UserData.dart';

import '../../Models/View Thread Model/ViewThreadModel.dart';
import '../../Models/ViewNotesModel/ViewNotesModel.dart';
import '../../Models/getChannel Model.dart';
import '../../Models/threadlenght.dart';
import '../../Views/Thread View/Thread View.dart';
import '../../Views/View Notes/View Notes.dart';
import '../../api/api_checker.dart';
import '../../api/api_client.dart';
import '../../utils/functions.dart';
import '../auth_controller.dart';
import 'dart:convert';

String otherUserHandel = '';
SavedNoteModel? selectedSavePost;
int? channelSaveId;

class SavedNotesController extends GetxController {
  late SharedPreferences prefs;
  String? token;
  var isTextFieldEmpty = true.obs;
  var isTextFieldEmptyThread = true.obs;
  RxDouble progressValue = 0.0.obs;
  var auth = Get.find<AuthController>();
  RxList<SavedNoteModel> save = <SavedNoteModel>[].obs;
  TextEditingController noteBodyReply = TextEditingController(text: "");

  TextEditingController noteBodyRenote = TextEditingController(text: "");
  List<GetChannelMode> channels = [];
  List<ThreadModel> threadmodel = [];
  UserData? user;
  SavedNoteModel? selectedHomePost;
  ViewNotesModel? viewNotesModel;
  Rx<ViewThreadModel>? setViewThreadModel;
  Rx<ViewThreadModel>? get viewThreadModel => setViewThreadModel;
  ApiClient api = ApiClient(appBaseUrl: baseUrl);
  ApiChecker apichecker = ApiChecker();
  int? threadNoteId;
  int? noteId;
  int? channelId;
  int? thread;
  int? replyId;
  int? renoteId;
  String? userHandel;
  String? userName;
  String? otherHandle;
  String? channelName;
  File? imageFile;
  bool isRefresh = true;
  String? text;
  File? renoteImage;
  File? noteImage;
  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
  }

  void checkTextFieldEmpty(String text) {
    isTextFieldEmpty.value = text.trim().isEmpty;
  }

  void updateProgressValue(String text) {
    progressValue.value = text.length / 200;
  }

  Future<void> savedNotes() async {
    final response = await api.postData(
        "api/saved-note",
        {
          "request_type": "view_saved_note",
          "user_handle": auth.user?.userHandle ?? "",
          "page": "1",
          "timezone": "Asia/Karachi",
          "token": auth.user?.token ?? ""
        },
        showdialog: true);
    if (response.statusCode == 200) {
      final json = response.body;
      save = <SavedNoteModel>[].obs;
      json.forEach((v) {
        save.add(SavedNoteModel.fromJson(v));
      });
      update();
    }
  }

  Future<void> viewNotes() async {
    final response = await api.postData(
      "api/notes/note-view",
      {
        "request_type": "view_note",
        "note_id": noteId,
        "user_handle": auth.user?.userHandle ?? "",
        "timezone": "Asia/Karachi",
      },
      showdialog: true,
    );

    if (response.statusCode == 200) {
      final json = response.body;
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
    }
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
      showdialog: true,
    );
    if (response.statusCode == 200) {
      final json = response.body;
      //print(json[0]);
      setViewThreadModel = ViewThreadModel.fromJson(json).obs;
      print("viewThreadModel?.value.noteTimeAgo");
      print(viewThreadModel?.value.noteTimeAgo);

      Get.to(ThreadView(
        viewCont: viewThreadModel?.value,
      ));
      update();
    }
  }

  Future<void> createNoteLike() async {
    final response = await api.postData(
        "api/create-note-like",
        {
          "request_type": "note_like_unlike",
          "user_handle": auth.user?.userHandle ?? "",
          "note_id": noteId ?? "",
          "token": auth.user?.token ?? "",
          "timezone": "Asia/Karachi",
        },
        showdialog: false);
    if (response.statusCode == 200) {
      final json = response.body;
      update();
    }
  }

  Future<void> createNoteReply() async {
    final response = await api.postData(
        "api/create-note-reply",
        {
          "request_type": "note_reply",
          "user_handle": auth.user?.userHandle ?? "",
          "channel_id": channelId,
          "note_body": noteBodyReply.text.trim(),
          "reply_to_id": replyId,
          "note_image": noteImage != null
              ? base64Encode(noteImage!.readAsBytesSync())
              : "",
          "token": auth.user?.token ?? "",
          "timezone": "Asia/Karachi",
        },
        showdialog: false);
    if (response.statusCode == 200) {
      final json = response.body;
      noteBodyReply.clear();
      Get.close(2);
      savedNotes();
      update();
    }
  }

  Future<void> createRenote() async {
    final response = await api.postData(
        "api/create-renote",
        {
          "request_type": "create_renote",
          "user_handle": auth.user?.userHandle ?? "",
          "note_body": noteBodyRenote.text.trim(),
          "channel_id": channelSaveId,
          "renote_of_id": renoteId,
          "note_image": renoteImage != null
              ? base64Encode(renoteImage!.readAsBytesSync())
              : "",
          "token": auth.user?.token ?? "",
          "timezone": "Asia/Karachi",
        },
        showdialog: false);
    if (response.statusCode == 200) {
      print("???????????????????????????");
      final json = response.body;
      noteBodyRenote.clear();
      Get.close(2);
      savedNotes();
      update();
    }
  }

  Future<void> deleteNote() async {
    final response = await api.postData(
        "api/delete-note",
        {
          "request_type": "delete_note",
          "user_handle": auth.user?.userHandle,
          "note_id": noteId,
          "token": auth.user?.token ?? ""
        },
        showdialog: true);
    if (response.statusCode == 200) {
      final json = response.body;
      update();
    }
  }

  Future<bool> saveNote() async {
    //  if (noteId == null) {
    final response = await api.postData(
        "api/save-note",
        {
          "request_type": "save_note",
          "user_handle": auth.user?.userHandle,
          "note_id": noteId,
          "token": auth.user?.token ?? ""
        },
        showdialog: false);
    if (response.statusCode == 200) {
      final json = response.body;
      update();
      return true;
    } else {
      return false;
    }
  }

  Future<void> userInteractionsMute() async {
    final response = await api.postData(
        "api/user-interactions",
        {
          "request_type": "interact_to_mute_unmute_user",
          "user_handle": auth.user?.userHandle,
          "interact_to_user_handle": otherHandle,
          "token": auth.user?.token ?? ""
        },
        showdialog: false);
    if (response.statusCode == 200) {
      final json = response.body;
      update();
    }
  }

  Future<void> userInteractionsBlocked() async {
    final response = await api.postData(
        "api/user-interactions",
        {
          "request_type": "interact_to_block_unblock_user",
          "user_handle": auth.user?.userHandle,
          "interact_to_user_handle": otherHandle,
          "token": auth.user?.token ?? ""
        },
        showdialog: false);
    if (response.statusCode == 200) {
      final json = response.body;
      print(json);
      print("Good");
      update();
    }
  }

  Future<void> createUserFollow() async {
    final response = await api.postData(
        "api/create-user-follow",
        {
          "request_type": "user_follow_unfollow",
          "user_handle": auth.user?.userHandle ?? "",
          "followed_handle": otherHandle ?? "",
          "token": auth.user?.token ?? ""
        },
        showdialog: false);
    if (response.statusCode == 200) {
      final json = response.body;
      update();
    }
  }
}
