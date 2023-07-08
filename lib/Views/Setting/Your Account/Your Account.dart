import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../Controllers/auth_controller.dart';
import '../../NaviationBar/NavigationBarScreen.dart';
import '../../SideBar/SideBar.dart';
import '../../Widgets/custom_text.dart';
import '../Account Info/Account Info.dart';
import 'Deactive Account/deactive Account.dart';

class YourAccount extends StatefulWidget {
  const YourAccount({Key? key}) : super(key: key);

  @override
  State<YourAccount> createState() => _YourAccountState();
}

class _YourAccountState extends State<YourAccount> {
  var auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      backgroundColor: const Color(0xffE3E3E3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(right: 12.0, left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.to(const NavigationBarScreen());
                },
                child: SvgPicture.asset(
                  "assets/svg/Sonata_Logo_Main_RGB.svg",
                ),
              ),
              Builder(
                builder: (BuildContext context) => InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: auth.user?.profileImage != null
                          ? Image.network(
                              String.fromCharCodes(
                                  base64Decode(auth.user?.profileImage ?? "")),
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                print('Error loading image: $exception');
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
              )
            ],
          ),
        ),
        elevation: 0.0,
        backgroundColor: const Color(0xff3C0061),
        toolbarHeight: 78.h,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back)),
                  SizedBox(
                    width: 20.w,
                  ),
                  Image.asset("assets/icons/color account.png"),
                  SizedBox(
                    width: 10.w,
                  ),
                  CustomText(
                    text: 'Your Account',
                    fontColor: const Color(0xff160323),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Chillax",
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                  height: 1.h,
                  width: double.infinity.w,
                  color: const Color(0xffC6BEE3)),
              SizedBox(height: 16.h),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AccountInfo();
                  }));
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white, // #FFFFFF
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 1.5,
                          color: const Color(0xFFC6BEE3)), // #C6BEE3
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset("assets/icons/Account Information.png"),
                            SizedBox(
                              width: 10.w,
                            ),
                            CustomText(
                              text: 'Account Information',
                              fontColor: const Color(0xff444444),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              text:
                                  'See your account information like Email and Location',
                              fontColor: const Color(0xff767676),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const DeactivateAccount();
                  }));
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.white, // #FFFFFF
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          width: 1.5,
                          color: const Color(0xFFC6BEE3)), // #C6BEE3
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset("assets/icons/Deactivate Account.png"),
                            SizedBox(
                              width: 10.w,
                            ),
                            CustomText(
                              text: 'Deactivate Account',
                              fontColor: const Color(0xff444444),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomText(
                              text: 'Deactivate your account',
                              fontColor: const Color(0xff767676),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
