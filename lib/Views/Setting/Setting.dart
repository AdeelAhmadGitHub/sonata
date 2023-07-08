import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sonata/Views/Setting/Your%20Account/Reactivate%20Account/Reactivate%20Account.dart';
import '../../Controllers/auth_controller.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../SideBar/SideBar.dart';
import '../Widgets/custom_text.dart';
import 'Privacy Account/Privacy.dart';
import 'Security/Security.dart';
import 'Your Account/Your Account.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
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
                  Image.asset("assets/icons/Settings (1).png"),
                  SizedBox(
                    width: 10.w,
                  ),
                  CustomText(
                    text: 'Settings',
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
              Visibility(
                visible: auth.user?.accountStatus == 'active',
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const YourAccount();
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person_2_outlined,
                                color: Color(0xff777777),
                                size: 30,
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              CustomText(
                                text: 'Your Account',
                                fontColor: const Color(0xff444444),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                            color: Color(0xff444444),
                          )
                        ],
                      )),
                ),
              ),
              Visibility(
                visible: auth.user?.accountStatus != 'active',
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ReactivateAccount();
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person_2_outlined,
                                color: Color(0xff777777),
                                size: 30,
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              CustomText(
                                text: 'Your Account',
                                fontColor: const Color(0xff444444),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                            color: Color(0xff444444),
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(height: 8.h),
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Security();
                  }));
                },
                child: Visibility(
                  visible: auth.user?.accountStatus == 'active',
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.lock_outline_rounded,
                                color: Color(0xff777777),
                                size: 30,
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              CustomText(
                                text: 'Security',
                                fontColor: const Color(0xff444444),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                            color: Color(0xff444444),
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(height: 8.h),
              Visibility(
                visible: auth.user?.accountStatus == 'active',
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const PrivacyAccount();
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.privacy_tip_outlined,
                                color: Color(0xff777777),
                                size: 30,
                              ),
                              SizedBox(
                                width: 12.w,
                              ),
                              CustomText(
                                text: 'Privacy',
                                fontColor: const Color(0xff444444),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: 15,
                            color: Color(0xff444444),
                          )
                        ],
                      )),
                ),
              ),
              SizedBox(height: 8.h),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white, // #FFFFFF
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        width: 1.5, color: const Color(0xFFC6BEE3)), // #C6BEE3
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 25.w,
                            decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(2),
                                border: Border.all(
                                    width: 2, color: const Color(0xff777777))),
                            child: const Center(
                              child: Icon(
                                Icons.more_horiz,
                                color: Color(0xff777777),
                                size: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: 'Additional Resources',
                                fontColor: const Color(0xff444444),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 18.0.h),
                                child: CustomText(
                                  text:
                                      'About, Policies, Contact, Articles, Roadmap \n & Whitepaper',
                                  fontColor: const Color(0xff767676),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 18.0.h),
                            child: Image.asset("assets/icons/radix-icons.png",
                                color: const Color(0xff444444)),
                          ),
                        ],
                      ),
                    ],
                  )),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
