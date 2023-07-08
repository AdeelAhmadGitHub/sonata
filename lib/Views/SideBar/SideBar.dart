import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sonata/Views/Explore%20Navigation/Explore%20Navigation.dart';

import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/ProfileController/ProfileController.dart';
import '../../Controllers/auth_controller.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../Profile View/Profile View.dart';
import '../Profile/Profile.dart';
import '../Save Notes/Save Notes.dart';
import '../Setting/Setting.dart';
import '../Widgets/custom_text.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  var auth = Get.find<AuthController>();
  var home = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 240.w,
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                            child: Container(
                              height: 80.h,
                              width: 80.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: auth.user?.profileImage != null
                                    ? Image.network(
                                        String.fromCharCodes(base64Decode(
                                            auth.user?.profileImage ?? "")),
                                        fit: BoxFit.cover,
                                        errorBuilder: (BuildContext context,
                                            Object exception,
                                            StackTrace? stackTrace) {
                                          print(
                                              'Error loading image: $exception');
                                          return SvgPicture.asset(
                                            "assets/svg/UserProfile.svg",
                                          );
                                        },
                                      )
                                    : SvgPicture.asset(
                                        "assets/svg/UserProfile.svg",
                                        height: 50,
                                        width: 50,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 128.w,
                          top: 32.h,
                          child: Container(
                            width: 15.w,
                            height: 15.h,
                            decoration: BoxDecoration(
                              color: const Color(0xff37D300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: auth.user?.userName,
                        fontColor: const Color(0xff160323),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Chillax",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        text: "@${auth.user?.userHandle}",
                        fontColor: const Color(0xff3C0061),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Chillax",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Container(
                    height: 1.h,
                    width: double.infinity.w,
                    color: const Color(0xffE7E7E7),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Visibility(
                    visible: auth.user?.accountStatus == 'active',
                    child: GestureDetector(
                      onTap: () {
                        navigateHome=true;
                        home.otherHandle = auth.user?.userHandle;
                        otherUserHandel = auth.user?.userHandle ?? "";
                        auth.otherUserHandel = auth.user?.userHandle ?? "";
                        auth.userProfile();
                      },
                      child: Row(
                        children: [
                          Image.asset("assets/icons/ProfileDraw.png"),
                          SizedBox(
                            width: 14.w,
                          ),
                          CustomText(
                            text: 'Profile',
                            fontColor: const Color(0xff444444),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Chillax",
                          ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 30.h,
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(context,
                  //         MaterialPageRoute(builder: (context) {
                  //       return const ExploreNavigation();
                  //     }));
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Image.asset("assets/icons/ExploreDraw.png"),
                  //       SizedBox(
                  //         width: 14.w,
                  //       ),
                  //       CustomText(
                  //         text: 'Explore',
                  //         fontColor: const Color(0xff444444),
                  //         fontSize: 18.sp,
                  //         fontWeight: FontWeight.w500,
                  //         fontFamily: "Chillax",
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Visibility(
                    visible: auth.user?.accountStatus == 'active',
                    child: GestureDetector(
                      onTap: () {
                        navigateHome=true;
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SaveNotes();
                        }));
                      },
                      child: Row(
                        children: [
                          Image.asset("assets/icons/Save Note Draw.png"),
                          SizedBox(
                            width: 14.w,
                          ),
                          CustomText(
                            text: 'Saved Notes',
                            fontColor: const Color(0xff444444),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Chillax",
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  InkWell(
                    onTap: () {
                      navigateHome=true;
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const Setting();
                      }));
                    },
                    child: Row(
                      children: [
                        Image.asset("assets/icons/Settings.png"),
                        SizedBox(
                          width: 14.w,
                        ),
                        CustomText(
                          text: 'Settings',
                          fontColor: const Color(0xff444444),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200.h,
                  ),
                  InkWell(
                    onTap: () {
                      logout(context);
                    },
                    child: Row(
                      children: [
                        Image.asset("assets/icons/Logout.png"),
                        SizedBox(
                          width: 14.w,
                        ),
                        CustomText(
                          text: 'Logout',
                          fontColor: const Color(0xff444444),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    showModalBottomSheet(
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Image.asset(
                        "assets/icons/Logout Icon.png",
                        height: 120.h,
                        width: 120.w,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: CustomText(
                        text: 'Are you sure you want to logout?',
                        fontColor: const Color(0xff3C0061),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 2.h,
                      width: double.infinity.w,
                      color: const Color(0xffE7E7E7),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44.h,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF3C0061),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: 'Cancel',
                                    fontColor: const Color(0xff3C0061),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 44.h,
                            child: ElevatedButton(
                              onPressed: () async {
                                await Get.find<AuthController>().logoutUser();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xFF3C0061),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 10.0, 12.0, 10.0),
                              ),
                              child: CustomText(
                                text: 'Logout',
                                fontColor: const Color(0xffFFFFFF),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
