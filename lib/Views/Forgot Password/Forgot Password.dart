import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sonata/Views/New%20Password/New%20Password.dart';
import 'package:sonata/Views/Widgets/CustomButton.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController forgotPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 34.h,
                ),
                Center(
                  child: SvgPicture.asset("assets/svg/Sonata_Logo_Main_.svg"),
                ),
                SizedBox(
                  height: 24.h,
                ),
                SizedBox(
                  width: 10.w,
                ),
                CustomText(
                  text: 'Forgot Password?',
                  fontColor: const Color(0xff3C0061),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Chillax",
                ),
                SizedBox(
                  height: 10.h,
                ),
                Center(child: Image.asset("assets/images/password.png")),
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
                                SvgPicture.asset(
                                    "assets/svg/mdi_password-reset.svg"),
                                SizedBox(
                                  width: 9.w,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2.0.h),
                                  child: CustomText(
                                    text: 'Recover Account',
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
                            height: 20.h,
                          ),
                          CustomText(
                            text: 'Email',
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
                              controller: forgotPassword,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter your email address';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(16, 10, 16, 10),
                                hintText: 'Enter your email address',
                                hintStyle: TextStyle(
                                    color: Color(0xff8E8694),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.italic),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 110.h,
                          ),
                          Container(
                            height: 1.h,
                            width: double.infinity.w,
                            color: const Color(0xffF6F5FB),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomButton(
                            height: 48.h,
                            borderRadius: (8),
                            buttonColor: const Color(0xff3C0061),
                            width: double.infinity,
                            text: "Submit",
                            textColor: const Color(0xffFFFFFF),
                            textSize: 16.sp,
                            textFontWeight: FontWeight.w600,
                            fontFamily: "Chillax",
                            onPressed: () {
                              if (forgotPassword.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter your email'),
                                  ),
                                );
                              } else {
                                Get.to(const NewPassword());
                              }
                            },
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
      ),
    );
  }
}
