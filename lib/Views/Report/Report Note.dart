import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/auth_controller.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../SideBar/SideBar.dart';
import '../Widgets/custom_text.dart';

class ReportNote extends StatefulWidget {
  const ReportNote({Key? key}) : super(key: key);

  @override
  State<ReportNote> createState() => _ReportNoteState();
}

class _ReportNoteState extends State<ReportNote> {
  var auth = Get.find<AuthController>();
  var report = Get.put(HomeController());
  final List<String> reportTypes = [
    'Abusive Language',
    'Inappropriate Image',
    'Offensive to a group of people',
  ];
  String? selectedReport;
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
          child: Column(children: [
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(width: 1, color: const Color(0xffF3EEF9))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svg/Report.svg",
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustomText(
                        text: 'Report Note',
                        fontColor: const Color(0xff160323),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Chillax",
                      ),
                    ],
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
                  Text(
                    'All fields are required unless specified otherwise',
                    style: TextStyle(
                      color: const Color(0xff767676),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Poppins',
                      fontStyle:
                          FontStyle.italic, // Apply italic style to the text
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomText(
                    text: 'Report Type',
                    fontColor: const Color(0xff444444),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Chillax",
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      isDense: true,
                      hint: Text(
                        'Choose an option',
                        style: TextStyle(
                          color: const Color(0xff8E8694),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      items: reportTypes
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: CustomText(
                                  text: item,
                                  fontColor: const Color(0xff444444),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Poppins",
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: report.reportType,
                      onChanged: (value) {
                        setState(() {
                          report.reportType = value as String;
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        height: 36.h,
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 2,
                            color: const Color(0xfffC6BEE3),
                          ),
                          color: Colors.transparent,
                        ),
                        elevation: 0,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: ImageIcon(
                            AssetImage("assets/icons/tabler_chevron-down.png")),
                        iconSize: 20,
                        iconEnabledColor: Color(0xfff444444),
                        iconDisabledColor: Colors.red,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        maxHeight: 204.h,
                        padding: null,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: 2,
                            color: const Color(0xfffC6BEE3),
                          ),
                          color: Colors.white,
                        ),
                        elevation: 0,
                        offset: const Offset(0, -5),
                        scrollbarTheme: ScrollbarThemeData(
                          radius: const Radius.circular(8),
                          thickness: MaterialStateProperty.all<double>(4),
                          thumbVisibility:
                              MaterialStateProperty.all<bool>(true),
                        ),
                      ),
                      menuItemStyleData: const MenuItemStyleData(
                        height: 40,
                        //padding: EdgeInsets.only(left: 14, right: 14),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomText(
                    text: 'Note URL',
                    fontColor: const Color(0xff444444),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Chillax",
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    height: 44.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xffFBFBFB),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CustomText(
                      text:
                          "http://sonata.seromatic.com:9501/n/${report.noteId}",
                      // text: "http://192.168.18.89:3000/n/${report.noteId}", // Replace with your URL
                      fontColor: const Color(0xff868686),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Poppins",
                      // overflow: TextOverflow.clip,
                      // maxLines: 1,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  CustomText(
                    text: 'Details',
                    fontColor: const Color(0xff444444),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Chillax",
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  Container(
                    height: 260.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffFAFAFD),
                      border:
                          Border.all(width: 1, color: const Color(0xffC6BEE3)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextFormField(
                      controller: report.details,
                      maxLines: null,
                      minLines: 1,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        hintText: 'Enter details',
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
                    height: 36.w,
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
                              report.userNoteReport();
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
                              text: 'Submit',
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
            ),
          ]),
        ),
      ),
    );
  }

  void _showLink(
    BuildContext context,
    int noteId,
  ) {
    var userNotes = report.viewsNotes();
    String noteLink = "http://192.168.18.89:3000/n/${report.noteId}";
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 48.w,
                            height: 4.h,
                            decoration:
                                const BoxDecoration(color: Color(0xffD9D9D9)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40.h,
                      ),
                      InkWell(
                        onTap: () {
                          copyNoteLink(noteLink);
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/svg/Link1.svg"),
                            SizedBox(
                              width: 12.w,
                            ),
                            Center(
                              child: CustomText(
                                text: 'Copy Note Link',
                                fontColor: const Color(0xff444444),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }

  void copyNoteLink(String noteLink) {
    Clipboard.setData(ClipboardData(text: noteLink)).then((result) {
      final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          decoration: const BoxDecoration(
            color: Color(0xfffC6BEE3),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/svg/ph_copy-bold.svg",
              ),
              const SizedBox(
                width: 13,
              ),
              CustomText(
                text: "Copied to clipboard",
                fontColor: const Color(0xff3C0061),
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins",
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );

      ScaffoldMessenger.of(Navigator.of(context).overlay!.context)
          .showSnackBar(snackBar);
    });
  }
}
