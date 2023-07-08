// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sonata/Views/Create%20Password/Create%20Password.dart';

import 'package:sonata/Views/Profile%20View/Profile%20View.dart';
import 'package:sonata/Views/Setting/Setting.dart';
import 'package:sonata/Views/Sign%20In/SignIn.dart';
import 'package:web_socket_channel/io.dart';

import '../Models/AuthModel.dart';
import '../Models/Explore Model/ExploreModel.dart';
import '../Models/Login Model/LoginModel.dart';
import '../Models/Other User Profile/Other User Profile.dart';
import '../Models/ProfileModel/ProfileModel.dart';
import '../Models/ProfileModel/UserRenotesModel.dart';
import '../Models/UserData.dart';
import '../Models/ProfileModel/UserNotesModel.dart';
import '../Models/getChannel Model.dart';
import '../Share Preferences/Share Preferences.dart';
import '../Views/Explore(Without Login)/Explore.dart';
import '../Views/NaviationBar/NavigationBarScreen.dart';
import '../Views/Profile/Profile.dart';
import '../Views/Set Up Profile/Set Up Profile.dart';
import '../Views/Setting/Account Info/Account Info.dart';
import '../Views/Setting/Your Account/Reactivate Account/Reactivate Account.dart';
import '../Views/User Agreement/User Agreement.dart';
import '../Views/Widgets/custom_text.dart';
import '../api/api_checker.dart';
import '../api/api_client.dart';
import '../utils/app_constants.dart';
import '../utils/functions.dart';

class AuthController extends GetxController {
  late SharedPreferences prefs;
  TextEditingController nameCont = TextEditingController(text: "");
  TextEditingController emailCont = TextEditingController(text: "");
  TextEditingController confirmPassCont = TextEditingController(text: "");
  TextEditingController currentPassCont = TextEditingController(text: "");
  TextEditingController userHandle = TextEditingController(text: '');
  TextEditingController createPassword = TextEditingController();
  /////////////////////////////////////////////////////////////////
  TextEditingController emailContL = TextEditingController(text: "");
  TextEditingController passContL = TextEditingController(text: "");
  //////////////////////////////////////////////////////////////////
  TextEditingController descriptionCont = TextEditingController(text: "");
  TextEditingController tagLine = TextEditingController(text: "");
  TextEditingController locationCont = TextEditingController(text: "");
  TextEditingController workCont = TextEditingController(text: "");
  TextEditingController currentEmail = TextEditingController(text: "");
  TextEditingController newEmail = TextEditingController(text: "");
  //////////////////////////////////////////////////////////////////
  TextEditingController label = TextEditingController(text: "");
  TextEditingController link = TextEditingController(text: "");
////////////////////////////////////////////////////////////////////
  TextEditingController labelEdited = TextEditingController(text: "");
  TextEditingController linkEdited = TextEditingController(text: "");
  int linkIdEdited = 0;
  ///////////////////////////////////////////
  bool showCookieAcceptImage = false;
  bool showCookieRejectImage = false;
  bool showAdvertisingPolicyAcceptImage = false;
  bool showAdvertisingPolicyRejectImage = false;
  ///////////////////////////////////////////
  String? token;
  String? dob;
  List<String> channelName = [];
  bool isLoading = false;
  UserData? user;
  RxBool showErrorHandle = RxBool(false);
  RxBool showErrorEmail = RxBool(false);
  RxBool showError = RxBool(false);
  // ProfileModel profileModel = ProfileModel();
  // RxList<ProfileModel> profile = <ProfileModel>[].obs;
  OtherUserProfileModel? otherUserProfileModel;
  ProfileModel? profileModel;
  AuthModel? authModel;
  AssociatedLinks? associatedLinks;
  ApiClient api = ApiClient(appBaseUrl: baseUrl);
  ApiChecker apichecker = ApiChecker();
  File? profileImage;
  String? selectedSort;
  RxList<ExploreModel> explore = <ExploreModel>[].obs;
  List<GetChannelMode> channels = [];
  dynamic channelIdCreatePost;
  final getChannel = false.obs;
  bool isRefresh = true;
  final uploadImage = false.obs;
  final showEmailError = false.obs;
  final showHandleError = false.obs;

  String profileImageUpload = '';
  String otherUserHandel = '';
  String? tokenSave="";
  @override
  Future<void> onInit() async {
    super.onInit();
    prefs = await SharedPreferences.getInstance();
  }

  Future getuserDetail() async {
    tokenMain = prefs.getString(AppConstants().token);
    token = prefs.getString(AppConstants().token);
    api.updateHeader(token ?? "token");
    print(jsonDecode(prefs.getString(AppConstants().userdata)!));
    try {
      user = UserData.fromJson(
          jsonDecode(prefs.getString(AppConstants().userdata)!));
    } catch (e) {
      Get.offAll(const SignIn());
      print(e);
    }
    update();
  }

  Future<Widget> checkUserLoggedIn() async {
    final SharedPreferences prefss = await SharedPreferences.getInstance();
    bool isLogin = (prefss.get(AppConstants().userdata) == null ? false : true);
    if (isLogin) {
      await getuserDetail();
      return const NavigationBarScreen();
    } else {
      return const Explore();
    }
  }

  Future<void> uploadProfileImage(File imageFile) async {
    print(imageFile.path);
    print("Handle: ${userHandle.text}");
    const apiUrl = 'http://192.168.18.89:9501/api/upload-images';
    try {
      final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.fields['request_type'] = 'create_profile_image';
      request.fields['user_handle'] = userHandle.text;

      final file =
          await http.MultipartFile.fromPath('profile_image', imageFile.path);
      request.files.add(file);

      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      print('Response: $responseString');
      if (response.statusCode == 200) {
        profileImageUpload = jsonDecode(responseString)['profile_image'];
        print('Image uploaded successfully!');
      } else {
        // Image upload failed
        print('Image upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future registerUser() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "register_user",
      "user_name": nameCont.text.trim(),
      "user_handle": userHandle.text.trim(),
      "user_email": emailCont.text.trim(),
      "conform_password": confirmPassCont.text.trim(),
      "user_dob": dob,
      "cookie_policy": showCookieAcceptImage ? "accept" : "reject",
      "ads_policy": showAdvertisingPolicyAcceptImage ? "accept" : "reject",
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
          prefs.setString(AppConstants().token, json["token"]);
          tokenSave = json["token"];
          // nameCont.clear();
          // confirmPassCont.clear();
          Get.to(const SetUpProfile());
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

  Future<void> adsPrivacyPolicy() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "privacy_policy",
      "user_handle": userHandle.text.trim(),
      "cookie_policy": true,
      "ads_policy": true,
      "token": user?.token ?? ""
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
          prefs.setString(AppConstants().token, json["token"]);
          tokenSave = json["token"];
          Get.to(const CreatePassword());
        } else {
          // Handle other status cases if needed
        }
      } catch (e) {
        // Handle parsing errors or unexpected message format
        print('Error parsing message: $e');
      }
    });

    // Remember to close the WebSocket connection when done
    // channel.sink.close();
  }



  Future<void> registerUserAuth() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "register_user_auth",
      "user_handle": userHandle.text.trim(),
      "user_email": emailCont.text.trim(),
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
        } else {
          Map<String, dynamic> json = jsonDecode(response.body);
          if (json.containsKey('msg')) {
            if (json['msg'] == 'Email already in use') {
              showEmailError.value = true;
              showHandleError.value = false;
            } else if (json['msg'] == 'Handle is not unique') {
              showEmailError.value = false;
              showHandleError.value = true;
            } else {
              showEmailError.value = false;
              showHandleError.value = false;
              errorAlert('Server Error!\nPlease try again...');
            }
          }
        }
        if (json.containsKey('msg')) {
          if (json['msg'] == 'Email already in use') {
            showEmailError.value = true;
            showHandleError.value = false;
          } else if (json['msg'] == 'Handle is not unique') {
            showEmailError.value = false;
            showHandleError.value = true;
          } else {
            showEmailError.value = false;
            showHandleError.value = false;
            Get.to(const UserAgreement());
          }
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

  Future registerUserInfo() async {
    print(channelName);
    print(profileImage);
    print("Token: $token");
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "register_user_info",
      "description": descriptionCont.text.trim(),
      "user_location": locationCont.text.trim(),
      "user_work": workCont.text.trim(),
      "registered_user_handle": userHandle.text.trim(),
      "registered_user_email": emailCont.text.trim(),
      "channels_name": channelName,
      "tagline": tagLine.text,
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
          descriptionCont.clear();
          locationCont.clear();
          workCont.clear();
          userHandle.clear();
          emailCont.clear();
          Map<String, dynamic> data = json;
          print("profileImageUpload");
          print(profileImageUpload);
          if (profileImageUpload != null) {
            data.addAll({'profile_image': profileImageUpload});
          }
          data.addAll({"token": tokenSave});
          print(data);
          onLoginSuccess(data);
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


  Future<dynamic> loginUser() async {
    final channel = IOWebSocketChannel.connect(
        'ws://192.168.18.89:9501');
    var appUsername = {
      "request_type": "login_user",
      "email": emailContL.text.trim(),
      "password": passContL.text.trim(),
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
          onLoginSuccess(json);
          emailContL.clear();
          passContL.clear();
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


  Future<void> userProfile() async {
    isLoading = true;
    showLoader();
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "view_profile",
      "user_handle": user?.userHandle ?? "",
      "other_user_handle": user?.userHandle ?? "",
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
        if (json != null) {
          profileModel = ProfileModel.fromJson(json);

          // Close the WebSocket connection and hide the loader
         // channel.sink.close();
          hideLoader();

          // Delay the navigation to the profile route to ensure it occurs after receiving the response
          Future.delayed(Duration.zero, () {
            Get.to(const Profile());
          });
        } else {
          // Handle other status cases if needed
        }
      } catch (e) {
        // Handle parsing errors or unexpected message format
        print('Error parsing message: $e');
      }
    });
  }



  Future<dynamic> otherUserserProfile() async {
  isLoading = true;
  showLoader();
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "view_profile",
      "user_handle": user?.userHandle ?? "",
      "other_user_handle": user?.userHandle ?? "",
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
        if (json != null) {
          profileModel = ProfileModel.fromJson(json);
          Get.to(const ProfileView());

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


  Future<dynamic> userAccountInfo() async {
    Response response = await api.postData(
        "api/profile",
        {
          "request_type": "view_profile",
          "user_handle": user?.userHandle ?? "",
          "other_user_handle": user?.userHandle ?? ""
        },
        showdialog: true);
    if (response == null) {
      errorAlert('Check your internet connection.');
    } else if (response.statusCode == 200) {
      profileModel = ProfileModel.fromJson(response.body);
      Get.to(const AccountInfo());
    } else {
      errorAlert('Server Error!\nPlease try again...');
    }
  }

  Future logoutUser() async {
    isLoading = true;
    showLoader();
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');
    var appUsername = {
      "request_type": "logout_user",
      "user_handle": user?.userHandle,
      "token": user?.token ?? ""
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
          logout();
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

        Future<bool> changePassword(BuildContext context) async {
    Response response = await api.postData(
      "api/change-password",
      {
        "request_type": "change_password",
        "user_ip": "",
        "user_handle": user?.userHandle ?? "",
        "current_password": currentPassCont.text.trim(),
        "conform_password": confirmPassCont.text.trim(),
        'token': user?.token ?? ""
      },
      showdialog: true,
    );

    if (response.statusCode == 200) {
      final json = response.body;
      currentPassCont.clear();
      confirmPassCont.clear();
      _showPasswordChanged(context);
      await Future.delayed(Duration(seconds: 2));
      logout();
      update();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changeEmail(BuildContext context) async {
    Response response = await api.postData(
        "api/change-email",
        {
          "request_type": "change_email",
          "user_ip": "",
          "user_handle": user?.userHandle ?? "",
          "current_email": currentEmail.text.trim(),
          "new_email": newEmail.text.trim(),
          'token': user?.token ?? ""
        },
        showdialog: false);
    if (response.statusCode == 200) {
      final json = response.body;
      currentEmail.clear();
      newEmail.clear();
      _showEmailChanged(context);
      await Future.delayed(Duration(seconds: 2));
      logout();
      update();
      return true; // Password change was successful
    } else {
      return false; // Password change failed
    }
  }

  Future createLink() async {
    print(link.text.trim());
    Response response = await api.postData(
      "api/create-link",
      {
        "request_type": "create_link",
        "user_handle": user?.userHandle ?? "",
        "link_label": label.text.trim(),
        "custom_link": link.text.trim(),
        "token": user?.token ?? ""
      },
    );
    if (response.statusCode == 200) {
      final json = response.body;
      print(json);
      Get.close(3);
      print("jfcienclijefcoielwf");

      update();
    }
  }

  Future EditLink() async {
    Response response = await api.postData(
      "api/edit-link",
      {
        "request_type": "create_link",
        "user_handle": user?.userName ?? "",
        "link_label": label.text.trim(),
        "custom_link": link.text.trim(),
        "token": user?.token ?? ""
      },
    );
    if (response.statusCode == 200) {
      final json = response.body;
      print(json);
      print("jfcienclijefcoielwf");

      update();
    }
  }

  Future deactivateActions() async {
    Response response = await api.postData(
      "api/profile/account-actions",
      {
        "request_type": "deactivate_account",
        "user_handle": user?.userHandle ?? "",
        "user_email": emailCont.text.trim(),
        "password": passContL.text.trim(),
        "token": user?.token ?? ""
      },
    );
    if (response.statusCode == 200) {
      emailCont.clear();
      passContL.clear();
      final json = response.body;
      logout();
      update();
    }
  }

  Future<dynamic> reactivateActions() async {
    Response response = await api.postData(
      "api/profile/account-actions",
      {
        "request_type": "reactivate_account",
        "user_handle": user?.userHandle ?? "",
        "user_email": emailContL.text.trim(),
        "password": passContL.text.trim(),
        "token": user?.token ?? ""
      },
    );
    if (response == null) {
      errorAlert('Check your internet connection.');
    } else if (response.statusCode == 200) {
      await prefs.setString(AppConstants().token, response.body["token"]);
      onLoginSuccess(response.body);
      // emailContL.clear();
      // passContL.clear();
    } else {
      errorAlert('Server Error!\nPlease try again...');
    }
  }

  // void onLoginSuccess(Map<String, dynamic> value) async {
  //   await prefs.setString(AppConstants().userdata, jsonEncode(value));
  //   await getuserDetail();
  //
  //   UserData userData = UserData.fromJson(value);
  //   if (userData.accountStatus == "active") {
  //     Get.offAll(const NavigationBarScreen());
  //   } else {
  //     Get.offAll(const Setting());
  //   }
  // }
  void onLoginSuccess(Map<String, dynamic> value) async {
    await prefs.setString(AppConstants().userdata, jsonEncode(value));
    await getuserDetail();
    update();
    Get.offAll(const NavigationBarScreen());
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(AppConstants().token);
    prefs.remove(AppConstants().userdata);
    Get.offAll(() => const Explore());
  }

  popDialog() {
    Get.defaultDialog(
      backgroundColor: Colors.white,
      buttonColor: Colors.white,
      title: "",
      content: WillPopScope(
          onWillPop: () => Future.value(false),
          child: const SpinKitSpinningLines(
            color: Color(0xff3C0061),
          )),
    );
  }

  void _showPasswordChanged(BuildContext context) {
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
                  Image.asset("assets/images/accountkey-outline.png"),
                  CustomText(
                    text: 'Your password has been\n changed successfully ',
                    fontColor: const Color(0xff3C0061),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    textAlign: TextAlign.center,
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

  void _showEmailChanged(BuildContext context) {
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
                  Image.asset("assets/icons/ic_outline-mark-email-unread.png"),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomText(
                    text: 'Verification email has been sent ',
                    fontColor: const Color(0xff3C0061),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomText(
                    text:
                        'You need to verify current email address in order to change it',
                    fontColor: const Color(0xff767676),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                    textAlign: TextAlign.center,
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
