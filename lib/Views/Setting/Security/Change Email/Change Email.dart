import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../Controllers/auth_controller.dart';
import '../../../NaviationBar/NavigationBarScreen.dart';
import '../../../SideBar/SideBar.dart';
import '../../../Widgets/custom_text.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  var auth = Get.find<AuthController>();

  bool _validateEmail(String email) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _showCurrentEmailValidationError = false;
  bool _showNewEmailValidationError = false;

  void _validate() {
    setState(() {
      _showCurrentEmailValidationError = auth.currentEmail.text.isEmpty;
      _showNewEmailValidationError = auth.newEmail.text.isEmpty;
    });
  }

  bool _showError = true;

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
                    width: 20.w,
                  ),
                  CustomText(
                    text: 'Back to Security',
                    fontColor: const Color(0xff160323),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(width: 1, color: const Color(0xffF3EEF9))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          color: const Color(0xffFD5201),
                          size: 30,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        CustomText(
                          text: 'Change Email',
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
                        color: const Color(0xffF6F5FB)),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      text: 'Current Email',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Chillax",
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFD),
                        border: Border.all(
                            width: 1, color: const Color(0xffC6BEE3)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: auth.currentEmail,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintText: 'Enter your current email address',
                          hintStyle: TextStyle(
                            color: Color(0xff727272),
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _showCurrentEmailValidationError = false;
                          });
                        },
                        validator: (value) {
                          if (_showCurrentEmailValidationError &&
                              value!.isEmpty) {
                            return 'Current Email is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    if (_showCurrentEmailValidationError)
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/incorrect password.png",
                            height: 18,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              'Current Email is Required',
                              style: TextStyle(
                                color: Color(0xffDA0000),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomText(
                      text: 'New Email',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Chillax",
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFD),
                        border: Border.all(
                            width: 1, color: const Color(0xffC6BEE3)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: auth.newEmail,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintText: 'Enter new email address',
                          hintStyle: TextStyle(
                            color: Color(0xff727272),
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _showNewEmailValidationError = false;
                          });
                        },
                        validator: (value) {
                          if (_showNewEmailValidationError && value!.isEmpty) {
                            return 'New Email is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    if (_showNewEmailValidationError)
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/incorrect password.png",
                            height: 18,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          const Flexible(
                            child: Text(
                              'New Email is Required',
                              style: TextStyle(
                                color: Color(0xffDA0000),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 200.h,
                    ),
                    Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffF6F5FB)),
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
                                    fontSize: 14.sp,
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
                              onPressed: () {
                                setState(() {
                                  _showError = false;
                                });
                                _validate();
                                if (_showCurrentEmailValidationError) {
                                  setState(() {
                                    _showCurrentEmailValidationError = true;
                                    _showNewEmailValidationError = false;
                                  });
                                  return;
                                }
                                if (_showNewEmailValidationError) {
                                  setState(() {
                                    _showCurrentEmailValidationError = false;
                                    _showNewEmailValidationError = true;
                                  });
                                  return;
                                }
                                auth.changeEmail(context);
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
                                text: 'Continue',
                                fontColor: const Color(0xffFFFFFF),
                                fontSize: 14.sp,
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
            ],
          ),
        ),
      ),
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
}
