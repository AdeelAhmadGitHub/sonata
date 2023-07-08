import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sonata/Views/Explore/Explore.dart';
import 'package:sonata/Views/More%20Info%20Profile/More%20Info%20Profile.dart';
import 'package:sonata/Views/Widgets/CustomButton.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../../Controllers/Upload Image.dart';
import '../../Controllers/auth_controller.dart';

class SetUpProfile extends StatefulWidget {
  const SetUpProfile({Key? key}) : super(key: key);

  @override
  State<SetUpProfile> createState() => _SetUpProfileState();
}

class _SetUpProfileState extends State<SetUpProfile> {
  final auth = Get.put(AuthController());
  var homePro = Get.put(UploadProfileController());
  File? _profileImage;
  String? userHandle;
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
              Center(
                child: InkWell(
                  onTap: () {
                    Get.to(const Explore());
                  },
                  child: SvgPicture.asset(
                    "assets/svg/Sonata_Logo_Main_RGB 2.svg",
                  ),
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              CustomText(
                text: 'Click!',
                fontColor: const Color(0xff3C0061),
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Chillax",
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(child: Image.asset("assets/images/setup profile.png")),
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
                                "assets/icons/Edit Profile.png",
                                height: 32.h,
                                width: 32.w,
                              ),
                              const SizedBox(
                                width: 9,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 2.0.h),
                                child: CustomText(
                                  text: 'Set Up Profile',
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
                          text: 'Set your profile picture',
                          fontColor: const Color(0xff444444),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Chillax",
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Center(
                          child: Container(
                            height: 240.h,
                            width: 240.w,
                            decoration: BoxDecoration(
                                color: const Color(0xffFAFAFD),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1, color: const Color(0xffC6BEE3))),
                            child: InkWell(
                              onTap: () {
                                _showChoiceDialog(context);
                              },
                              child: Center(
                                child: _profileImage == null
                                    ? Image.asset("assets/icons/Add Photo.png")
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.file(
                                          File(_profileImage!.path),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Container(
                          height: 1.h,
                          width: double.infinity.w,
                          color: const Color(0xffF6F5FB),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomButton(
                              height: 42.h,
                              borderRadius: (8),
                              buttonColor: Colors.transparent,
                              width: 104.w,
                              text: "Skip for now",
                              textColor: const Color(0xff3C0061),
                              textSize: 16.sp,
                              textFontWeight: FontWeight.w500,
                              fontFamily: "Chillax",
                              onPressed: () {
                                auth.profileImage = null;
                                Get.to(MoreInfoProfile());
                              },
                            ),
                            CustomButton(
                              height: 42.h,
                              borderRadius: (8),
                              buttonColor: const Color(0xff3C0061),
                              width: 104.w,
                              text: "Continue",
                              textColor: const Color(0xffFFFFFF),
                              textSize: 16.sp,
                              textFontWeight: FontWeight.w500,
                              fontFamily: "Chillax",
                              onPressed: () {
                                // _uploadImage;
                                // auth.profileImage = _profileImage;
                                Get.to(const MoreInfoProfile());
                              },
                            ),
                          ],
                        )
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

  // void _openCamera(BuildContext context) async {
  //   final pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.camera,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //       // _base64Image = base64Encode(_imageFile!.readAsBytesSync());
  //     });
  //   }
  // }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (mounted && pickedFile != null) {
      setState(() {
        final imageFile = File(pickedFile.path);
          auth.uploadProfileImage(imageFile);
        _profileImage = imageFile;
      });
    }
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (mounted && pickedFile != null) {
      setState(() {
        final imageFile = File(pickedFile.path);
        auth.uploadProfileImage(imageFile);
        _profileImage = imageFile;
      });
    }
  }

  // void _openCamera(BuildContext context) async {
  //   final pickedFile = await ImagePicker().pickImage(
  //     source: ImageSource.camera,
  //   );
  //   if (pickedFile != null) {
  //     setState(() {
  //       _imageFile = File(pickedFile.path);
  //       // _base64Image = base64Encode(_imageFile!.readAsBytesSync());
  //     });
  //   }
  // }
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Color(0xff96CCD5)),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1.h,
                    color: const Color(0xff96CCD5),
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                      Navigator.pop(context);
                    },
                    title: const Text("Gallery"),
                    leading: const Icon(
                      Icons.account_box,
                      color: Color(0xff8C8FA5),
                    ),
                  ),
                  Divider(
                    height: 1.h,
                    color: const Color(0xff96CCD5),
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                      Navigator.pop(context);
                    },
                    title: const Text("Camera"),
                    leading: const Icon(
                      Icons.camera,
                      color: Color(0xff8C8FA5),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
