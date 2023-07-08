// ignore_for_file: unnecessary_null_comparison
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sonata/Views/Profile%20View/Profile%20View.dart';
import 'package:sonata/Views/Setting/Setting.dart';
import 'package:sonata/Views/Sign%20In/SignIn.dart';
import 'package:sonata/api/ws_api_client.dart' as ws;
import 'package:sonata/api/ws_api_client.dart';
import 'package:web_socket_channel/io.dart';

import '../../Models/AuthModel.dart';
import '../../Models/Explore Model/ExploreModel.dart';
import '../../Models/Other User Profile/Other User Profile.dart';
import '../../Models/ProfileModel/ProfileModel.dart';
import '../../Models/UserData.dart';
import '../../Models/getChannel Model.dart';
import '../../Views/Explore(Without Login)/Explore.dart';
import '../../Views/NaviationBar/NavigationBarScreen.dart';
import '../../Views/Widgets/custom_text.dart';
import '../../utils/app_constants.dart';
import '../../utils/functions.dart';
class AuthControllers extends GetxController {
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
  String? token;
  String? dob;
  List<String> channelName = [];
  bool isLoading = false;
  bool isRefresh = true;
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
  ApiClientWs apis = ApiClientWs(appBaseUrl: 'ws://sonata.seromatic.com:9501');
  // ApiChecker apichecker = ApiChecker();
  // ApiClient api = ApiClient(appBaseUrl: baseUrl);
  File? profileImage;
  String? selectedSort;
  RxList<ExploreModel> explore = <ExploreModel>[].obs;
  List<GetChannelMode> channels = [];
  dynamic channelIdCreatePost;
  final getChannel = false.obs;
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
    apis.updateHeader(token ?? "token");
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


  Future<dynamic> loginUser() async {
    final channel = IOWebSocketChannel.connect('ws://sonata.seromatic.com:9501');

    var appUsername = {
      "request_type": "login_user",
      "email": emailContL.text.trim(),
      "password": passContL.text.trim(),
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
    });
    Future<void> exploreUserLogin() async {
    //  lengthExploreList = 0;
      var response = await apis.postData(
          {
            "request_type": "explore_feeds",
            "user_handle": user?.userHandle ?? "",
            "page": "1",
            "timezone": "Asia/Karachi",
          },
          showdialog: isRefresh);
      if (response.statusCode == 200) {
        final json = response.body;
        // if (isRefreshApi) {
        //   explore = <ExploreModel>[].obs;
        // }
        json.forEach((v) {
         // lengthExploreList++;
          explore.add(ExploreModel.fromJson(v));
        });
        update();
      }
    }
    // Remember to close the WebSocket connection when done
    // channel.sink.close();
  }
  // Future<dynamic> loginUser() async {
  //   Response response = await api.postData(
  //     "api/login",
  //     {
  //       "request_type": "login_user",
  //       "email": emailContL.text.trim(),
  //       "password": passContL.text.trim(),
  //     },
  //   );
  //   if (response == null) {
  //     errorAlert('Check your internet connection.');
  //   } else if (response.statusCode == 200) {
  //     // await prefs.setString(AppConstants().token, response.body["token"]);
  //     onLoginSuccess(response.body);
  //     emailContL.clear();
  //     passContL.clear();
  //   } else {
  //     errorAlert('Server Error!\nPlease try again...');
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
    if (isLoading) {
      Get.dialog(Dialog(
        elevation: 0,
        // surfaceColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: AnimatedCircleAnimations(),
      ));
    }
  }

  void hideLoader() {
    Get.back();
  }
}
