import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sonata/Controllers/auth_controller.dart';
import 'package:sonata/Views/Sign%20In/SignIn.dart';
import 'package:sonata/Views/Widgets/CustomButton.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';
import '../Explore(Without Login)/Explore.dart';

class Channels extends StatefulWidget {
  const Channels({Key? key}) : super(key: key);

  @override
  State<Channels> createState() => _ChannelsState();
}

class _ChannelsState extends State<Channels> {
  final auth = Get.put(AuthController());
  List<String> channelNames = [
    "Family",
    "Pets",
    "Work",
    "Locale Area",
    "Current Events",
    "Shower Thoughts",
    "Silly Things",
    "Everything Else (default)",
  ];
  List<int> currentValue = [0, 1, 2, 3, 4, 5, 6];

  // List<bool> checkboxState = [true, true, true, true, true, true, true, true];
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Introducing ',
                    fontColor: const Color(0xff3C0061),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Chillax",
                  ),
                  CustomText(
                    text: 'Channels',
                    fontColor: const Color(0xff3C0061),
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Chillax",
                  ),
                ],
              ),
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomText(
                  text:
                      'All posts you create on Sonata are sorted\n into your own customised Channels',
                  fontColor: const Color(0xff3C0061),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Chillax",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 12.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: CustomText(
                  text:
                      'When people follow you, they can choose to follow everything, or just your Channels that interest them',
                  fontColor: const Color(0xff3C0061),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Chillax",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              Center(child: Image.asset("assets/images/channels.png")),
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
                          height: 52.h,
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
                                "assets/icons/Channel Tag.png",
                                height: 40.h,
                                width: 40.w,
                              ),
                              SizedBox(
                                width: 14.w,
                              ),
                              CustomText(
                                text: 'Channels',
                                fontColor: const Color(0xff160323),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        CustomText(
                          text:
                              'Choose some pre-made Channels to get you started. You can change them at any time on your profile page:',
                          fontColor: const Color(0xff444444),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins",
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: channelNames.length,
                          itemBuilder: (context, index) {
                            // Skip rendering the "Work" channel if age is less than 18
                            if (index == 2 && auth.dob != null) {
                              int year = int.tryParse(auth.dob!.split('-').first) ?? 0;
                              if (DateTime.now().year - year < 18) {
                                return SizedBox.shrink();
                              }
                            }


                            return Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 36.h,
                                  decoration: BoxDecoration(
                                    color: (currentValue.contains(index) ||
                                            index == 7)
                                        ? const Color(0xffF6F5FB)
                                        : const Color(0xffFFFFF),
                                    border: Border.all(
                                      color: (currentValue.contains(index) ||
                                              index == 7)
                                          ? const Color(0xffC6BEE3)
                                          : const Color(0xffF6F5FB),
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        value: currentValue.contains(index) ||
                                            index == 7,
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            if (currentValue.contains(index)) {
                                              currentValue.remove(index);
                                            } else {
                                              if (index != 7) {
                                                // Add the index only if it's not 7
                                                currentValue.add(index);
                                              }
                                            }
                                          });
                                          print(jsonEncode(currentValue));
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          side: BorderSide(
                                            width: 2,
                                            color: Colors.black,
                                          ),
                                        ),
                                        checkColor: Colors.white,
                                        activeColor: index == 7
                                            ? const Color(0xff3C0061)
                                                .withOpacity(0.5)
                                            : const Color(0xff3C0061),
                                      ),
                                      CustomText(
                                        text: channelNames[index],
                                        fontColor: const Color(0xff160323),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                              ],
                            );
                          },
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
                                auth.channelName = [];
                                auth.registerUserInfo();
                              },
                            ),
                            CustomButton(
                              height: 42.h,
                              borderRadius: (8),
                              buttonColor: const Color(0xff3C0061),
                              width: 104.w,
                              text: "Submit",
                              textColor: const Color(0xffFFFFFF),
                              textSize: 16.sp,
                              textFontWeight: FontWeight.w500,
                              fontFamily: "Chillax",
                              onPressed: () {
                                List<String> channelValue = [];
                                for (int i = 0; i < currentValue.length; i++) {
                                  channelValue
                                      .add(channelNames[currentValue[i]]);
                                }
                                print(jsonEncode(channelValue));
                                auth.channelName = channelValue;
                                auth.registerUserInfo();
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
}
