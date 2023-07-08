import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sonata/Controllers/auth_controller.dart';
import 'package:sonata/Views/Forgot%20Password/Forgot%20Password.dart';
import 'package:sonata/Views/Widgets/CustomButton.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';

import '../../Controllers/Auth/Auth Controller.dart';
import '../Explore(Without Login)/Explore.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final auth = Get.put(AuthController());
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  bool showError = false;
  bool _obscurePassword = true;
  bool _showEmailValidationError = false;
  bool _showPasswordValidationError = false;
  void initState() {
    super.initState();
    emailFocusNode.addListener(_onFocusChange);
    passwordFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    emailFocusNode.removeListener(_onFocusChange);
    passwordFocusNode.removeListener(_onFocusChange);

    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }
  void _validate() {
    setState(() {
      _showEmailValidationError = auth.emailContL.text.isEmpty;
      _showPasswordValidationError = auth.passContL.text.isEmpty;
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
                text: 'Welcome Back',
                fontColor: const Color(0xff3C0061),
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Chillax",
              ),
              SizedBox(
                height: 24.h,
              ),
              Center(child: Image.asset("assets/images/SignIn.png")),
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset("assets/svg/SignIn.svg"),
                              CustomText(
                                text: 'Sign In',
                                fontColor: const Color(0xff160323),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          height: 10.h,
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
                            color: emailFocusNode.hasFocus
                                ? Colors.white
                                : const Color(0xffFAFAFD),                            border: Border.all(
                                width: 1, color: (emailFocusNode.hasFocus
                              ? const Color(0xff3C0061)
                              : const Color(0xffC6BEE3))),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            focusNode: emailFocusNode,
                            controller: auth.emailContL,
                            cursorColor: Color(0xff3C0061),
                            decoration:  InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintText: 'Enter your email address',
                              hintStyle: TextStyle(
                                  color: (emailFocusNode.hasFocus
                                      ? const Color(0xffBBBBBB)
                                      : const Color(0xff727272)),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.italic),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                _showEmailValidationError = false;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        if (_showEmailValidationError)
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/error.svg",
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Email is Required',
                                  style: TextStyle(
                                    color: Color(0xffDA0000),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 10.h,
                        ),
                        CustomText(
                          text: 'Password',
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
                            color: passwordFocusNode.hasFocus
                                ? Colors.white
                                : const Color(0xffFAFAFD),                            border: Border.all(
                              width: 1, color: (passwordFocusNode.hasFocus
                              ? const Color(0xff3C0061)
                              : const Color(0xffC6BEE3))),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            focusNode: passwordFocusNode,
                            controller: auth.passContL,
                            obscureText: _obscurePassword,
                            cursorColor: Color(0xff3C0061),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter your password';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintText: 'Enter your password',
                              hintStyle: TextStyle(
                                  color: (passwordFocusNode.hasFocus
                                      ? const Color(0xffBBBBBB)
                                      : const Color(0xff727272)),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.italic),
                              border: InputBorder.none,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscurePassword =
                                        !_obscurePassword; // Toggle password visibility
                                  });
                                },
                                child: Icon(
                                  _obscurePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xffD9D9D9),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _showPasswordValidationError = false;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        if (_showPasswordValidationError)
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/error.svg",
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Password is Required',
                                  style: TextStyle(
                                    color: Color(0xffDA0000),
                                    fontSize: 16..sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(const ForgetPassword());
                              },
                              child: CustomText(
                                text: 'Forgot Password?',
                                fontColor: const Color(0xff3C0061),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 80.h,
                        ),
                        Visibility(
                          visible: showError,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 16.0, top: 4.0, bottom: 4.0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(200, 0, 0, 0.06),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Row(
                              children: [
                                Center(
                                  child: SvgPicture.asset(
                                    "assets/svg/error.svg",
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                CustomText(
                                  text: 'Incorrect email or password',
                                  fontColor: const Color(0xffDA0000),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
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
                          text: "Sign in",
                          textColor: const Color(0xffFFFFFF),
                          textSize: 16.sp,
                          textFontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                          iconPath:
                            'assets/svg/Sign In.svg',
                          onPressed: () async {
                            setState(() {
                              showError = false;
                            });
                            _validate();
                            if (_showEmailValidationError) {
                              setState(() {
                                _showEmailValidationError = true;
                                _showPasswordValidationError = false;
                              });
                              return;
                            }
                            if (_showPasswordValidationError) {
                              setState(() {
                                _showEmailValidationError = false;
                                _showPasswordValidationError = true;
                              });
                              return;
                            } else {
                              try {
                                await auth.loginUser();
                              } catch (error) {
                                setState(() {
                                  showError = true;
                                });
                              }
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
    );
  }
}
