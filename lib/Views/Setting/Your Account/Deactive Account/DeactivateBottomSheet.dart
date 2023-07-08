
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../../Controllers/auth_controller.dart';
import '../../../Widgets/custom_text.dart';


class DeactivateBottomSheet extends StatefulWidget {
  const DeactivateBottomSheet({super.key});

  @override
  _DeactivateBottomSheetState createState() => _DeactivateBottomSheetState();
}

class _DeactivateBottomSheetState extends State<DeactivateBottomSheet> {
  var auth = Get.find<AuthController>();
  bool showError = false;
  bool _obscurePassword = true;
  bool emailError = false;
  bool passwordError = false;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

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
      emailError = auth.emailContL.text.isEmpty;
      passwordError = auth.passContL.text.isEmpty;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.all(30),
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
                      Image.asset("assets/icons/mdi_user-remove-outline.png"),
                      SizedBox(
                        height: 24.h,
                      ),
                      CustomText(
                        text:
                        'Please enter your password to \n confirm account deactivation',
                        fontColor: const Color(0xff444444),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                    emailError = false;
                                  });
                                }),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          if (emailError)
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
                                    'Email is Required',
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
                                decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.fromLTRB(16, 10, 16, 10),
                                  hintText: 'Enter your password',
                                  hintStyle: TextStyle(
                                      color: (emailFocusNode.hasFocus
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
                                    passwordError = false;
                                  });
                                }),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          if (passwordError)
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
                                    'Password is Required',
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
                            height: 34.h,
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
                            height: 10.h,
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
                                          fontColor: const Color(0xff444444),
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
                                        showError = false;
                                      });
                                      _validate();
                                      if (emailError) {
                                        setState(() {
                                          emailError = true;
                                          passwordError = false;
                                        });
                                        return;
                                      }
                                      if (passwordError) {
                                        setState(() {
                                          emailError = false;
                                          passwordError = true;
                                        });
                                        return;
                                      } else {
                                        try {
                                          Navigator.pop(context);
                                          _showConfirmation(context);
                                         // auth.reactivateActions();
                                        } catch (error) {
                                          setState(() {
                                            showError = true;
                                          });
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: const Color(0xfff3C0061),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                      ),
                                      padding: const EdgeInsets.fromLTRB(
                                          16.0, 10.0, 12.0, 10.0),
                                    ),
                                    child: CustomText(
                                      text: 'Deactivate',
                                      fontColor: const Color(0xffFFFFFF),
                                      fontSize: 16.sp,
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
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showConfirmation(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            padding: const EdgeInsets.all(30),
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
                  Image.asset("assets/icons/mdi_user-remove-outline.png"),
                  SizedBox(
                    height: 24.h,
                  ),
                  CustomText(
                    text: 'Your account has been deactivated',
                    fontColor: const Color(0xff444444),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                ],
              ),
            ));
      },
    );
  }

}