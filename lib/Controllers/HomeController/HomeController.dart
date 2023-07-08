import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonata/Models/HomeModel/HomeModel.dart';
import 'package:web_socket_channel/io.dart';

import '../../Models/Explore Model/ExploreModel.dart';
import '../../Models/HomeTreadModel/HomeTreadModel.dart';
import '../../Models/ProfileModel/UserChannelsModel.dart';
import '../../Models/ProfileModel/UserMediaModel.dart';
import '../../Models/ProfileModel/UserMoreModel.dart';
import '../../Models/ProfileModel/UserNotesModel.dart';
import '../../Models/ProfileModel/UserRenotesModel.dart';
import '../../Models/ThreadModel/thread-model.dart';
import '../../Models/UploadImageModel/UploadImageMModel.dart';
import '../../Models/UserData.dart';
import '../../Models/View Thread Model/ViewThreadModel.dart';
import '../../Models/ViewNotesModel/ViewNotesModel.dart';
import '../../Models/getChannel Model.dart';
import '../../Models/threadlenght.dart';
import '../../Views/NaviationBar/NavigationBarScreen.dart';
import '../../Views/Thread View/Thread View.dart';
import '../../Views/View Notes/View Notes.dart';
import '../../Views/Widgets/custom_text.dart';
import '../../api/api_checker.dart';
import '../../api/api_client.dart';
import '../../utils/functions.dart';
import '../auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/src/form_data.dart' as dioFormData;
import 'package:dio/src/multipart_file.dart' as dioMultipartFile;

HomeModel? selectedHomePost;
ExploreModel? selectedExplorePost;
String? userHandel;
int? replyId;
int? channelId;

class HomeController extends GetxController {
  final channel = IOWebSocketChannel.connect('ws://192.168.18.89:9501');
  TextEditingController desCont = TextEditingController(text: "");
  TextEditingController locCont = TextEditingController(text: "");
  TextEditingController workCont = TextEditingController(text: "");

  /////////////////////////////////////////////////////////////////
  TextEditingController noteBodyReply = TextEditingController(text: "");
  TextEditingController noteBodyRenote = TextEditingController(text: "");
  TextEditingController createNotes = TextEditingController(text: "");
  TextEditingController details = TextEditingController(text: "");
  RxBool isNoteSaved = false.obs;
  bool isLoading = false;
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
  ApiClient api = ApiClient(appBaseUrl: baseUrl);
  ApiChecker apichecker = ApiChecker();
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

  Future<void> homeUser() async {
    final channel = IOWebSocketChannel.connect('ws://192.168.18.89:9501');
    lengthHomeList = 0;
    var appUsername = {
      "request_type": "home_feeds",
      "user_handle": auth.user?.userHandle ?? "",
      "page": "$homePage",
      'token': auth.user?.token ?? "",
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
          if (isRefreshApi) {
            home = <HomeModel>[].obs;
          }

          json['data'].forEach((v) {
            lengthHomeList++;
            home.add(HomeModel.fromJson(v));
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

  void uploadProfileImage(File imageFile) async {
    print(imageFile.path);
    print(auth.user?.userHandle);
    final url = 'http://192.168.18.89:9501/api/upload-images';
    final dioInstance = Dio();

    try {
      final formData = dioFormData.FormData.fromMap({
        'request_type': 'edit_profile_image ',
        'profile_image': await dioMultipartFile.MultipartFile.fromFile(
          imageFile.path,
        ),
        // 'user_handle': auth.user?.userName ?? "",
      });

      final response = await dioInstance.post(url, data: formData);

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Image upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }


  // Future<String?> uploadImage(File? imageFile, String imageName) async {
  //   final timestamp = DateTime.now().millisecondsSinceEpoch;
  //   print(imageFile?.path);
  //   print('$timestamp$imageName');
  //
  //   const url = 'http://192.168.18.89:9501/api/upload-images';
  //   final dioInstance = Dio();
  //
  //   try {
  //     final formData = dioFormData.FormData.fromMap({
  //       'request_type': 'create_note_image',
  //       'note_image': await dioMultipartFile.MultipartFile.fromFile(
  //         imageFile!.path,
  //         filename: imageName,
  //       ),
  //       'image_name': '$timestamp$imageName',
  //     });
  //
  //     final response = await dioInstance.post(url, data: formData);
  //
  //     if (response.statusCode == 200) {
  //       print('Image uploaded successfully');
  //       return timestamp.toString(); // Return the timestamp
  //     } else {
  //       print('Image upload failed with status ${response.statusCode}');
  //       return null; // Return null or handle the error as needed
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     return null; // Return null or handle the error as needed
  //   }
  // }



  Future<String?> uploadImage(File? imageFile, String imageName) async {
    final channel = IOWebSocketChannel.connect('ws://192.168.18.89:9501');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    print(imageFile?.path);
    print('$timestamp$imageName');

    try {
      final imageBytes = await imageFile!.readAsBytes();
      final encodedImage = base64Encode(imageBytes);

      final request = {
        'request_type': 'create_note_image',
        'note_image': encodedImage,
        'image_name': '$timestamp$imageName',
      };

      channel.sink.add(jsonEncode(request)); // Send the request through the WebSocket

      await channel.stream.first; // Wait for the response from the server

      print('Image uploaded successfully');
     // channel.sink.close(); // Close the WebSocket connection
      return timestamp.toString(); // Return the timestamp
    } catch (e) {
      print('Error uploading image: $e');
    //  channel.sink.close(); // Close the WebSocket connection
      return null; // Return null or handle the error as needed
    }
  }




  // Future<String?> uploadImage(File? imageFile, String imageName) async {
  //   final timestamp = DateTime.now().millisecondsSinceEpoch;
  //   print(imageFile?.path);
  //   print('$timestamp$imageName');
  //
  //   final socketUrl = 'ws://sonata.seromatic.com:9501';
  //   final dioInstance = Dio();
  //
  //   try {
  //     final channel = IOWebSocketChannel.connect(socketUrl);
  //     final formData = dioFormData.FormData.fromMap({
  //       'request_type': 'create_note_image',
  //       'image_name': '$timestamp$imageName',
  //     });
  //
  //     // Send the file data as a WebSocket message
  //     channel.sink.add(imageFile!.readAsBytesSync());
  //
  //     final response = await dioInstance.post(
  //       'http://192.168.18.89:9501/api/upload-images',
  //       data: formData,
  //       onSendProgress: (int sent, int total) {
  //         final progress = (sent / total * 100).toStringAsFixed(2);
  //         print('Upload progress: $progress%');
  //       },
  //     );
  //
  //     channel.sink.close(); // Close the WebSocket connection
  //
  //     if (response.statusCode == 200) {
  //       print('Image uploaded successfully');
  //       return timestamp.toString(); // Return the timestamp
  //     } else {
  //       print('Image upload failed with status ${response.statusCode}');
  //       return null; // Return null or handle the error as needed
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     return null; // Return null or handle the error as needed
  //   }
  // }

  Future<void> viewNotes() async {
    final channel = IOWebSocketChannel.connect('ws://192.168.18.89:9501');
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
          viewNotesModel = ViewNotesModel.fromJson(json);
          Future.delayed(Duration.zero, () {
            Get.to(ViewNotes(
              viewNotesModel: viewNotesModel!,
            ));
          });
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

  Future<void> viewThread() async {
    print("/?????????????????$threadNoteId");
    final channel = IOWebSocketChannel.connect('ws://192.168.18.89:9501');

    var appUsername = {
      "request_type": "view_thread",
      "user_handle": auth.user?.userHandle ?? "",
      "thread_note_id": threadNoteId,
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
        if (json != null && json['status'] == 200 && json['data'] != null) {
          final data = json['data'];
          setViewThreadModel = ViewThreadModel.fromJson(data).obs;
          print("viewThreadModel?.value.noteTimeAgo");
          print(viewThreadModel?.value.noteTimeAgo);

          Future.delayed(Duration.zero, () {
            Get.to(ThreadView(
              viewCont: viewThreadModel?.value,
            ));
          });
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

  Future<void> createNoteLike() async {
    final channel = IOWebSocketChannel.connect('ws://192.168.18.89:9501');
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
  }

  Future<void> createNote(BuildContext context) async {
    final channel = IOWebSocketChannel.connect('ws://192.168.18.89:9501');
    final imageTimestamp = '${createNoteImage?.path.split('/').last ?? ''}';
    final timestamp =  await uploadImage(createNoteImage, imageTimestamp);

    var appUsername = {
      "request_type": "create_note",
      "user_handle": auth.user?.userHandle ?? "",
      "note_body": createNotes.text.trim(),
      "channel_id": channelIdCreatePost,
      "image_name":
      createNoteImage != null ? '$timestamp$imageTimestamp' : '',
      "token": auth.user?.token ?? ""
    };
    print('Payload: ${jsonEncode(appUsername)}');

    channel.sink.add(jsonEncode(appUsername));

    // Show the loader before making the API request
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
          createNotes.clear();
          homeUser();
        } else {
          // Handle other status cases if needed
        }
      } catch (e) {
        // Handle parsing errors or unexpected message format
        print('Error parsing message: $e');
      } finally {
        hideLoader();
      }
    });
  }


  Future<void> createNoteReply() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    final imageTimestamp = '${noteImage?.path.split('/').last ?? ''}';
    final timestamp = await uploadImage(noteImage, imageTimestamp);
    var appUsername =        {
      "request_type": "note_reply",
      "user_handle": auth.user?.userHandle ?? "",
      "channel_id": channelId,
      "note_body": noteBodyReply.text.trim(),
      "reply_to_id": replyId,
      "image_name": noteImage != null ? '$timestamp$imageTimestamp' : '',
      // "note_image": noteImage != null
      //     ? base64Encode(noteImage!.readAsBytesSync())
      //     : "",
      "token": auth.user?.token ?? "",
    };
    print('Payload: ${jsonEncode(appUsername)}');

    channel.sink.add(jsonEncode(appUsername));

    // Show the loader before making the API request
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
          noteBodyReply.clear();
          Get.close(2);
          homeUser();
          update();
        } else {
          // Handle other status cases if needed
        }
      } catch (e) {
        // Handle parsing errors or unexpected message format
        print('Error parsing message: $e');
      } finally {
        hideLoader();
      }
    });
  }

  Future<void> createRenote() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    final imageTimestamp = '${renoteImage?.path.split('/').last ?? ''}';
    final timestamp = await uploadImage(renoteImage, imageTimestamp);
    var appUsername =        {
      "request_type": "create_renote",
      "user_handle": auth.user?.userHandle ?? "",
      "note_body": noteBodyRenote.text.trim(),
      "channel_id": channelId,
      "renote_of_id": renoteId,
      "image_name": renoteImage != null ? '$timestamp$imageTimestamp' : '',
      "token": auth.user?.token ?? ""
    };
    print('Payload: ${jsonEncode(appUsername)}');

    channel.sink.add(jsonEncode(appUsername));

    // Show the loader before making the API request
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
          noteBodyRenote.clear();
          Get.close(2);
           homeUser();
          update();
        } else {
          // Handle other status cases if needed
        }
      } catch (e) {
        // Handle parsing errors or unexpected message format
        print('Error parsing message: $e');
      } finally {
        hideLoader();
      }
    });
  }
  Future<void> createThread(BuildContext context) async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    List<Map<String, dynamic>> threadData = [];

    for (int i = 0; i < threads.length; i++) {
      final thread = threads[i];
      final image = createThreadImage[i];

      String imageTimestamp = '';
      String imageName = '';

      if (image != null) {
        imageTimestamp = '${image.path.split('/').last ?? ''}';
        final timestamp = await uploadImage(image, imageTimestamp);
        imageName = '$timestamp$imageTimestamp';
      }

      final threadEntry = {
        "channel_id": channelIdCreatePost,
        "thread_body": thread,
        "image_name": imageName,
      };

      threadData.add(threadEntry);
    }

    var appUsername = {
      "request_type": "create_thread",
      "user_handle": auth.user?.userHandle ?? "",
      "thread": threadData,
      "token": auth.user?.token ?? ""
    };
    print('Payload: ${jsonEncode(appUsername)}');

    channel.sink.add(jsonEncode(appUsername));

    // Show the loader before making the API request
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
          threads.clear();
          Get.close(2);
          update();
        } else {
          // Handle other status cases if needed
        }
      } catch (e) {
        // Handle parsing errors or unexpected message format
        print('Error parsing message: $e');
      } finally {
        hideLoader();
      }
    });
  }
  Future<void> getChannels() async {
    getChannel.value = true;
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
        // Hide the loader after receiving the API response
        hideLoader();

        // Close the WebSocket connection when done
        // channel.sink.close();
      }
    });
  }

  Future<void> exploreUserLogin() async {
    final channel = IOWebSocketChannel.connect('ws://192.168.18.89:9501');
    lengthExploreList = 0;
    var appUsername = {
      "request_type": "explore_feeds",
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
          if (isRefreshApi) {
            explore = <ExploreModel>[].obs;
          }

          json['data'].forEach((v) {
            lengthExploreList++;
            explore.add(ExploreModel.fromJson(v));
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

  Future<void> deleteNote() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername =        {
      "request_type": "delete_note",
      "user_handle": auth.user?.userHandle,
      "note_id": noteId,
      "token": auth.user?.token ?? ""
    };
    print('Payload: ${jsonEncode(appUsername)}');

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
  Future<void> userInteractionsMute() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername =        {
      "request_type": "interact_to_mute_unmute_user",
      "user_handle": auth.user?.userHandle,
      "interact_to_user_handle": otherHandle,
      "token": auth.user?.token ?? ""
    };
    print('Payload: ${jsonEncode(appUsername)}');

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
  }

  Future<void> userInteractionsBlocked() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername =        {
      "request_type": "interact_to_block_unblock_user",
      "user_handle": auth.user?.userHandle,
      "interact_to_user_handle": otherHandle,
      "token": auth.user?.token ?? ""
    };
    print('Payload: ${jsonEncode(appUsername)}');

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
  }


  Future<bool> createUserFollow() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "user_follow_unfollow",
      "user_handle": auth.user?.userHandle ?? "",
      "followed_handle": otherHandle ?? "",
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

  Future<void> userNoteReport() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername =        {
      "request_type": "report_user",
      "user_handle": auth.user?.userHandle,
      "reported_note_id": noteId,
      "report_type": reportType,
      "message": details.text.trim(),
      "token": auth.user?.token ?? ""
    };
    print('Payload: ${jsonEncode(appUsername)}');

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
        if (json != null) {

          homeUser();
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

  Future<void>_showPostNotes(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/Post Note.png"),
                  CustomText(
                    text: 'Your note has been posted',
                    fontColor: const Color(0xff5D4180),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ));
      },
    );
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
