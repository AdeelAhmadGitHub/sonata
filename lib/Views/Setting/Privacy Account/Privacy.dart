import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Controllers/auth_controller.dart';
import '../../NaviationBar/NavigationBarScreen.dart';
import '../../SideBar/SideBar.dart';
import '../../Widgets/custom_text.dart';

class PrivacyAccount extends StatefulWidget {
  const PrivacyAccount({Key? key}) : super(key: key);

  @override
  State<PrivacyAccount> createState() => _PrivacyAccountState();
}

class _PrivacyAccountState extends State<PrivacyAccount> {
  //bool showTermsAcceptImage = false;
  //bool showCookieAcceptImage = false;
  RxBool showPrivacyPolicyRejectImage = false.obs;
  RxBool showAdvertisingPolicyRejectImage = false.obs;
  RxBool showPrivacyPolicyAcceptImage = false.obs;
  RxBool showAdvertisingPolicyAcceptImage = false.obs;
// bool termsAccepted = false;
// bool cookieAccepted = false;
  RxBool showTermsAcceptImage = false.obs;
  RxBool showCookieAcceptImage = false.obs;
  RxBool showCookieRejectImage = false.obs;

  RxBool allTermsAccepted = false.obs;

  void updateAllTermsAccepted() {
    allTermsAccepted.value =
        showTermsAcceptImage.value && showCookieAcceptImage.value;
  }

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
                      child: const Icon(Icons.arrow_back)),
                  SizedBox(
                    width: 8.w,
                  ),
                  const Icon(
                    Icons.privacy_tip_outlined,
                    color: const Color(0xffFD5201),
                    size: 30,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  CustomText(
                    text: 'Privacy',
                    fontColor: const Color(0xff160323),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Chillax",
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              Container(
                  height: 1.h,
                  width: double.infinity.w,
                  color: const Color(0xffC6BEE3)),
              SizedBox(
                height: 20.h,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white, // #FFFFFF
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      width: 1.5, color: const Color(0xFFC6BEE3)), // #C6BEE3
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Cookie Policy',
                          fontColor: const Color(0xff444444),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Container(
                          height: 22.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFF3C0061), width: 1.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 4),
                              Image.asset("assets/icons/view.png"),
                              const SizedBox(width: 4),
                              CustomText(
                                text: 'View',
                                fontColor: const Color(0xff3C0061),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0.h),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              showCookieRejectImage.value = true;
                              showCookieAcceptImage.value = false;
                              updateAllTermsAccepted();
                            },
                            child: Obx(() => showCookieRejectImage.value
                                ? Image.asset('assets/icons/reject.png')
                                : CustomText(
                                    text: 'Reject',
                                    fontColor: const Color(0xffF22424),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Chillax",
                                  )),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          InkWell(
                            onTap: () {
                              showCookieAcceptImage.value = true;
                              showCookieRejectImage.value = false;
                            },
                            child: Obx(() => showCookieAcceptImage.value
                                ? Image.asset('assets/icons/accept.png')
                                : CustomText(
                                    text: 'Accept',
                                    fontColor: const Color(0xff3FAB2E),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Chillax",
                                  )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                decoration: BoxDecoration(
                  color: Colors.white, // #FFFFFF
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      width: 1.5, color: const Color(0xFFC6BEE3)), // #C6BEE3
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Targeted Ads Policy',
                          fontColor: const Color(0xff444444),
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Container(
                          height: 22.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(0xFF3C0061), width: 1.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 4),
                              Image.asset("assets/icons/view.png"),
                              const SizedBox(width: 4),
                              CustomText(
                                text: 'View',
                                fontColor: const Color(0xff3C0061),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0.h),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              showPrivacyPolicyRejectImage.value = true;
                              showPrivacyPolicyAcceptImage.value = false;
                              updateAllTermsAccepted();
                            },
                            child: Obx(() => showPrivacyPolicyRejectImage.value
                                ? Image.asset('assets/icons/reject.png')
                                : CustomText(
                                    text: 'Reject',
                                    fontColor: const Color(0xffF22424),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Chillax",
                                  )),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          InkWell(
                            onTap: () {
                              showPrivacyPolicyAcceptImage.value = true;
                              showPrivacyPolicyRejectImage.value = false;
                            },
                            child: Obx(() => showPrivacyPolicyAcceptImage.value
                                ? Image.asset('assets/icons/accept.png')
                                : CustomText(
                                    text: 'Accept',
                                    fontColor: const Color(0xff3FAB2E),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Chillax",
                                  )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
