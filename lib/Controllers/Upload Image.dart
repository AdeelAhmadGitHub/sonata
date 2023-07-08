import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonata/Views/Profile/Profile.dart';
import 'package:sonata/utils/app_constants.dart';
import '../../Models/UserData.dart';
import '../../api/api_checker.dart';
import '../../api/api_client.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:dio/src/form_data.dart' as dioFormData;
import 'package:dio/src/multipart_file.dart' as dioMultipartFile;
import '../Views/NaviationBar/NavigationBarScreen.dart';
import 'auth_controller.dart';

class UploadProfileController extends GetxController {
  TextEditingController editNameCont = TextEditingController(text: "");
  TextEditingController editLocation = TextEditingController(text: "");
  TextEditingController editDescriptionCont = TextEditingController(text: "");
  TextEditingController editTagLine = TextEditingController(text: "");
  TextEditingController editLocationCont = TextEditingController(text: "");
  TextEditingController editWorkCont = TextEditingController(text: "");

  /////////////////////////////////////////////////////////////////
  TextEditingController noteBodyReply = TextEditingController(text: "");
  TextEditingController noteBodyRenote = TextEditingController(text: "");
  TextEditingController createNotes = TextEditingController(text: "");

  //TextEditingController createeThread = TextEditingController(text: "");
  late SharedPreferences prefs;
  String? token;
  String? timestamp;
  String? timestampCover;
  var auth = Get.find<AuthController>();
  UserData? user;
  ApiClient api = ApiClient(appBaseUrl: baseUrl);
  ApiChecker apichecker = ApiChecker();
  String? userHandel;
  File? imageFile;
  bool isImageUploaded = false;
  File? editProfileImage;
  File? editCoverImage;
  bool coverNullByUser = true;
  bool imageNullByUser = true;
  String? dob;
  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
  }

  void uploadProfileImage(File imageFile) async {
    print(imageFile.path);
    print(auth.userHandle.text);
    final url = 'http://192.168.18.89:9501/api/upload-images';
    final dioInstance = Dio();

    try {
      final formData = dioFormData.FormData.fromMap({
        'request_type': 'create_profile_image',
        'profile_image': await dioMultipartFile.MultipartFile.fromFile(
          imageFile.path,
        ),
        'user_handle': auth.userHandle.text,
      });

      final response = await dioInstance.post(url, data: formData);

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        isImageUploaded = true;
        auth.profileImageUpload =
            response.data['profile_image']; // Set the flag to true

        update(); // Update the UI
      } else {
        print('Image upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<String?> uploadImage(File? imageFile, String imageName) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    print(imageFile?.path);
    print('$timestamp$imageName');

    final url = 'http://sonata.seromatic.com:9501/api/upload-images';
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
      return null;
    }
  }

  // Future<String?> EditProfileImage(File? imageFile, String imageName) async {
  //   final timestamps = DateTime.now().millisecondsSinceEpoch;
  //   print(imageFile?.path);
  //   print('$timestamps$imageName');
  //
  //   const url = 'http://sonata.seromatic.com:9501/api/upload-images';
  //   final dioInstance = Dio();
  //
  //   try {
  //     final formData = dioFormData.FormData.fromMap({
  //       'request_type': 'edit_profile_image',
  //       'profile_image': await dioMultipartFile.MultipartFile.fromFile(
  //         imageFile!.path,
  //         filename: imageName,
  //       ),
  //       'image_name': '$timestamps$imageName',
  //     });
  //
  //     final response = await dioInstance.post(url, data: formData);
  //
  //     if (response.statusCode == 200) {
  //       imageNullByUser = false;
  //       coverNullByUser = false;
  //       print('Image uploaded successfully');
  //       timestamp = timestamps.toString();
  //       return timestamps.toString(); // Return the timestamp
  //     } else {
  //       print('Image upload failed with status ${response.statusCode}');
  //       return null;
  //     }
  //   } catch (e) {
  //     print('Error uploading image: $e');
  //     return null;
  //   }
  // }

  Future<String?> coverImageUpload(
      File? imageFile, String coverImageName) async {
    final covertimestamps = DateTime.now().millisecondsSinceEpoch;
    print(imageFile?.path);
    print('$covertimestamps$coverImageName');

    const url = 'http://sonata.seromatic.com:9501/api/upload-images';
    final dioInstance = Dio();

    try {
      final formData = dioFormData.FormData.fromMap({
        'request_type': 'edit_cover_image',
        'cover_image': await dioMultipartFile.MultipartFile.fromFile(
          imageFile!.path,
          filename: coverImageName,
        ),
        'cover_image_name ': '$covertimestamps$coverImageName',
      });

      final response = await dioInstance.post(url, data: formData);

      if (response.statusCode == 200) {
        coverNullByUser = false;
        imageNullByUser = false;
        print('Image uploaded successfully');
        timestampCover = covertimestamps.toString();
        return covertimestamps.toString(); // Return the timestamp
      } else {
        print('Image upload failed with status ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Future<void> editProfileUser() async {
  //   final imageTimestamp = '${editProfileImage?.path.split('/').last ?? ''}';
  //   // final timestamp = await EditProfileImage(editProfileImage, imageTimestamp);
  //   final coverTimestamp = '${editCoverImage?.path.split('/').last ?? ''}';
  //   // final timestampCover =
  //   //     await coverImageUpload(editCoverImage, coverTimestamp);
  //   final response = await api.postData(
  //       "api/edit-profile",
  //       {
  //         "request_type": "edit_profile",
  //         "user_handle": auth.user?.userHandle,
  //         "user_name": editNameCont.text.trim(),
  //         "tagline": editTagLine.text.trim(),
  //         "description": editDescriptionCont.text.trim(),
  //         "user_location": editLocationCont.text.trim(),
  //         "user_work": editWorkCont.text.trim(),
  //         'image_name':
  //             editProfileImage != null ? '$timestamp$imageTimestamp' : '',
  //         'cover_image_name':
  //             editCoverImage != null ? '$timestampCover$coverTimestamp' : '',
  //         'profile_null_by_user': imageNullByUser,
  //         'cover_null_by_user': coverNullByUser,
  //         'token': auth.user?.token,
  //       },
  //       showdialog: true);
  //   if (response.statusCode == 200) {
  //     coverNullByUser = true;
  //     imageNullByUser = true;
  //     if (editNameCont.text.isNotEmpty) {
  //       auth.profileModel?.userProfileDescription =
  //           editDescriptionCont.text.trim();
  //     }
  //     if (editTagLine.text.isNotEmpty) {
  //       auth.profileModel?.profileLocation = editLocationCont.text.trim();
  //     }
  //     if (editNameCont.text.isNotEmpty) {
  //       auth.user?.userName = editNameCont.text.trim();
  //       auth.profileModel?.userName = editNameCont.text.trim();
  //     }
  //     if (editWorkCont.text.isNotEmpty) {
  //       auth.profileModel?.profileWork = editWorkCont.text.trim();
  //     }
  //
  //     auth.profileModel?.profileTagline = editTagLine.text.trim();
  //     final sharedPreferences = await SharedPreferences.getInstance();
  //
  //     sharedPreferences.setString(
  //         AppConstants().userdata, jsonEncode(auth.user));
  //     final json = response.body;
  //     Get.close(1);
  //     update();
  //   }
  // }
  Future<String?> editProfileImages(File? imageFile, String imageName) async {
    final timestamps = DateTime.now().millisecondsSinceEpoch;
    print(imageFile?.path);
    print('$timestamps$imageName');

    const url = 'http://sonata.seromatic.com:9501/api/upload-images';
    final dioInstance = Dio();

    try {
      final formData = dioFormData.FormData.fromMap({
        'request_type': 'edit_profile_image',
        'profile_image': await dioMultipartFile.MultipartFile.fromFile(
          imageFile!.path,
          filename: imageName,
        ),
        'image_name': '$timestamps$imageName',
      });

      final response = await dioInstance.post(url, data: formData);

      if (response.statusCode == 200) {
        imageNullByUser = false;
        coverNullByUser = false;
        print('Image uploaded successfully');
        return timestamps.toString();// Return the timestamp
      } else {
        print('Image upload failed with status ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
  Future<void> editProfileUser() async {
    final imageTimestamp = '${editProfileImage?.path.split('/').last ?? ''}';
    final timestamp = await editProfileImages(editProfileImage, imageTimestamp);
    final response = await api.postData(
        "api/edit-profile",
        {
          "request_type": "edit_profile",
          "user_handle": auth.user?.userHandle,
          "user_name": editNameCont.text.trim(),
          "description": editDescriptionCont.text.trim(),
          "user_location": editLocationCont.text.trim(),
          "user_work": editWorkCont.text.trim(),
          "tagline": editTagLine.text,
          'image_name':
              editProfileImage != null ? '$timestamp$imageTimestamp' : '',
          // 'cover_image_name':
          //     editCoverImage != null ? '$timestampCover$coverTimestamp' : '',
          'profile_null_by_user': imageNullByUser,
          'cover_null_by_user': coverNullByUser,
          'token': auth.user?.token,
        },
        showdialog: true);
    if (response.statusCode == 200) {
      // Update user profile information locally
      coverNullByUser = true;
      imageNullByUser = true;
      if (editNameCont.text.isNotEmpty) {
        auth.profileModel?.userProfileDescription = editDescriptionCont.text.trim();
      }
      if (editTagLine.text.isNotEmpty) {
        auth.profileModel?.profileLocation = editLocationCont.text.trim();
      }
      if (editNameCont.text.isNotEmpty) {
        auth.user?.userName = editNameCont.text.trim();
        auth.profileModel?.userName = editNameCont.text.trim();
      }
      if (editWorkCont.text.isNotEmpty) {
        auth.profileModel?.profileWork = editWorkCont.text.trim();
      }
      auth.profileModel?.profileTagline = editTagLine.text.trim();

      // Update the user data in SharedPreferences
      final sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(AppConstants().userdata, jsonEncode(auth.user));

      final json = response.body;

      // Close the dialog and update the UI
      Get.close(1);
      update();
    }
  }

  Future<void> editAccountInfo() async {
    final response = await api
        .postData(
      "api/edit-profile",
      {
        "request_type": "edit_account_info",
        "user_handle": auth.user?.userHandle,
        "user_name": editNameCont.text.trim(),
        "user_dob": dob,
        'token': auth.user?.token,
      },
      showdialog: true,
    )
        .catchError((error) {
      print("API Error: $error");
    });

    if (response.statusCode == 200) {
      final json = response.body;
      update();
    }
  }
}
