import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sonata/Views/Sign%20In/SignIn.dart';
import 'package:sonata/Views/Widgets/CustomButton.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';

import '../../../Controllers/auth_controller.dart';
import '../Explore(Without Login)/Explore.dart';
import '../Set Up Profile/Set Up Profile.dart';

class CreatePassword extends StatefulWidget {
  const CreatePassword({Key? key}) : super(key: key);

  @override
  State<CreatePassword> createState() => _CreatePasswordState();
}

class _CreatePasswordState extends State<CreatePassword> {
  final auth = Get.put(AuthController());

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

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _onPasswordChanged(String password) {
    setState(() {
      _showCreatePasswordValidationError = false;
      if (_buttonClicked && password.length >= 4) {
        _showCreatePasswordLengthValidationError = false; // Reset the flag
      } else {
        _showCreatePasswordLengthValidationError =
            false; // Set the flag if password length is less than 4
      }
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
    if (password.length < 6) {
      return '';
    }
    if (password.length < 10) {
      return '';
    }
    return '';
  }

  String validationMessage = '';

  TextEditingController createPassword = TextEditingController();
  // TextEditingController confirmPassword = TextEditingController();
  double passwordScore = 0;

  FocusNode _createPassworFocusNode = FocusNode();
  FocusNode _confirmPasswordFocusNode = FocusNode();
  bool _showCreatePasswordValidationError = false;
  bool _showConfirmValidationError = false;
  bool _buttonClicked = false;
  bool _showCreatePasswordLengthValidationError = false;
  bool _passwordNotMatch = false;
  void _validate() {
    setState(() {
      _showCreatePasswordValidationError = createPassword.text.isEmpty;
      _showConfirmValidationError = auth.confirmPassCont.text.isEmpty;
      if (!_showCreatePasswordValidationError &&
          createPassword.text.length < 4) {
        _showCreatePasswordLengthValidationError = true;
        _buttonClicked = true;
      } else {
        _showCreatePasswordLengthValidationError = false;
      }
      if (createPassword.text != auth.confirmPassCont.text) {
        _passwordNotMatch = true;
      } else {
        _passwordNotMatch = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _createPassworFocusNode.addListener(_onFocusChange);
    _confirmPasswordFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _createPassworFocusNode.removeListener(_onFocusChange);
    _confirmPasswordFocusNode.removeListener(_onFocusChange);
    // createPassword.dispose();
    // auth.confirmPassCont.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
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
                text: 'Lets secure your account',
                fontColor: const Color(0xff3C0061),
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Chillax",
              ),
              SizedBox(
                height: 40.h,
              ),
              Center(child: Image.asset("assets/images/Create Password.png")),
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
                                "assets/icons/Create Profile.png",
                                height: 32.h,
                                width: 32.w,
                              ),
                              SizedBox(
                                width: 9.w,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 2.0.h),
                                child: CustomText(
                                  text: 'Create Profile',
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
                          height: 10.h,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        CustomText(
                          text: 'Create Password',
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
                            color: _createPassworFocusNode.hasFocus
                                ? Colors.white
                                : const Color(0xffFAFAFD),
                            border: Border.all(
                              width: 1,
                              color: (_createPassworFocusNode.hasFocus
                                  ? Color(0xff3C0061)
                                  : Color(0xffC6BEE3)),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: TextFormField(
                              focusNode: _createPassworFocusNode,
                              controller: createPassword,
                              cursorColor: Color(0xff3C0061),
                              keyboardType: TextInputType.text,
                              onChanged: _onPasswordChanged,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(16, 11, 16, 11),
                                hintText: 'Create a secure password',
                                hintStyle: TextStyle(
                                  color: (_createPassworFocusNode.hasFocus
                                      ? Color(0xffBBBBBB)
                                      : Color(0xff727272)),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.italic,
                                ),
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
                            ),
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
                              const Flexible(
                                child: Text(
                                  'Password is required',
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
                        Visibility(
                          visible: !_isPasswordStrong,
                          child: SizedBox(
                            height: 11.h,
                          ),
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
                          text: 'Confirm Password',
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
                            color: _confirmPasswordFocusNode.hasFocus
                                ? Colors.white
                                : const Color(0xffFAFAFD),
                            border: Border.all(
                              width: 1,
                              color: (_confirmPasswordFocusNode.hasFocus
                                  ? Color(0xff3C0061)
                                  : Color(0xffC6BEE3)),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            controller: auth.confirmPassCont,
                            cursorColor: Color(0xff3C0061),
                            keyboardType: TextInputType.text,
                            obscureText: _obscureConfirmPassword,
                            focusNode: _confirmPasswordFocusNode,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 11, 16, 11),
                              hintText: 'Confirm above entered password',
                              hintStyle: TextStyle(
                                color: (_confirmPasswordFocusNode.hasFocus
                                    ? Color(0xffBBBBBB)
                                    : Color(0xff727272)),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.italic,
                              ),
                              border: InputBorder.none,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword; // Toggle password visibility
                                  });
                                },
                                child: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xffD9D9D9),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _showConfirmValidationError = false;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        if (_showConfirmValidationError)
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
                                  'Confirm password is required',
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
                          height: 80.h,
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
                        SizedBox(
                          height: 20.h,
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
                            text: "Create Profile",
                            textColor: const Color(0xffFFFFFF),
                            textSize: 16.sp,
                            textFontWeight: FontWeight.w600,
                            fontFamily: "Chillax",
                            onPressed: () async {
                              _validate();
                              if (_showCreatePasswordValidationError) {
                                setState(() {
                                  _showCreatePasswordValidationError = true;
                                  _showConfirmValidationError = false;
                                  _showCreatePasswordLengthValidationError =
                                      false;
                                });
                                return;
                              }
                              if (_buttonClicked &&
                                  (_showCreatePasswordLengthValidationError ||
                                      _password.length < 4)) {
                                setState(() {
                                  _showCreatePasswordValidationError = false;
                                  _showConfirmValidationError = false;
                                  _showCreatePasswordLengthValidationError =
                                      true;
                                });
                                return;
                              }
                              if (_showConfirmValidationError) {
                                setState(() {
                                  _showCreatePasswordValidationError = false;
                                  _showConfirmValidationError = true;
                                  _showCreatePasswordLengthValidationError =
                                      false;
                                });
                                return;
                                if (_passwordNotMatch) {
                                  setState(() {
                                    _showCreatePasswordValidationError = false;
                                    _showConfirmValidationError = true;
                                    _showCreatePasswordLengthValidationError =
                                        false;
                                  });
                                  return;
                                }
                              } else {
                                if (createPassword.text ==
                                    auth.confirmPassCont.text) {
                                  bool success = await auth.registerUser();
                                }
                              }
                            }),
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
