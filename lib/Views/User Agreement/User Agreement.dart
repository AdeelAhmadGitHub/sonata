import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';

import '../../Controllers/auth_controller.dart';
import '../Create Password/Create Password.dart';
import '../Explore(Without Login)/Explore.dart';

class UserAgreement extends StatefulWidget {
  const UserAgreement({Key? key}) : super(key: key);

  @override
  State<UserAgreement> createState() => _UserAgreementState();
}

class _UserAgreementState extends State<UserAgreement> {
  final auth = Get.put(AuthController());
  bool showTermsAcceptImage = false;
  bool showCookieAcceptImage = false;
  bool showCookieRejectImage = false;
  bool showPrivacyAcceptImage = false;
  bool showAdvertisingPolicyRejectImage = false;
  bool showAdvertisingPolicyAcceptImage = false;
  bool allTermsAccepted = false;
  bool areAllTermsAccepted() {
    return (showTermsAcceptImage &&
            showPrivacyAcceptImage &&
        auth.showCookieAcceptImage) ||
        (auth.showCookieRejectImage && auth.showAdvertisingPolicyAcceptImage) ||
        auth.showAdvertisingPolicyRejectImage;
  }

  void updateAllTermsAccepted() {
    setState(() {
      allTermsAccepted = areAllTermsAccepted();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 34.h,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(Explore());
                },
                child: Center(
                  child: SvgPicture.asset("assets/svg/Sonata_Logo_Main_.svg"),
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              CustomText(
                text: 'We believe in transparency',
                fontColor: const Color(0xff3C0061),
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Chillax",
              ),
              SizedBox(
                height: 40.h,
              ),
              Center(child: Image.asset("assets/images/User Agreement.png")),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  width: double.infinity.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(60, 0, 97, 0.08),
                        blurRadius: 12,
                        offset: Offset(0, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 44,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFF6F5FB),
                                width: 1,
                              ),
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                "assets/icons/Doc Sign.png",
                                height: 32.h,
                                width: 32.w,
                              ),
                              SizedBox(
                                width: 9.w,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 2.0.h),
                                child: CustomText(
                                  text: 'User Agreement',
                                  fontColor: const Color(0xff160323),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Chillax",
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        CustomText(
                          text:
                              'Read the following policies in full before tapping on the agree button',
                          fontColor: const Color(0xff767676),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Terms of Use',
                                  fontColor: const Color(0xff444444),
                                  fontSize: 18.sp,
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
                                        color: const Color(0xFF3C0061),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                  CustomText(
                                    text: 'Reject',
                                    fontColor: const Color(0xffBBBBBB),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Chillax",
                                  ),
                                  SizedBox(
                                    width: 26.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showTermsAcceptImage = true;
                                      });
                                      updateAllTermsAccepted();
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: showTermsAcceptImage
                                        ? Image.asset(
                                            'assets/icons/accept.png',
                                            height: 30.h,
                                            width: 34.w,
                                          )
                                        : CustomText(
                                            text: 'Accept',
                                            fontColor: const Color(0xff3FAB2E),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Chillax",
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: const Color(0xffE7E7E7),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Privacy Policy',
                                  fontColor: const Color(0xff444444),
                                  fontSize: 18.sp,
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
                                        color: const Color(0xFF3C0061),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                  CustomText(
                                    text: 'Reject',
                                    fontColor: const Color(0xffBBBBBB),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Chillax",
                                  ),
                                  SizedBox(
                                    width: 26.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        showPrivacyAcceptImage = true;
                                      });
                                      updateAllTermsAccepted();
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    child: showPrivacyAcceptImage
                                        ? Image.asset('assets/icons/accept.png')
                                        : CustomText(
                                            text: 'Accept',
                                            fontColor: const Color(0xff3FAB2E),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Chillax",
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: const Color(0xffE7E7E7),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Cookie Policy',
                                  fontColor: const Color(0xff444444),
                                  fontSize: 18.sp,
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
                                        color: const Color(0xFF3C0061),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                      setState(() {
                                        auth.showCookieRejectImage = true;
                                        auth.showCookieAcceptImage = false;
                                      });
                                      updateAllTermsAccepted();
                                    },
                                    child: auth.showCookieRejectImage
                                        ? Image.asset('assets/icons/reject.png')
                                        : CustomText(
                                            text: 'Reject',
                                            fontColor: const Color(0xffF22424),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Chillax",
                                          ),
                                  ),
                                  SizedBox(
                                    width: 26.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        auth. showCookieAcceptImage = true;
                                        auth. showCookieRejectImage = false;
                                      });
                                    },
                                    child: auth.showCookieAcceptImage
                                        ? Image.asset('assets/icons/accept.png')
                                        : CustomText(
                                            text: 'Accept',
                                            fontColor: const Color(0xff3FAB2E),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Chillax",
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: const Color(0xffE7E7E7),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Advertising Policy',
                                  fontColor: const Color(0xff444444),
                                  fontSize: 18.sp,
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
                                        color: const Color(0xFF3C0061),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                      setState(() {
                                        auth.showAdvertisingPolicyRejectImage = true;
                                        auth. showAdvertisingPolicyAcceptImage =
                                            false;
                                      });
                                      updateAllTermsAccepted();
                                    },
                                    child: auth.showAdvertisingPolicyRejectImage
                                        ? Image.asset('assets/icons/reject.png')
                                        : CustomText(
                                            text: 'Reject',
                                            fontColor: const Color(0xffF22424),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Chillax",
                                          ),
                                  ),
                                  SizedBox(
                                    width: 26.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        auth.showAdvertisingPolicyAcceptImage = true;
                                        auth.showAdvertisingPolicyRejectImage =
                                            false;
                                      });
                                      updateAllTermsAccepted();
                                    },
                                    child: auth.showAdvertisingPolicyAcceptImage
                                        ? Image.asset('assets/icons/accept.png')
                                        : CustomText(
                                            text: 'Accept',
                                            fontColor: const Color(0xff3FAB2E),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Chillax",
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: const Color(0xffE7E7E7),
                        ),
                        SizedBox(
                          height: 17.h,
                        ),
                        Container(
                          height: 1.h,
                          width: double.infinity.w,
                          color: const Color(0xffF6F5FB),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          height: 48.h,
                          child: ElevatedButton(
                            onPressed: allTermsAccepted
                                ? () {
                                    Get.to(const CreatePassword());
                                  }
                                : null,
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: allTermsAccepted
                                  ? const Color(0xff3C0061)
                                  : const Color(0xffDFDFDF),
                            ),
                            child: Center(
                              child: CustomText(
                                text: 'Continue',
                                fontColor: allTermsAccepted
                                    ? const Color(0xffFFFFFF)
                                    : const Color(0xffFFFFFF).withOpacity(.5),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
