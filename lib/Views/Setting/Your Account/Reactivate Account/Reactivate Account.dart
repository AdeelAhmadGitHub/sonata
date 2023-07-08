import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sonata/Views/Setting/Your%20Account/Reactivate%20Account/ReactivateBottomsheet.dart';

import '../../../../Controllers/auth_controller.dart';
import '../../../NaviationBar/NavigationBarScreen.dart';
import '../../../SideBar/SideBar.dart';
import '../../../Widgets/custom_text.dart';
import '../Deactive Account/DeactivateBottomSheet.dart';

class ReactivateAccount extends StatefulWidget {
  const ReactivateAccount({Key? key}) : super(key: key);

  @override
  State<ReactivateAccount> createState() => _ReactivateAccountState();
}

class _ReactivateAccountState extends State<ReactivateAccount> {
  var auth = Get.find<AuthController>();
  bool showError = false;
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
                    text: 'Back to Your Account',
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
                        SvgPicture.asset("assets/svg/Reactivate.svg"),
                        SizedBox(
                          width: 10.w,
                        ),
                        CustomText(
                          text: 'Reactivate Account',
                          fontColor: const Color(0xff160323),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffF6F5FB)),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomText(
                          text:
                              'Would you like to reactivate your\nSonata account?',
                          fontColor: const Color(0xff444444),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35.h,
                    ),
                    Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffF6F5FB)),
                    SizedBox(
                      height: 16.h,
                    ),
                    SizedBox(
                      height: 44.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              enableDrag: false,
                              isScrollControlled: true,
                              shape:  const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30))),
                              builder: (context) =>
                              const SingleChildScrollView(
                                  child: ReactivateBottomSheet()));
                        },

                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF3C0061),
                          backgroundColor: const Color(0xfff3C0061),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color(0xff3C0061), width: 2),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: 'Reactivate Account',
                              fontColor: const Color(0xffFFFFFF),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Future<void> _showDeactivate(BuildContext context) async {
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (BuildContext context, StateSetter setState) {
  //           return Container(
  //               padding: const EdgeInsets.all(30),
  //               decoration: const BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.only(
  //                   topLeft: Radius.circular(8),
  //                   topRight: Radius.circular(8),
  //                 ),
  //               ),
  //               child: SingleChildScrollView(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     SvgPicture.asset("assets/svg/ReactivateAccount.svg"),
  //                     SizedBox(
  //                       height: 24.h,
  //                     ),
  //                     Center(
  //                       child: CustomText(
  //                         text:
  //                         "Please enter the following information \n to confirm account activation",
  //                         fontColor: const Color(0xff444444),
  //                         fontSize: 16.sp,
  //                         fontWeight: FontWeight.w500,
  //                         fontFamily: "Poppins",
  //                         textAlign: TextAlign.center,
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 24.h,
  //                     ),
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         CustomText(
  //                           text: 'Email',
  //                           fontColor: const Color(0xff444444),
  //                           fontSize: 16.sp,
  //                           fontWeight: FontWeight.w600,
  //                           fontFamily: "Chillax",
  //                         ),
  //                         SizedBox(
  //                           height: 6.h,
  //                         ),
  //                         Container(
  //                           height: 44.h,
  //                           decoration: BoxDecoration(
  //                             color: emailFocusNode.hasFocus
  //                                 ? Colors.white
  //                                 : const Color(0xffFAFAFD),                            border: Border.all(
  //                               width: 1, color: (emailFocusNode.hasFocus
  //                               ? const Color(0xff3C0061)
  //                               : const Color(0xffC6BEE3))),
  //                             borderRadius: BorderRadius.circular(8.0),
  //                           ),
  //                           child: TextFormField(
  //                               controller: auth.emailContL,
  //                               focusNode: emailFocusNode,
  //
  //                               cursorColor: Color(0xff3C0061),
  //                               decoration:  InputDecoration(
  //                                 contentPadding:
  //                                 EdgeInsets.fromLTRB(16, 10, 16, 10),
  //                                 hintText: 'Enter your email address',
  //                                 hintStyle: TextStyle(
  //                                     color: (emailFocusNode.hasFocus
  //                                         ? const Color(0xffBBBBBB)
  //                                         : const Color(0xff727272)),
  //                                     fontSize: 16,
  //                                     fontFamily: 'Poppins',
  //                                     fontStyle: FontStyle.italic),
  //                                 border: InputBorder.none,
  //                               ),
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   _EmailValidationError = false;
  //                                 });
  //                               }),
  //                         ),
  //                         SizedBox(
  //                           height: 10.h,
  //                         ),
  //                         if (_EmailValidationError)
  //                           Row(
  //                             children: [
  //                               Image.asset(
  //                                 "assets/icons/incorrect password.png",
  //                                 height: 18,
  //                                 width: 20,
  //                               ),
  //                               const SizedBox(width: 8),
  //                               Flexible(
  //                                 child: Text(
  //                                   'Email is Required',
  //                                   style: TextStyle(
  //                                     color: Color(0xffDA0000),
  //                                     fontSize: 14.sp,
  //                                     fontWeight: FontWeight.w400,
  //                                     fontFamily: "Poppins",
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         SizedBox(
  //                           height: 10.h,
  //                         ),
  //                         CustomText(
  //                           text: 'Password',
  //                           fontColor: const Color(0xff444444),
  //                           fontSize: 16.sp,
  //                           fontWeight: FontWeight.w600,
  //                           fontFamily: "Chillax",
  //                         ),
  //                         SizedBox(
  //                           height: 6.h,
  //                         ),
  //                         Container(
  //                           height: 44.h,
  //                           decoration: BoxDecoration(
  //                             color: passwordFocusNode.hasFocus
  //                                 ? Colors.white
  //                                 : const Color(0xffFAFAFD),                            border: Border.all(
  //                               width: 1, color: (passwordFocusNode.hasFocus
  //                               ? const Color(0xff3C0061)
  //                               : const Color(0xffC6BEE3))),
  //                             borderRadius: BorderRadius.circular(8.0),
  //                           ),
  //                           child: TextFormField(
  //                               focusNode: passwordFocusNode,
  //
  //                               controller: auth.passContL,
  //                               obscureText: _obscurePassword,
  //                               cursorColor: Color(0xff3C0061),
  //                               decoration: InputDecoration(
  //                                 contentPadding:
  //                                 EdgeInsets.fromLTRB(16, 10, 16, 10),
  //                                 hintText: 'Enter your password',
  //                                 hintStyle: TextStyle(
  //                                     color: (passwordFocusNode.hasFocus
  //                                         ? const Color(0xffBBBBBB)
  //                                         : const Color(0xff727272)),
  //                                     fontSize: 16,
  //                                     fontFamily: 'Poppins',
  //                                     fontStyle: FontStyle.italic),
  //                                 border: InputBorder.none,
  //                                 suffixIcon: GestureDetector(
  //                                   onTap: () {
  //                                     setState(() {
  //                                       _obscurePassword =
  //                                       !_obscurePassword; // Toggle password visibility
  //                                     });
  //                                   },
  //                                   child: Icon(
  //                                     _obscurePassword
  //                                         ? Icons.visibility
  //                                         : Icons.visibility_off,
  //                                     color: const Color(0xffD9D9D9),
  //                                   ),
  //                                 ),
  //                               ),
  //                               onChanged: (value) {
  //                                 setState(() {
  //                                   _PasswordValidationError = false;
  //                                 });
  //                               }),
  //                         ),
  //                         SizedBox(
  //                           height: 10.h,
  //                         ),
  //                         if (_PasswordValidationError)
  //                           Row(
  //                             children: [
  //                               Image.asset(
  //                                 "assets/icons/incorrect password.png",
  //                                 height: 18,
  //                                 width: 20,
  //                               ),
  //                               const SizedBox(width: 8),
  //                               Flexible(
  //                                 child: Text(
  //                                   'Password is Required',
  //                                   style: TextStyle(
  //                                     color: Color(0xffDA0000),
  //                                     fontSize: 14.sp,
  //                                     fontWeight: FontWeight.w400,
  //                                     fontFamily: "Poppins",
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         SizedBox(
  //                           height: 34.h,
  //                         ),
  //                         Visibility(
  //                           visible: showError,
  //                           child: Container(
  //                             padding: EdgeInsets.only(
  //                                 left: 16.0, top: 4.0, bottom: 4.0),
  //                             decoration: BoxDecoration(
  //                               color: const Color.fromRGBO(200, 0, 0, 0.06),
  //                               borderRadius: BorderRadius.circular(6.0),
  //                             ),
  //                             child: Row(
  //                               children: [
  //                                 Center(
  //                                   child: Image.asset(
  //                                     "assets/icons/incorrect password.png",
  //                                     height: 18.h,
  //                                     width: 20.w,
  //                                   ),
  //                                 ),
  //                                 SizedBox(
  //                                   width: 8.w,
  //                                 ),
  //                                 CustomText(
  //                                   text: 'Incorrect email or password',
  //                                   fontColor: const Color(0xffDA0000),
  //                                   fontSize: 16.sp,
  //                                   fontWeight: FontWeight.w400,
  //                                   fontFamily: "Poppins",
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           height: 10.h,
  //                         ),
  //                         Container(
  //                             height: 1.h,
  //                             width: double.infinity.w,
  //                             color: const Color(0xffF6F5FB)),
  //                         SizedBox(
  //                           height: 16.h,
  //                         ),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Expanded(
  //                               child: SizedBox(
  //                                 height: 44.h,
  //                                 child: ElevatedButton(
  //                                   onPressed: () {
  //                                     Navigator.pop(context);
  //                                   },
  //                                   style: ElevatedButton.styleFrom(
  //                                     foregroundColor: const Color(0xFF3C0061),
  //                                     backgroundColor: Colors.transparent,
  //                                     elevation: 0,
  //                                   ),
  //                                   child: Row(
  //                                     mainAxisAlignment: MainAxisAlignment.center,
  //                                     children: [
  //                                       CustomText(
  //                                         text: 'Cancel',
  //                                         fontColor: const Color(0xff444444),
  //                                         fontSize: 14.sp,
  //                                         fontWeight: FontWeight.w600,
  //                                         fontFamily: "Poppins",
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               width: 20.w,
  //                             ),
  //                             Expanded(
  //                               child: SizedBox(
  //                                 height: 44.h,
  //                                 child: ElevatedButton(
  //                                   onPressed: () {
  //                                     setState(() {
  //                                       showError = false;
  //                                     });
  //                                     _validate();
  //                                     if (_EmailValidationError) {
  //                                       setState(() {
  //                                         _EmailValidationError = true;
  //                                         _PasswordValidationError = false;
  //                                       });
  //                                       return;
  //                                     }
  //                                     if (_PasswordValidationError) {
  //                                       setState(() {
  //                                         _EmailValidationError = false;
  //                                         _PasswordValidationError = true;
  //                                       });
  //                                       return;
  //                                     } else {
  //                                       try {
  //                                         Navigator.pop(context);
  //                                         _showConfirmation(context);
  //                                         auth.reactivateActions();
  //                                       } catch (error) {
  //                                         setState(() {
  //                                           showError = true;
  //                                         });
  //                                       }
  //                                     }
  //                                   },
  //                                   style: ElevatedButton.styleFrom(
  //                                     elevation: 0,
  //                                     backgroundColor: const Color(0xfff3C0061),
  //                                     shape: RoundedRectangleBorder(
  //                                       borderRadius: BorderRadius.circular(8.0),
  //                                     ),
  //                                     padding: const EdgeInsets.fromLTRB(
  //                                         16.0, 10.0, 12.0, 10.0),
  //                                   ),
  //                                   child: CustomText(
  //                                     text: 'Reactivate',
  //                                     fontColor: const Color(0xffFFFFFF),
  //                                     fontSize: 16.sp,
  //                                     fontWeight: FontWeight.w600,
  //                                     fontFamily: "Chillax",
  //                                   ),
  //                                 ),
  //                               ),
  //                             )
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ));
  //         },
  //       );
  //     },
  //   );
  // }

  // Future<void> _showDeactivate(BuildContext context) async {
  //   setState(() {
  //     showError = false;
  //      _obscurePassword = true;
  //      _showEmailValidationError = false;
  //     _showPasswordValidationError = false;
  //   });
  //   showModalBottomSheet(
  //     isScrollControlled: true,
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //           padding: const EdgeInsets.all(30),
  //           decoration: const BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(8),
  //               topRight: Radius.circular(8),
  //             ),
  //           ),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               children: [
  //                 SvgPicture.asset("assets/svg/ReactivateAccount.svg"),
  //                 SizedBox(
  //                   height: 24.h,
  //                 ),
  //                 Center(
  //                   child: CustomText(
  //                     text:
  //                         "Please enter the following information \n to confirm account activation",
  //                     fontColor: const Color(0xff444444),
  //                     fontSize: 16.sp,
  //                     fontWeight: FontWeight.w500,
  //                     fontFamily: "Poppins",
  //                     textAlign: TextAlign.center,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 24.h,
  //                 ),
  //                 Column(
  //                   mainAxisAlignment: MainAxisAlignment.start,
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     CustomText(
  //                       text: 'Email',
  //                       fontColor: const Color(0xff444444),
  //                       fontSize: 16.sp,
  //                       fontWeight: FontWeight.w600,
  //                       fontFamily: "Chillax",
  //                     ),
  //                     SizedBox(
  //                       height: 6.h,
  //                     ),
  //                     Container(
  //                       height: 44.h,
  //                       decoration: BoxDecoration(
  //                         color: const Color(0xffFAFAFD),
  //                         border: Border.all(
  //                             width: 1, color: const Color(0xffC6BEE3)),
  //                         borderRadius: BorderRadius.circular(8.0),
  //                       ),
  //                       child: TextFormField(
  //                           controller: auth.emailCont,
  //                           cursorColor: Color(0xff3C0061),
  //                           decoration: const InputDecoration(
  //                             contentPadding:
  //                                 EdgeInsets.fromLTRB(16, 10, 16, 10),
  //                             hintText: 'Enter your email address',
  //                             hintStyle: TextStyle(
  //                                 color: Color(0xff727272),
  //                                 fontSize: 16,
  //                                 fontFamily: 'Poppins',
  //                                 fontStyle: FontStyle.italic),
  //                             border: InputBorder.none,
  //                           ),
  //                           onChanged: (value) {
  //                             setState(() {
  //                               _showEmailValidationError = false;
  //                             });
  //                           }),
  //                     ),
  //                     SizedBox(
  //                       height: 10.h,
  //                     ),
  //                     if (_showEmailValidationError)
  //                       Row(
  //                         children: [
  //                           Image.asset(
  //                             "assets/icons/incorrect password.png",
  //                             height: 18,
  //                             width: 20,
  //                           ),
  //                           const SizedBox(width: 8),
  //                           Flexible(
  //                             child: Text(
  //                               'Email is Required',
  //                               style: TextStyle(
  //                                 color: Color(0xffDA0000),
  //                                 fontSize: 14.sp,
  //                                 fontWeight: FontWeight.w400,
  //                                 fontFamily: "Poppins",
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     SizedBox(
  //                       height: 10.h,
  //                     ),
  //                     CustomText(
  //                       text: 'Password',
  //                       fontColor: const Color(0xff444444),
  //                       fontSize: 16.sp,
  //                       fontWeight: FontWeight.w600,
  //                       fontFamily: "Chillax",
  //                     ),
  //                     SizedBox(
  //                       height: 6.h,
  //                     ),
  //                     Container(
  //                       height: 44.h,
  //                       decoration: BoxDecoration(
  //                         color: const Color(0xffFAFAFD),
  //                         border: Border.all(
  //                             width: 1, color: const Color(0xffC6BEE3)),
  //                         borderRadius: BorderRadius.circular(8.0),
  //                       ),
  //                       child: TextFormField(
  //                           controller: auth.passContL,
  //                           obscureText: _obscurePassword,
  //                           cursorColor: Color(0xff3C0061),
  //                           decoration: InputDecoration(
  //                             contentPadding:
  //                                 EdgeInsets.fromLTRB(16, 10, 16, 10),
  //                             hintText: 'Enter your password',
  //                             hintStyle: TextStyle(
  //                                 color: Color(0xff727272),
  //                                 fontSize: 16,
  //                                 fontFamily: 'Poppins',
  //                                 fontStyle: FontStyle.italic),
  //                             border: InputBorder.none,
  //                             suffixIcon: GestureDetector(
  //                               onTap: () {
  //                                 setState(() {
  //                                   _obscurePassword =
  //                                       !_obscurePassword; // Toggle password visibility
  //                                 });
  //                               },
  //                               child: Icon(
  //                                 _obscurePassword
  //                                     ? Icons.visibility
  //                                     : Icons.visibility_off,
  //                                 color: const Color(0xffD9D9D9),
  //                               ),
  //                             ),
  //                           ),
  //                           onChanged: (value) {
  //                             setState(() {
  //                               _showPasswordValidationError = false;
  //                             });
  //                           }),
  //                     ),
  //                     SizedBox(
  //                       height: 10.h,
  //                     ),
  //                     if (_showPasswordValidationError)
  //                       Row(
  //                         children: [
  //                           Image.asset(
  //                             "assets/icons/incorrect password.png",
  //                             height: 18,
  //                             width: 20,
  //                           ),
  //                           const SizedBox(width: 8),
  //                           Flexible(
  //                             child: Text(
  //                               'Password is Required',
  //                               style: TextStyle(
  //                                 color: Color(0xffDA0000),
  //                                 fontSize: 14.sp,
  //                                 fontWeight: FontWeight.w400,
  //                                 fontFamily: "Poppins",
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     SizedBox(
  //                       height: 34.h,
  //                     ),
  //                     Visibility(
  //                       visible: showError,
  //                       child: Container(
  //                         padding: EdgeInsets.only(
  //                             left: 16.0, top: 4.0, bottom: 4.0),
  //                         decoration: BoxDecoration(
  //                           color: const Color.fromRGBO(200, 0, 0, 0.06),
  //                           borderRadius: BorderRadius.circular(6.0),
  //                         ),
  //                         child: Row(
  //                           children: [
  //                             Center(
  //                               child: Image.asset(
  //                                 "assets/icons/incorrect password.png",
  //                                 height: 18.h,
  //                                 width: 20.w,
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               width: 8.w,
  //                             ),
  //                             CustomText(
  //                               text: 'Incorrect email or password',
  //                               fontColor: const Color(0xffDA0000),
  //                               fontSize: 16.sp,
  //                               fontWeight: FontWeight.w400,
  //                               fontFamily: "Poppins",
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 10.h,
  //                     ),
  //                     Container(
  //                         height: 1.h,
  //                         width: double.infinity.w,
  //                         color: const Color(0xffF6F5FB)),
  //                     SizedBox(
  //                       height: 16.h,
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Expanded(
  //                           child: SizedBox(
  //                             height: 44.h,
  //                             child: ElevatedButton(
  //                               onPressed: () {
  //                                 Navigator.pop(context);
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 foregroundColor: const Color(0xFF3C0061),
  //                                 backgroundColor: Colors.transparent,
  //                                 elevation: 0,
  //                               ),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   CustomText(
  //                                     text: 'Cancel',
  //                                     fontColor: const Color(0xff444444),
  //                                     fontSize: 14.sp,
  //                                     fontWeight: FontWeight.w600,
  //                                     fontFamily: "Poppins",
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         SizedBox(
  //                           width: 20.w,
  //                         ),
  //                         Expanded(
  //                           child: SizedBox(
  //                             height: 44.h,
  //                             child: ElevatedButton(
  //                               onPressed: () {
  //                                 setState(() {
  //                                   showError = false;
  //                                 });
  //                                 _validate();
  //                                 if (_showEmailValidationError) {
  //                                   setState(() {
  //                                     _showEmailValidationError = true;
  //                                     _showPasswordValidationError = false;
  //                                   });
  //                                   return;
  //                                 }
  //                                 if (_showPasswordValidationError) {
  //                                   setState(() {
  //                                     _showEmailValidationError = false;
  //                                     _showPasswordValidationError = true;
  //                                   });
  //                                   return;
  //                                 } else {
  //                                   try {
  //                                     Navigator.pop(context);
  //                                     _showConfirmation(context);
  //                                     auth.reactivateActions();
  //                                   } catch (error) {
  //                                     setState(() {
  //                                       showError = true;
  //                                     });
  //                                   }
  //                                 }
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 elevation: 0,
  //                                 backgroundColor: const Color(0xfff3C0061),
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(8.0),
  //                                 ),
  //                                 padding: const EdgeInsets.fromLTRB(
  //                                     16.0, 10.0, 12.0, 10.0),
  //                               ),
  //                               child: CustomText(
  //                                 text: 'Reactivate',
  //                                 fontColor: const Color(0xffFFFFFF),
  //                                 fontSize: 16.sp,
  //                                 fontWeight: FontWeight.w600,
  //                                 fontFamily: "Chillax",
  //                               ),
  //                             ),
  //                           ),
  //                         )
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ));
  //     },
  //   );
  // }

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
                  SvgPicture.asset("assets/svg/ReactivateAccount.svg"),
                  SizedBox(
                    height: 24.h,
                  ),
                  CustomText(
                    text: 'Your account has been reactivated',
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
