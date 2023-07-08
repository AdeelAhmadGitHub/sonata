import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../Controllers/auth_controller.dart';
import '../../../NaviationBar/NavigationBarScreen.dart';
import '../../../SideBar/SideBar.dart';
import '../../../Widgets/custom_text.dart';
import 'DeactivateBottomSheet.dart';

class DeactivateAccount extends StatefulWidget {
  const DeactivateAccount({Key? key}) : super(key: key);

  @override
  State<DeactivateAccount> createState() => _DeactivateAccountState();
}

class _DeactivateAccountState extends State<DeactivateAccount> {
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
                        Image.asset(
                          "assets/icons/Deactivate Account.png",
                          color: const Color(0xffFD5201),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        CustomText(
                          text: 'Deactivate Account',
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
                              'Are you sure you want to Deactivate your\n account?',
                          fontColor: const Color(0xff444444),
                          fontSize: 13.sp,
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
                                      child: DeactivateBottomSheet()));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF3C0061),
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color(0xffC80000), width: 2),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: 'Deactivate',
                              fontColor: const Color(0xffC82020),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    SizedBox(
                      height: 44.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // _showDeactivate(context);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFFC80000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          // padding: const EdgeInsets.fromLTRB(
                          //     16.0, 10.0, 12.0, 10.0),
                        ),
                        child: CustomText(
                          text: 'Delete Account and All Data',
                          fontColor: const Color(0xffFFFFFF),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
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

  // void _showDeactivate(BuildContext context) {
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
  //                 Image.asset("assets/icons/mdi_user-remove-outline.png"),
  //                 SizedBox(
  //                   height: 24.h,
  //                 ),
  //                 CustomText(
  //                   text:
  //                       'Please enter your password to \n confirm account deactivation',
  //                   fontColor: const Color(0xff444444),
  //                   fontSize: 18.sp,
  //                   fontWeight: FontWeight.w500,
  //                   fontFamily: "Poppins",
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
  //                         controller: auth.emailCont,
  //                         decoration: const InputDecoration(
  //                           contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
  //                           hintText: 'Enter your email address',
  //                           hintStyle: TextStyle(
  //                               color: Color(0xff727272),
  //                               fontSize: 16,
  //                               fontFamily: 'Poppins',
  //                               fontStyle: FontStyle.italic),
  //                           border: InputBorder.none,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 20.h,
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
  //                         controller: auth.passContL,
  //                         decoration: const InputDecoration(
  //                           contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
  //                           hintText: 'Enter your password',
  //                           hintStyle: TextStyle(
  //                               color: Color(0xff727272),
  //                               fontSize: 16,
  //                               fontFamily: 'Poppins',
  //                               fontStyle: FontStyle.italic),
  //                           border: InputBorder.none,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 44.h,
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
  //                                 Navigator.pop(context);
  //
  //                                 _showDeletion(context);
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 elevation: 0,
  //                                 backgroundColor: const Color(0xFFC80000),
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(8.0),
  //                                 ),
  //                                 padding: const EdgeInsets.fromLTRB(
  //                                     16.0, 10.0, 12.0, 10.0),
  //                               ),
  //                               child: CustomText(
  //                                 text: 'Deactivate',
  //                                 fontColor: const Color(0xffFFFFFF),
  //                                 fontSize: 14.sp,
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

  // void _showDeletion(BuildContext context) {
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
  //                 Image.asset("assets/icons/mdi_user-remove-outline.png"),
  //                 SizedBox(
  //                   height: 24.h,
  //                 ),
  //                 CustomText(
  //                   text:
  //                       'Please enter your password to\n confirm account deletion',
  //                   fontColor: const Color(0xff444444),
  //                   fontSize: 18.sp,
  //                   fontWeight: FontWeight.w500,
  //                   fontFamily: "Poppins",
  //                   textAlign: TextAlign.center,
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
  //                         controller: auth.emailCont,
  //                         decoration: const InputDecoration(
  //                           contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
  //                           hintText: 'Enter your email address',
  //                           hintStyle: TextStyle(
  //                               color: Color(0xff727272),
  //                               fontSize: 16,
  //                               fontFamily: 'Poppins',
  //                               fontStyle: FontStyle.italic),
  //                           border: InputBorder.none,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 20.h,
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
  //                         controller: auth.passContL,
  //                         decoration: const InputDecoration(
  //                           contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
  //                           hintText: 'Enter your password',
  //                           hintStyle: TextStyle(
  //                               color: Color(0xff727272),
  //                               fontSize: 16,
  //                               fontFamily: 'Poppins',
  //                               fontStyle: FontStyle.italic),
  //                           border: InputBorder.none,
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 44.h,
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
  //                                 auth.deactivateActions();
  //                                 _showConfirmation(context);
  //                               },
  //                               style: ElevatedButton.styleFrom(
  //                                 elevation: 0,
  //                                 backgroundColor: const Color(0xFFC80000),
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(8.0),
  //                                 ),
  //                                 padding: const EdgeInsets.fromLTRB(
  //                                     16.0, 10.0, 12.0, 10.0),
  //                               ),
  //                               child: CustomText(
  //                                 text: 'Deactivate',
  //                                 fontColor: const Color(0xffFFFFFF),
  //                                 fontSize: 14.sp,
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

  // void _showConfirmation(BuildContext context) {
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
  //                 Image.asset("assets/icons/mdi_user-remove-outline.png"),
  //                 SizedBox(
  //                   height: 24.h,
  //                 ),
  //                 CustomText(
  //                   text: 'Your account has been deactivated',
  //                   fontColor: const Color(0xff444444),
  //                   fontSize: 16.sp,
  //                   fontWeight: FontWeight.w500,
  //                   fontFamily: "Poppins",
  //                   textAlign: TextAlign.center,
  //                 ),
  //                 SizedBox(
  //                   height: 24.h,
  //                 ),
  //               ],
  //             ),
  //           ));
  //     },
  //   );
  // }
}
