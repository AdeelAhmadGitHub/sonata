import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../Controllers/auth_controller.dart';
import '../../../NaviationBar/NavigationBarScreen.dart';
import '../../../SideBar/SideBar.dart';
import '../../../Widgets/custom_text.dart';

class ChangePasswordAccount extends StatefulWidget {
  const ChangePasswordAccount({Key? key}) : super(key: key);

  @override
  State<ChangePasswordAccount> createState() => _ChangePasswordAccountState();
}

class _ChangePasswordAccountState extends State<ChangePasswordAccount> {
  bool isPasswordStrong(String password) {
    return password.length >= 8 && // at least 8 characters
        password.contains(new RegExp(r'[A-Z]')) && // uppercase letters
        password.contains(new RegExp(r'[a-z]')) && // lowercase letters
        password.contains(new RegExp(r'[0-9]')) && // numbers
        password.contains(
            new RegExp(r'[!@#$%^&*(),.?":{}|<>]')); // special characters
  }

  String _password = '';
  bool _isPasswordStrong = true;
  bool _currentPassword = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _onPasswordChanged(String password) {
    _showCreatePasswordValidationError = false;
    setState(() {
      _password = password;
      if (password.isEmpty) {
        _isPasswordStrong = true;
      } else {
        _isPasswordStrong = isPasswordStrong(password);
      }
    });
  }

  String passwordStrength(String password) {
    if (password.isEmpty) {
      return 'Please enter a password';
    }
    if (password.length < 4) {
      return '';
    }
    if (password.length < 10) {
      return '';
    }
    return '';
  }

  String validationMessage = '';

  double passwordScore = 0;
  bool _showError = true;
  var auth = Get.find<AuthController>();
  bool _showCurrentPasswordValidationError = false;
  bool _showCreatePasswordValidationError = false;
  bool _showCreatePasswordLengthValidationError = false;
  bool _buttonClicked = false;
  bool _showConfirmPasswordValidationError = false;
  bool _passwordNotMatch = false;
  bool _currentPasswordNotMatch = false;
  bool _currentPasswordNotMatchWithCreatePassword = false;

  void _validate() {
    setState(() {
      _showCurrentPasswordValidationError = auth.currentPassCont.text.isEmpty;
      _showCreatePasswordValidationError = auth.createPassword.text.isEmpty;
      _showConfirmPasswordValidationError = auth.confirmPassCont.text.isEmpty;
      if (!_showCreatePasswordValidationError &&
          auth.createPassword.text.length < 4) {
        _showCreatePasswordLengthValidationError = true;
        _buttonClicked = true;
      } else {
        _showCreatePasswordLengthValidationError = false;
      }
      if (auth.createPassword.text != auth.confirmPassCont.text) {
        _passwordNotMatch = true;
      } else {
        _passwordNotMatch = false;
      }
      if (auth.currentPassCont.text == auth.confirmPassCont.text) {
        _currentPasswordNotMatchWithCreatePassword = true;
      } else {
        _currentPasswordNotMatchWithCreatePassword = false;
      }
    });
  }

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
                        Image.asset(
                          "assets/icons/key-outline.png",
                          color: const Color(0xffFD5201),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        CustomText(
                          text: 'Change Password',
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
                      text: 'Current Password',
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
                            width: 1,
                            color: _showCurrentPasswordValidationError
                                ? const Color(0xffDA0000)
                                : const Color(0xffC6BEE3)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: auth.currentPassCont,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintText: 'Enter your current password',
                          hintStyle: TextStyle(
                              color: Color(0xff8E8694),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _showCurrentPasswordValidationError = false;
                            if (_buttonClicked && value.length >= 4) {
                              _showCreatePasswordLengthValidationError =
                                  false; // Reset the flag
                            } else {
                              _showCreatePasswordLengthValidationError =
                                  false; // Set the flag if password length is less than 4
                            }
                          });
                        },
                        validator: (value) {
                          if (_showCreatePasswordValidationError &&
                              value!.isEmpty) {
                            return 'Current Password is required';
                          }

                          if (_buttonClicked &&
                              (_showCreatePasswordLengthValidationError ||
                                  value!.length < 4)) {
                            return 'Password is required and must be at least 4 characters long';
                          }

                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    if (_showCurrentPasswordValidationError)
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/incorrect password.png",
                            height: 18,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Current Password is Required',
                              style: TextStyle(
                                color: Color(0xffDA0000),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ],
                      ),
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
                        controller: auth.createPassword,
                        keyboardType: TextInputType.text,
                        onChanged: _onPasswordChanged,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintText: 'Create a secure password',
                          hintStyle: TextStyle(
                            color: Color(0xff8E8694),
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        validator: (value) {
                          if (_showCreatePasswordValidationError &&
                              _showCreatePasswordLengthValidationError &&
                              value!.isEmpty) {
                            return 'Current Password is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    if (_showCreatePasswordValidationError)
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/incorrect password.png",
                            height: 18,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'New Password is Required',
                              style: TextStyle(
                                color: Color(0xffDA0000),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (_buttonClicked &&
                        (_showCreatePasswordLengthValidationError ||
                            _password.length < 4))
                      Row(
                        children: [
                          Image.asset(
                            "assets/icons/incorrect password.png",
                            height: 18,
                            width: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'Password must be at least 4 characters long',
                              style: TextStyle(
                                color: Color(0xffDA0000),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ],
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
                                  ? 'Strong'
                                  : _password.length >= 8
                                      ? 'Good'
                                      : 'Weak',
                          fontColor: const Color(0xff767676),
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 11.h,
                    ),
                    Visibility(
                      visible: !_isPasswordStrong,
                      child: CustomText(
                        text: 'Please choose a stronger password',
                        fontColor: const Color(0xffDE1414),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      text: "Confirm New Password",
                      fontColor: const Color(0xff444444),
                      fontSize: 14.sp,
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
                            width: 1,
                            color: _showConfirmPasswordValidationError
                                ? const Color(0xffDA0000)
                                : const Color(0xffC6BEE3)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: auth.confirmPassCont,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintText: 'Create a secure password',
                          hintStyle: TextStyle(
                              color: Color(0xff8E8694),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _showConfirmPasswordValidationError = false;
                          });
                        },
                        validator: (value) {
                          if (_showConfirmPasswordValidationError &&
                              value!.isEmpty) {
                            return 'Confirm Password is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    if (_showConfirmPasswordValidationError)
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
                              'Confirm Password is Required',
                              style: TextStyle(
                                color: Color(0xffDA0000),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 50.h,
                    ),
                    if (_passwordNotMatch)
                      Container(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 4.0, bottom: 4.0),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(200, 0, 0, 0.06),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Row(
                          children: [
                            Center(
                              child: Image.asset(
                                "assets/icons/incorrect password.png",
                                height: 18.h,
                                width: 20.w,
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            CustomText(
                              text: 'Passwords must match',
                              fontColor: const Color(0xffDA0000),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                      ),
                    if (_currentPasswordNotMatchWithCreatePassword)
                      Container(
                        padding: const EdgeInsets.only(
                            left: 16.0, top: 4.0, bottom: 4.0),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(200, 0, 0, 0.06),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Row(
                          children: [
                            Center(
                              child: Image.asset(
                                "assets/icons/incorrect password.png",
                                height: 18.h,
                                width: 20.w,
                              ),
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Flexible(
                              child: CustomText(
                                text:
                                    'new password must be different from current password',
                                fontColor: const Color(0xffDA0000),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 15.h,
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
                              onPressed: () async {
                                // setState(() {
                                //   _showError = false;
                                // });
                                _validate();
                                if (_showCurrentPasswordValidationError) {
                                  setState(() {
                                    _showCurrentPasswordValidationError = true;
                                    _showCreatePasswordValidationError = false;
                                    _showConfirmPasswordValidationError = false;
                                    _showCreatePasswordLengthValidationError =
                                        false;
                                    _passwordNotMatch = false;
                                    _currentPasswordNotMatch = false;
                                    _currentPasswordNotMatchWithCreatePassword =
                                        false;
                                  });
                                  return;
                                }

                                if (_showCreatePasswordValidationError) {
                                  setState(() {
                                    _showCurrentPasswordValidationError = false;
                                    _showCreatePasswordValidationError = true;
                                    _showConfirmPasswordValidationError = false;
                                    _showCreatePasswordLengthValidationError =
                                        false;
                                    _passwordNotMatch = false;
                                    _currentPasswordNotMatch = false;
                                    _currentPasswordNotMatchWithCreatePassword =
                                        false;
                                  });
                                  return;
                                }
                                if (_buttonClicked &&
                                    (_showCreatePasswordLengthValidationError ||
                                        _password.length < 4)) {
                                  setState(() {
                                    _showCurrentPasswordValidationError = false;
                                    _showCreatePasswordValidationError = false;
                                    _showConfirmPasswordValidationError = false;
                                    _showCreatePasswordLengthValidationError =
                                        true;
                                    _passwordNotMatch = false;
                                    _currentPasswordNotMatch = false;
                                    _currentPasswordNotMatchWithCreatePassword =
                                        false;
                                  });
                                  return;
                                }
                                if (_showConfirmPasswordValidationError) {
                                  setState(() {
                                    _showCurrentPasswordValidationError = false;
                                    _showCreatePasswordValidationError = false;
                                    _showConfirmPasswordValidationError = true;
                                    _showCreatePasswordLengthValidationError =
                                        false;
                                    _passwordNotMatch = false;
                                    _currentPasswordNotMatch = false;
                                    _currentPasswordNotMatchWithCreatePassword =
                                        false;
                                  });
                                  return;
                                }

                                if (_passwordNotMatch) {
                                  setState(() {
                                    _showCurrentPasswordValidationError = false;
                                    _showCreatePasswordValidationError = false;
                                    _showConfirmPasswordValidationError = false;
                                    _showCreatePasswordLengthValidationError =
                                        false;
                                    _passwordNotMatch = true;
                                    _currentPasswordNotMatch = false;
                                    _currentPasswordNotMatchWithCreatePassword =
                                        false;
                                  });
                                  return;
                                }
                                if (_currentPasswordNotMatch) {
                                  setState(() {
                                    _showCurrentPasswordValidationError = false;
                                    _showCreatePasswordValidationError = false;
                                    _showConfirmPasswordValidationError = false;
                                    _showCreatePasswordLengthValidationError =
                                        false;
                                    _passwordNotMatch = false;
                                    _currentPasswordNotMatch = true;
                                    _currentPasswordNotMatchWithCreatePassword =
                                        false;
                                  });
                                  return;
                                }
                                if (_currentPasswordNotMatchWithCreatePassword) {
                                  setState(() {
                                    _showCurrentPasswordValidationError = false;
                                    _showCreatePasswordValidationError = false;
                                    _showConfirmPasswordValidationError = false;
                                    _showCreatePasswordLengthValidationError =
                                        false;
                                    _passwordNotMatch = false;
                                    _currentPasswordNotMatch = false;
                                    _currentPasswordNotMatchWithCreatePassword =
                                        true;
                                  });
                                  return;
                                } else {
                                  if (auth.createPassword.text ==
                                      auth.confirmPassCont.text) {
                                    bool success =
                                        await auth.changePassword(context);
                                    if (success) {
                                      _showPasswordChanged(context);
                                    } else {
                                      Get.snackbar(
                                          'Error', 'Failed to change password');
                                    }
                                  } else {
                                    Get.snackbar(
                                        'Error', 'Passwords do not match');
                                  }
                                }
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
                                text: 'Save Changes',
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

  Future<void> _showPasswordChanged(BuildContext context) async {
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
}
