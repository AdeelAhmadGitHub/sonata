// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sonata/Controllers/auth_controller.dart';
import 'package:sonata/Views/Profile%20View/Profile%20View.dart';
import 'package:sonata/Views/Sign%20In/SignIn.dart';

import '../../Models/UserData.dart';
import '../../Views/NaviationBar/NavigationBarScreen.dart';
import '../../api/api_checker.dart';
import '../../api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:dio/src/form_data.dart' as dioFormData;
import 'package:dio/src/multipart_file.dart' as dioMultipartFile;

import '../ProfileController/ProfileController.dart';

class CreateChannelController extends GetxController {
  var profile = Get.put(ProfileController());
  late SharedPreferences prefs;
  TextEditingController channelName = TextEditingController(text: "");
  TextEditingController link = TextEditingController(text: "");
////////////////////////////////////////////////////////////////////
  TextEditingController channelEdited = TextEditingController(text: "");
  int channelIdEdited = 0;
  int? channelId;
  /////////////////////////////////////////////////////////////
  final auth = Get.put(AuthController());
  ApiClient api = ApiClient(appBaseUrl: baseUrl);
  ApiChecker apichecker = ApiChecker();
  bool isRefresh = true;
  File? createChannelImage;
  File? editChannelImage;
  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
  }

  Future<String?> uploadChannelImage(File? imageFile, String imageName) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    print(imageFile?.path);
    print('$timestamp$imageName');

    const url = 'http://sonata.seromatic.com:9501/api/upload-images';
    final dioInstance = Dio();

    try {
      final formData = dioFormData.FormData.fromMap({
        'request_type': 'create_channel_image',
        'channel_image': await dioMultipartFile.MultipartFile.fromFile(
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

  Future<void> createChannel() async {
    final imageTimestamp = '${createChannelImage?.path.split('/').last ?? ''}';
    final timestamp =
        await uploadChannelImage(createChannelImage, imageTimestamp);
    final response = await api.postData(
        "api/create-channel",
        {
          "request_type": "create_channel",
          "user_handle": auth.user?.userHandle ?? "",
          "channel_name": channelName.text.trim(),
          "token": auth.user?.token ?? "",
          "image_name":
              createChannelImage != null ? '$timestamp$imageTimestamp' : '',
          "token": auth.user?.token ?? ""
        },
        showdialog: true);
    if (response.statusCode == 200) {
      final json = response.body;
      channelName.clear();
      profile.userChannels();
      update();
    }
  }

  Future<void> editChannel() async {
    final imageTimestamp = '${editChannelImage?.path.split('/').last ?? ''}';
    final timestamp =
        await uploadChannelImage(editChannelImage, imageTimestamp);
    final response = await api.postData(
        "api/edit-channel",
        {
          "request_type": "edit_channel",
          "user_handle": auth.user?.userHandle ?? "",
          "channel_name": channelEdited.text.trim(),
          "image_name":
              editChannelImage != null ? '$timestamp$imageTimestamp' : '',
          "token": auth.user?.token ?? "",
        },
        showdialog: true);
    if (response.statusCode == 200) {
      final json = response.body;
      print(json);
      print("jfcienclijefcoielwf");
      profile.userChannels();
      update();
    }
  }

  Future<void> setDefaultChannel() async {
    final response = await api.postData(
        "api/set-default-channel",
        {
          "request_type": "set_default_channel",
          "user_handle": auth.user?.userHandle ?? "",
          "channel_id": channelId,
          "token": auth.user?.token ?? "",
        },
        showdialog: true);
    if (response.statusCode == 200) {
      final json = response.body;
      print(json);
      print("jfcienclijefcoielwf");
      profile.userChannels();
      update();
    }
  }

  Future<void> deleteChannel() async {
    final response = await api.postData(
        "api/delete-channel",
        {
          "request_type": "delete_channel",
          "user_handle": auth.user?.userHandle ?? "",
          "channel_id": channelId,
          "token": auth.user?.token ?? "",
        },
        showdialog: true);
    if (response.statusCode == 200) {
      final json = response.body;
      print(json);
      print("jfcienclijefcoielwf");
      profile.userChannels();
      update();
    }
  }
}
