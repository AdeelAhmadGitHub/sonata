import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sonata/Views/Widgets/CustomButton.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  bool isPasswordStrong(String password) {
    return password.length >= 8 && // at least 8 characters
        password.contains(new RegExp(r'[A-Z]')) && // uppercase letters
        password.contains(new RegExp(r'[a-z]')) && // lowercase letters
        password.contains(new RegExp(r'[0-9]'));
    // && // numbers
    //     password.contains(
    //         new RegExp(r'[!@#$%^&*(),.?":{}|<>]')); // special characters
  }

  String _password = '';
  bool _isPasswordStrong = false;

  void _onPasswordChanged(String password) {
    setState(() {
      _password = password;
      _isPasswordStrong = isPasswordStrong(password);
    });
  }

  // String passwordStrength(String password) {
  //   if (password.isEmpty) {
  //     return 'Please enter a password';
  //   }
  //   if (password.length < 6) {
  //     return '';
  //   }
  //   if (password.length < 10) {
  //     return '';
  //   }
  //   return '';
  // }

  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  double passwordScore = 0;
  void _onNextPressed() {
    if (_password != confirmPassword.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      // TODO: navigate to the next screen
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget validationMessage = Container();
    if (_password.isNotEmpty) {
      if (_password.length < 8) {
        // Show validation message for password length
        validationMessage = Row(
          children: [
            Image.asset(
              "assets/icons/incorrect password.png",
              height: 18,
              width: 20,
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Password must be at least 8 characters long',
                style: TextStyle(
                  color: Color(0xffDA0000),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ],
        );
      } else if (!_isPasswordStrong) {
        // Show validation message for password complexity
        validationMessage = Row(
          children: [
            Image.asset(
              "assets/icons/incorrect password.png",
              height: 18,
              width: 20,
            ),
            const SizedBox(width: 8),
            const Flexible(
              child: Text(
                'Password must contain at least one letter, one number, and one special character',
                style: TextStyle(
                  color: Color(0xffDA0000),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ],
        );
      } else {
        validationMessage = Container();
      }
    }

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
              Center(child: Image.asset("assets/icons/Sonata_Logo_Main.png")),
              SizedBox(
                height: 24.h,
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
                              Image.asset(
                                "assets/icons/key.png",
                                height: 32.h,
                                width: 32.w,
                              ),
                              SizedBox(
                                width: 9.w,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 2.0.h),
                                child: CustomText(
                                  text: 'Choose New Password',
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
                        validationMessage,
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomText(
                          text: 'Create New Password',
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
                            controller: newPassword,
                            keyboardType: TextInputType.text,
                            onChanged: _onPasswordChanged,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintText: 'Confirm New Password',
                              hintStyle: TextStyle(
                                color: Color(0xff8E8694),
                                fontSize: 15,
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.italic,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 11.h,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 4,
                              decoration: BoxDecoration(
                                color: _password.isEmpty
                                    ? const Color(0xffD9D9D9)
                                    : _isPasswordStrong
                                        ? Colors.green
                                        : _password.length < 8
                                            ? Colors.red
                                            : Colors.yellow,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Container(
                              width: 48,
                              height: 4,
                              decoration: BoxDecoration(
                                color: _password.isEmpty
                                    ? const Color(0xffD9D9D9)
                                    : _isPasswordStrong
                                        ? Colors.green
                                        : _password.length >= 8
                                            ? Colors.yellow
                                            : Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Container(
                              width: 48,
                              height: 4,
                              decoration: BoxDecoration(
                                color: _password.isEmpty
                                    ? const Color(0xffD9D9D9)
                                    : _isPasswordStrong
                                        ? Colors.green
                                        : _password.length >= 8
                                            ? Colors.yellow
                                            : Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Container(
                              width: 48,
                              height: 4,
                              decoration: BoxDecoration(
                                color: _password.isEmpty
                                    ? const Color(0xffD9D9D9)
                                    : _isPasswordStrong
                                        ? Colors.green
                                        : _password.length >= 8
                                            ? const Color(0xffD9D9D9)
                                            : Colors.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            CustomText(
                              text: _password.isEmpty
                                  ? ''
                                  : _isPasswordStrong
                                      ? 'Good'
                                      : 'Weak',
                              fontColor: const Color(0xff767676),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   height: 11.h,
                        // ),
                        // Visibility(
                        //   visible: !_isPasswordStrong,
                        //   child: CustomText(
                        //     text: 'Please choose a stronger password',
                        //     fontColor: const Color(0xffDE1414),
                        //     fontSize: 12.sp,
                        //     fontWeight: FontWeight.w500,
                        //     fontFamily: 'Poppins',
                        //   ),
                        // ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomText(
                          text: 'Confirm Password',
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
                            controller: confirmPassword,
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Create a handle';
                            //   }
                            //   return null;
                            // },
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintText: 'Confirm above entered password',
                              hintStyle: TextStyle(
                                  color: const Color(0xff8E8694),
                                  fontSize: 15.sp,
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.italic),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80.h,
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
                              if (_isPasswordStrong) {
                                if (newPassword.text == confirmPassword.text) {
                                  // auth.registerUser();
                                  _passwordsuccess(context);
                                } else {
                                  Get.snackbar(
                                      'Error', 'Passwords do not match');
                                }
                              } else {
                                Get.snackbar(
                                    'Error', 'Password is not strong enough');
                              }
                            })
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

  void _passwordsuccess(BuildContext context) {
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/icons/keyoutline.png",
                        height: 120.h,
                        width: 120.w,
                      ),
                    ),
                    Center(
                      child: CustomText(
                        text: 'Your password has been\nchanged successfully',
                        fontColor: const Color(0xff3C0061),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
