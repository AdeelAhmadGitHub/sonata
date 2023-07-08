import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sonata/utils/functions.dart';
import 'package:web_socket_channel/io.dart';
import '../../Models/Explore Model/ExploreModel.dart';
import '../../Models/Followers Model/Followers Model.dart';
import '../../Models/Following Model/Foolows Model.dart';
import '../../Models/ProfileModel/UserChannelsModel.dart';
import '../../Models/ProfileModel/UserMediaModel.dart';
import '../../Models/ProfileModel/UserMoreModel.dart';
import '../../Models/ProfileModel/UserNotesModel.dart';
import '../../Models/ProfileModel/UserRenotesModel.dart';
import '../../Models/UserData.dart';

import '../../Models/ViewNotesModel/ViewNotesModel.dart';
import '../../Models/getChannel Model.dart';
import '../../Views/Profile/Profile.dart';
import '../../Views/View Notes/View Notes.dart';
import '../../api/api_checker.dart';
import '../../api/api_client.dart';
import '../HomeController/HomeController.dart';
import '../auth_controller.dart';
import 'package:dio/src/form_data.dart' as dioFormData;
import 'package:dio/src/multipart_file.dart' as dioMultipartFile;

String otherUserHandel = '';
UserNotesModel? selectedUserPost;
UserRenotesModel? selectedUserReNotePost;
int? ProCIhannel;
int? userReplyId;
int? userChannelId;

class ProfileController extends GetxController {
  TextEditingController noteBodyReply = TextEditingController(text: "");
  TextEditingController noteRenote = TextEditingController(text: "");
  TextEditingController createNotes = TextEditingController(text: "");
  TextEditingController createThread = TextEditingController(text: "");
  TextEditingController label = TextEditingController(text: "");
  TextEditingController link = TextEditingController(text: "");
  TextEditingController channelNamecont = TextEditingController(text: "");
  late SharedPreferences prefs;
  String? token;

  var auth = Get.find<AuthController>();
  var home = Get.put(HomeController());
  RxList<ViewNotesModel> view = <ViewNotesModel>[].obs;
  RxList<ExploreModel> explore = <ExploreModel>[].obs;
  RxList<UserNotesModel> userNotesModel = <UserNotesModel>[].obs;
  RxList<UserRenotesModel> userRenotesModel = <UserRenotesModel>[].obs;
  RxList<UserMediaModel> userMediaModel = <UserMediaModel>[].obs;
  RxList<UserMoreModel> userMoreModel = <UserMoreModel>[].obs;
  RxList<Following> following = <Following>[].obs;
  RxList<Followers> followers = <Followers>[].obs;
  UserChannelsModel? userChannelsModel;
  JsonChannelsArray? jsonChannelsArray;
  List<GetChannelMode> channels = [];
  UserData? user;
  GetChannelMode? getChannelMode;
  var selectedIndex = 0.obs;
  ViewNotesModel? viewNotesModel;
  ApiClient api = ApiClient(appBaseUrl: baseUrl);
  ApiChecker apichecker = ApiChecker();
  dynamic noteId;
  int? channelId;
  dynamic channelIdCreatePost;
  String? channelNameNotes = "All Channels";
  String? channelNameMedia = "All Channels";
  String? followHandle;
  int? replyId;
  dynamic renoteId;
  String? userHandel;
  String? userName;
  String? otherHandle;
  String? channelName;
  String? BodyNote;
  File? imageFile;
  String errorMessage = "";
  File? renoteImage;
  File? noteImage;
  File? createNoteImage;
  bool isRefresh = true;
  final getChannel = false.obs;
  var isEmojiVisible = false.obs;
  var isTextFieldEmpty = true.obs;
  FocusNode focusNode = FocusNode();
  RxDouble progressValue = 0.0.obs;
  String? text;
  String? selectedFilter;
  String? selectedSort;
  bool isLoading = false;
  String? statisticsFilterNotes = "most_recent";
  String? statisticsFilterReNotes = "most_recent";
  String? statisticsFilterMore = "liked";
  int lengthUserNotes = 0;
  int lengthRenoteNotes = 0;
  int lengthMediaNotes = 0;
  int lengthMoreNotes = 0;
  int notePage = 1;
  int renotePage = 1;
  int mediaPage = 1;
  int morePage = 1;
  bool isRefreshApi = true;
  @override
  Future<void> onInit() async {
    super.onInit();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        isEmojiVisible.value = false;
      }
    });
    prefs = await SharedPreferences.getInstance();
    // await userNotes();
    // await userReNotes();
    // await userMedia();
  }

  void checkTextFieldEmpty(String text) {
    isTextFieldEmpty.value = text.isEmpty;
  }

  void updateProgressValue(String text) {
    progressValue.value = text.length / 200;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    createNotes.dispose();
  }

  Future<bool> saveNote() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "save_note",
      "user_handle": auth.user?.userHandle,
      "note_id": noteId,
      "token": auth.user?.token ?? ""
    };
    print('Payload: ${jsonEncode(appUsername)}');

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
        // Hide the loader after receiving the API response
        hideLoader();

        // Close the WebSocket connection when done
        // channel.sink.close();
      }
    });

    return true;
  }
  Future<void> viewNotes() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "view_note",
      "note_id": noteId,
      "user_handle": auth.user?.userHandle ?? "",
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
          viewNotesModel = ViewNotesModel.fromJson(json);
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
        //channel.sink.close();
      }
    });
  }

  // Future<void> createNoteLike() async {
  //   final response = await api.postData(
  //       "api/create-note-like",
  //       {
  //         "request_type": "note_like_unlike",
  //         "user_handle": auth.user?.userHandle ?? "",
  //         "note_id": noteId ?? "",
  //         "token": auth.user?.token ?? ""
  //       },
  //       showdialog: false);
  //   if (response.statusCode == 200) {
  //     final json = response.body;
  //
  //     userNotes();
  //     userReNotes();
  //     userMedia();
  //     update();
  //   }
  // }
  Future<void> createNoteLike() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "note_like_unlike",
      "user_handle": auth.user?.userHandle ?? "",
      "note_id": noteId ?? "",
      "token": auth.user?.token ?? ""
    };
    channel.sink.add(jsonEncode(appUsername));

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
        if (json != null && json['status'] == 200 && json['data'] != null) {

          userNotes();
          userReNotes();
          userMedia();
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
        //channel.sink.close();
      }
    });
  }
  Future<void> deleteNote() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "delete_note",
      "user_handle": auth.user?.userHandle,
      "note_id": noteId,
      "token": auth.user?.token ?? ""
    };
    channel.sink.add(jsonEncode(appUsername));

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
        if (json != null && json['status'] == 200 && json['data'] != null) {

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
        //channel.sink.close();
      }
    });
  }
  Future<void> createUserFollow() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "user_follow_unfollow",
      "user_handle": auth.user?.userHandle ?? "",
      "followed_handle": otherHandle ?? "",
      "token": auth.user?.token ?? ""
    };
    channel.sink.add(jsonEncode(appUsername));

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
        if (json != null && json['status'] == 200 && json['data'] != null) {

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
        //channel.sink.close();
      }
    });
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
      await userNotes();
      await userReNotes();
      await userMedia();
      update();
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
      await userNotes();
      await userReNotes();
      await userMedia();
      update();
    }
  }

  Future<String?> uploadImage(File? imageFile, String imageName) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    print(imageFile?.path);
    print('$timestamp$imageName');

    const url = 'http://192.168.18.89:9501/api/upload-images';
    final dioInstance = Dio();

    try {
      final formData = dioFormData.FormData.fromMap({
        'request_type': 'create_note_image',
        'note_image': await dioMultipartFile.MultipartFile.fromFile(
          imageFile!.path,
          filename: imageName,
        ),
        'image_name': '$timestamp$imageName',
      });

      final response = await dioInstance.post(url, data: formData);

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        return timestamp.toString(); // Return the timestamp
      } else {
        print('Image upload failed with status ${response.statusCode}');
        return null; // Return null or handle the error as needed
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null; // Return null or handle the error as needed
    }
  }

  Future<void> createNoteReply() async {
    final imageTimestamp = '${noteImage?.path.split('/').last ?? ''}';
    final timestamp = await uploadImage(noteImage, imageTimestamp);
    final response = await api.postData(
        "api/create-note-reply",
        {
          "request_type": "note_reply",
          "user_handle": auth.user?.userHandle ?? "",
          "channel_id": userChannelId,
          "note_body": noteBodyReply.text.trim(),
          "reply_to_id": userReplyId,
          "image_name": noteImage != null ? '$timestamp$imageTimestamp' : '',
          // "note_image": noteImage != null
          //     ? base64Encode(noteImage!.readAsBytesSync())
          //     : "",
          "token": auth.user?.token ?? "",
        },
        showdialog: true);
    if (response.statusCode == 200) {
      final json = response.body;
      noteBodyReply.clear();
      Get.close(2);
      await userNotes();
      await userReNotes();
      await userMedia();
      await profileMore();
      update();
    }
  }

  Future<void> createRenote() async {
    final response = await api.postData(
        "api/create-renote",
        {
          "request_type": "create_renote",
          "user_handle": auth.user?.userHandle ?? "",
          "note_body": noteRenote.text.trim(),
          "channel_id": ProCIhannel,
          "renote_of_id": renoteId,
          "note_image": renoteImage != null
              ? base64Encode(renoteImage!.readAsBytesSync())
              : "",
          "token": auth.user?.token ?? ""
        },
        showdialog: false);
    if (response.statusCode == 200) {
      final json = response.body;
      noteRenote.clear();
      Get.close(2);
      userNotes();
      userReNotes();
      userMedia();
      update();
    }
  }

  Future<void> createNote() async {
    final response = await api.postData(
        "api/create-note",
        {
          "request_type": "create_note",
          "user_handle": auth.user?.userHandle ?? "",
          "note_body": createNotes.text.trim(),
          "channel_id": channelIdCreatePost,
          "note_image": createNoteImage != null
              ? base64Encode(createNoteImage!.readAsBytesSync())
              : "",
          "token": auth.user?.token ?? ""
        },
        showdialog: false);

    if (response.statusCode == 200) {
      // _showPostNotes(context);
      final json = response.body;
      Get.close(2);
      update();
    }
  }

  // Future createLink() async {
  //   Response response = await api.postData(
  //     "api/create-link",
  //     {
  //       "request_type": "create_link",
  //       "user_handle": user?.userName ?? "",
  //       "link_label": label.text.trim(),
  //       "custom_link": link.text.trim(),
  //       'token': user?.token ?? ""
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     // _showPostNotes(context);
  //     final json = response.body;
  //     Get.close(2);
  //     update();
  //   }
  // }
  Future<void> getChannels() async {
    getChannel.value = true;
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "view_channel_list",
      "user_handle": auth.user?.userHandle ?? "",
      "other_user_handle": auth.user?.userHandle ?? "",
    };
    channel.sink.add(jsonEncode(appUsername));

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
        if (json != null && json['status'] == 200 && json['data'] != null) {

          json['data'].forEach((v) {
            channels.add(GetChannelMode.fromJson(v));
          });
          getChannel.value = false;
          update();
        } else {
          // Handle other status cases if needed
        }
      } catch (e) {
        // Handle parsing errors or unexpected message format
        print('Error parsing message: $e');
      }

      finally {
        isLoading = false;
      }
    });
  }

  // Future<void> getChannels() async {
  //   getChannel.value = true;
  //   final response = await api.postData(
  //       "api/profile/channel-list",
  //       {
  //         "request_type": "view_channel_list",
  //         "user_handle": auth.user?.userHandle ?? "",
  //         "other_user_handle": otherUserHandel ?? "",
  //         "page": "1",
  //       },
  //       showdialog: false);
  //
  //   if (response.statusCode == 200) {
  //     final json = response.body;
  //     json.forEach((v) {
  //       channels.add(GetChannelMode.fromJson(v));
  //     });
  //     getChannel.value = false;
  //     update();
  //   }
  // }

  Future<void> userNotes() async {
    lengthUserNotes = 0;
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "view_profile_note",
      "user_handle": auth.user?.userHandle ?? "",
      "other_user_handle": otherUserHandel,
      "page": "$notePage",
      "channel_filter": channelNameNotes,
      "statistics_filter": "$statisticsFilterNotes",
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
          userNotesModel = <UserNotesModel>[].obs;
          json['data'].forEach((v) {
            userNotesModel.add(UserNotesModel.fromJson(v));
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

  Future<void> userReNotes() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "view_profile_renote",
      "user_handle": auth.user?.userHandle ?? "",
      "other_user_handle": otherUserHandel ?? "",
      "statistics_filter": statisticsFilterReNotes ?? "",
      "timezone": "Asia/Karachi",
      "page": "1",
    };
    channel.sink.add(jsonEncode(appUsername));

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
        if (json != null && json['status'] == 200 && json['data'] != null) {

          userRenotesModel = <UserRenotesModel>[].obs;
          json['data'].forEach((v) {
            userRenotesModel.add(UserRenotesModel.fromJson(v));
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
        //channel.sink.close();
      }
    });
  }
  Future<void> userChannels() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "view_profile_channel",
      "user_handle": auth.user?.userHandle ?? "",
      "other_user_handle": otherUserHandel,
      "page": "1",
      "timezone": "Asia/Karachi",
    };
    channel.sink.add(jsonEncode(appUsername));

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
        if (json != null && json['status'] == 200 && json['data'] != null) {

          userChannelsModel = UserChannelsModel.fromJson(json);
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
        //channel.sink.close();
      }
    });
  }

  Future<void> userMedia() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "view_profile_media",
      "user_handle": auth.user?.userHandle ?? "",
      "other_user_handle": otherUserHandel,
      "page": "1",
      "channel_filter": channelNameMedia,
      "statistics_filter": "most_recent",
      "timezone": "Asia/Karachi",
    };
    channel.sink.add(jsonEncode(appUsername));

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
        if (json != null && json['status'] == 200 && json['data'] != null) {

          userMediaModel = <UserMediaModel>[].obs;
          json['data'].forEach((v) {
            userMediaModel.add(UserMediaModel.fromJson(v));
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
        //channel.sink.close();
      }
    });
  }

  Future<void> profileMore() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "view_profile_more",
      "user_handle": auth.user?.userHandle ?? "",
      "other_user_handle": otherUserHandel,
      "filter_type": statisticsFilterMore ?? "",
      "page": "1",
      "timezone": "Asia/Karachi",
    };
    channel.sink.add(jsonEncode(appUsername));

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
        if (json != null && json['status'] == 200 && json['data'] != null) {

          userMoreModel = <UserMoreModel>[].obs;
          json['data'].forEach((v) {
            userMoreModel.add(UserMoreModel.fromJson(v));
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
        //channel.sink.close();
      }
    });
  }

  Future<void> followingUser() async {
    final response =
        await api.postData("api/profile/following-followers-list", {
      "request_type": "following_list",
      "user_handle": auth.user?.userHandle ?? "",
      "other_user_handle": otherUserHandel,
      "token": auth.user?.token ?? ""
    });

    if (response.statusCode == 200) {
      final json = response.body;
      following = <Following>[].obs;
      if (json['following'] != null) {
        json['following'].forEach((v) {
          following.add(Following.fromJson(v));
        });
      }
      update();
    }
  }
  Future<void> followersUser() async {
    final response =
        await api.postData("api/profile/following-followers-list", {
      "request_type": "followers_list",
      "user_handle": auth.user?.userHandle ?? "",
      "other_user_handle": otherUserHandel,
      "token": auth.user?.token ?? ""
    });

    if (response.statusCode == 200) {
      final json = response.body;
      followers = <Followers>[].obs;
      if (json['followers'] != null) {
        json['followers'].forEach((v) {
          followers.add(Followers.fromJson(v));
        });
      }
      update();
    }
  }
  Future<void> createUsersFollow(String? otherUserHandel) async {
    final response = await api.postData(
        "api/create-user-follow",
        {
          "request_type": "user_follow_unfollow",
          "user_handle": auth.user?.userHandle ?? "",
          "followed_handle": otherUserHandel ?? "",
          "token": auth.user?.token ?? ""
        },
        showdialog: false);
    if (response.statusCode == 200) {
      final json = response.body;
      update();
    }
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