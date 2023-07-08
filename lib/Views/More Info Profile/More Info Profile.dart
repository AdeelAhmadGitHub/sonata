import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:sonata/Controllers/auth_controller.dart';
import 'package:sonata/Views/Channel/Channels.dart';
import 'package:sonata/Views/Widgets/CustomButton.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';
import 'dart:math' as math;

import '../../Controllers/PieChartController/PieChartController.dart';
import '../Explore(Without Login)/Explore.dart';

class MoreInfoProfile extends StatefulWidget {
  const MoreInfoProfile({Key? key}) : super(key: key);

  @override
  State<MoreInfoProfile> createState() => _MoreInfoProfileState();
}

class _MoreInfoProfileState extends State<MoreInfoProfile> {
  final auth = Get.put(AuthController());
  final PieChartController controller = Get.put(PieChartController());
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
                text: 'Tell us more about yourself',
                fontColor: const Color(0xff3C0061),
                fontSize: 24.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Chillax",
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(child: Image.asset("assets/images/about self.png")),
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
                              SizedBox(
                                width: 9.w,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: 'Tagline',
                              fontColor: const Color(0xff444444),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                            Row(
                              children: [
                                Obx(() => Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xff3C0061),
                                          width: 6,
                                        ),
                                      ),
                                      child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(math.pi),
                                        child: CircularProgressIndicator(
                                          value: controller.progressValueTagline
                                              .clamp(0.0, 1.0)
                                              .toDouble(),
                                          backgroundColor: Colors.white,
                                          strokeWidth: 10,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(
                                            const Color(0xff3C0061),
                                          ),
                                        ),
                                      ),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    _showBottomTagline(context);
                                  },
                                  child: const Icon(
                                    Icons.privacy_tip_outlined,
                                    color: Color(0xff3C0061),
                                    size: 20,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Container(
                          height: null,
                          decoration: BoxDecoration(
                            color: const Color(0xffFAFAFD),
                            border: Border.all(
                              width: 1,
                              color: const Color(0xffC6BEE3),
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            controller: auth.tagLine,
                            onChanged: (text) {
                              if (text.length <= 100) {
                                controller.updateProgressTagline(text);
                              }
                            },
                            maxLines: null,
                            minLines: 1,
                            maxLength: 100,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintText: 'Write your tagline',
                              hintStyle: TextStyle(
                                color: const Color(0xff8E8694),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.italic,
                              ),
                              border: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: 'Description',
                              fontColor: const Color(0xff444444),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                            Row(
                              children: [
                                Obx(() => Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xff3C0061),
                                          width: 6,
                                        ),
                                      ),
                                      child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(math.pi),
                                        child: CircularProgressIndicator(
                                          value: controller.progressValueDes
                                              .clamp(0.0, 1.0)
                                              .toDouble(),
                                          backgroundColor: Colors.white,
                                          strokeWidth: 10,
                                          valueColor:
                                              const AlwaysStoppedAnimation<
                                                  Color>(
                                            const Color(0xff3C0061),
                                          ),
                                        ),
                                      ),
                                    )),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    _showBottomSheetDescription(context);
                                  },
                                  child: const Icon(
                                    Icons.privacy_tip_outlined,
                                    color: Color(0xff3C0061),
                                    size: 20,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Container(
                          height: 82.h,
                          decoration: BoxDecoration(
                            color: const Color(0xffFAFAFD),
                            border: Border.all(
                                width: 1, color: const Color(0xffC6BEE3)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            controller: auth.descriptionCont,
                            onChanged: (text) {
                              if (text.length <= 200) {
                                controller.updateProgressDesp(text);
                              }
                            },
                            maxLines: null,
                            minLines: 1,
                            maxLength: 200,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              contentPadding:
                                  const EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintText: 'Write about yourself',
                              hintStyle: TextStyle(
                                  color: const Color(0xff8E8694),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.italic),
                              border: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  text: 'Location',
                                  fontColor: const Color(0xff444444),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Chillax",
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Image.asset(
                                  "assets/icons/Location.png",
                                  height: 24.h,
                                  width: 24.w,
                                  color: const Color(0xff444444),
                                ),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                _showBottomSheetLocatuion(context);
                              },
                              child: const Icon(
                                Icons.privacy_tip_outlined,
                                color: Color(0xff3C0061),
                                size: 20,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffFAFAFD),
                            border: Border.all(
                                width: 1, color: const Color(0xffC6BEE3)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            controller: auth.locationCont,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintText: 'Where do you live?',
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
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: 'Work',
                              fontColor: const Color(0xff444444),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                            GestureDetector(
                              onTap: () {
                                _showBottomSheetWork(context);
                              },
                              child: const Icon(
                                Icons.privacy_tip_outlined,
                                color: Color(0xff3C0061),
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 6.h,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffFAFAFD),
                            border: Border.all(
                                width: 1, color: const Color(0xffC6BEE3)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            controller: auth.workCont,
                            decoration: const InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintText: 'Where do you work?',
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
                                Get.to(const Channels());
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
                                Get.to(const Channels());
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

  void _showBottomSheetLocatuion(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return IntrinsicHeight(
          child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.privacy_tip_outlined,
                                color: Color(0xffFD5201),
                                size: 20,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              CustomText(
                                text: 'Privacy Info - Location',
                                fontColor: const Color(0xff160323),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ],
                          ),
                          CustomText(
                            text: 'View All',
                            fontColor: const Color(0xff3C0061),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Chillax",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Used For:',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 15),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'Providing  you with feeds relevant \nto your local area',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text: ' Personalized Marketing',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Shared with:',
                      fontColor: const Color(0xff444444),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'Converted to nearest town, anonymized \nas part of a statistic, with advertisers\n and analytics providers',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Stored for:',
                      fontColor: const Color(0xff444444),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text: 'As long as you have a Sonata account',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Your Options:',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 15),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'You can disable personalized marketing\nin the settings',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'You can disable third party analytics in\n the settings',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'You can decide not to provide, or to\n remove this information at any time',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      height: 42.h,
                      borderRadius: (8),
                      buttonColor: const Color(0xff3C0061),
                      width: double.infinity,
                      text: "Okay",
                      textColor: const Color(0xffFFFFFF),
                      textSize: 16.sp,
                      textFontWeight: FontWeight.w500,
                      fontFamily: "Chillax",
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  void _showBottomTagline(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return IntrinsicHeight(
          child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.privacy_tip_outlined,
                                color: Color(0xffFD5201),
                                size: 20,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              CustomText(
                                text: 'Privacy Info - Tagline',
                                fontColor: const Color(0xff160323),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ],
                          ),
                          CustomText(
                            text: 'View All',
                            fontColor: const Color(0xff3C0061),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Chillax",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Used For:',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 15),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'Providing  you with feeds relevant \nto your local area',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text: ' Personalized Marketing',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Shared with:',
                      fontColor: const Color(0xff444444),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'Converted to nearest town, anonymized \nas part of a statistic, with advertisers\n and analytics providers',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Stored for:',
                      fontColor: const Color(0xff444444),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text: 'As long as you have a Sonata account',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Your Options:',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 15),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'You can disable personalized marketing\nin the settings',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'You can disable third party analytics in\n the settings',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'You can decide not to provide, or to\n remove this information at any time',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      height: 42.h,
                      borderRadius: (8),
                      buttonColor: const Color(0xff3C0061),
                      width: double.infinity,
                      text: "Okay",
                      textColor: const Color(0xffFFFFFF),
                      textSize: 16.sp,
                      textFontWeight: FontWeight.w500,
                      fontFamily: "Chillax",
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  void _showBottomSheetDescription(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return IntrinsicHeight(
          child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.privacy_tip_outlined,
                                color: Color(0xffFD5201),
                                size: 20,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              CustomText(
                                text: 'Privacy Info - Description',
                                fontColor: const Color(0xff160323),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ],
                          ),
                          CustomText(
                            text: 'View All',
                            fontColor: const Color(0xff3C0061),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Chillax",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Used For:',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 15),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'Providing  you with feeds relevant \nto your local area',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text: ' Personalized Marketing',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Shared with:',
                      fontColor: const Color(0xff444444),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'Converted to nearest town, anonymized \nas part of a statistic, with advertisers\n and analytics providers',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Stored for:',
                      fontColor: const Color(0xff444444),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text: 'As long as you have a Sonata account',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Your Options:',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 15),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'You can disable personalized marketing\nin the settings',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'You can disable third party analytics in\n the settings',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'You can decide not to provide, or to\n remove this information at any time',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      height: 42.h,
                      borderRadius: (8),
                      buttonColor: const Color(0xff3C0061),
                      width: double.infinity,
                      text: "Okay",
                      textColor: const Color(0xffFFFFFF),
                      textSize: 16.sp,
                      textFontWeight: FontWeight.w500,
                      fontFamily: "Chillax",
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }

  void _showBottomSheetWork(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return IntrinsicHeight(
          child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.privacy_tip_outlined,
                                color: Color(0xffFD5201),
                                size: 20,
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              CustomText(
                                text: 'Privacy Info - Work',
                                fontColor: const Color(0xff160323),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ],
                          ),
                          CustomText(
                            text: 'View All',
                            fontColor: const Color(0xff3C0061),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Chillax",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Used For:',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 15),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'Providing  you with feeds relevant \nto your local area',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text: ' Personalized Marketing',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Shared with:',
                      fontColor: const Color(0xff444444),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'Converted to nearest town, anonymized \nas part of a statistic, with advertisers\n and analytics providers',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Stored for:',
                      fontColor: const Color(0xff444444),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text: 'As long as you have a Sonata account',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    CustomText(
                      text: 'Your Options:',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 15),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'You can disable personalized marketing\nin the settings',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'You can disable third party analytics in\n the settings',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 10),
                          child: Container(
                            height: 4.h,
                            width: 4.w,
                            decoration: BoxDecoration(
                                color: const Color(0xff444444),
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        CustomText(
                          text:
                              'You can decide not to provide, or to\n remove this information at any time',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      height: 42.h,
                      borderRadius: (8),
                      buttonColor: const Color(0xff3C0061),
                      width: double.infinity,
                      text: "Okay",
                      textColor: const Color(0xffFFFFFF),
                      textSize: 16.sp,
                      textFontWeight: FontWeight.w500,
                      fontFamily: "Chillax",
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
