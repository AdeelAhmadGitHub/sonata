import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sonata/Controllers/ProfileController/ProfileController.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/auth_controller.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../SideBar/SideBar.dart';
import '../Widgets/custom_text.dart';

class EditLink extends StatefulWidget {
  const EditLink({Key? key}) : super(key: key);

  @override
  State<EditLink> createState() => _EditLinkState();
}

class _EditLinkState extends State<EditLink> {
  bool isSwitched = false;
  var auth = Get.find<AuthController>();
  var profile = Get.put(ProfileController());

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   label.text = auth.associatedLinks?.linkLabel ?? "";
  //   link.text = auth.associatedLinks?.customLink ?? "";
  // }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AuthController(),
        builder: (authCont) {
          return Scaffold(
            drawer: const SideBar(),
            backgroundColor: const Color(0xffE3E3E3),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(right: 12.0),
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
                            child: auth.profileModel?.profileImage != null
                                ? Image.network(
                                    String.fromCharCodes(base64Decode(
                                        auth.profileModel?.profileImage ?? "")),
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      print('Error loading image: $exception');
                                      return SvgPicture.asset(
                                        "assets/svg/UserProfile.svg",
                                      );
                                    },
                                  )
                                : SvgPicture.asset(
                                    "assets/svg/UserProfile.svg",
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
                child: Column(
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                  child: Container(
                    padding: EdgeInsets.only(top: 24.0.h),

                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/svg/Edit List.svg",
                                    color: const Color(0xffFD5201),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  CustomText(
                                    text: 'Edit My Links',
                                    fontColor: const Color(0xff160323),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Chillax",
                                  ),
                                ],
                              ),
                              InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: const Icon(
                                    Icons.clear,
                                    color: Color(0xfff444444),
                                    size: 20,
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xffC6BEE3), width: 4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 40,
                                  width: double.infinity,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Color(0xffF6F5FB),
                                        width: 2.0,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: CustomText(
                                          text: 'My Links',
                                          fontColor: const Color(0xff160323),
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Chillax",
                                        ),
                                      ),
                                      CustomText(
                                        text: 'Rename',
                                        fontColor: const Color(0xfff3C0061),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Chillax",
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 5.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xff0FA958),
                                            width: 1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isSwitched = !isSwitched;
                                                });
                                              },
                                              child: Container(
                                                width: 35,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  // Rounded corners of the switch
                                                  color: isSwitched
                                                      ? const Color(0xff0FA958)
                                                      : const Color(
                                                          0xff0FA958), // Color of the switch based on the state
                                                ),
                                                child: AnimatedAlign(
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  // Animation duration
                                                  alignment: isSwitched
                                                      ? Alignment.centerLeft
                                                      : Alignment.centerRight,
                                                  // Alignment of the thumb based on the state
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4.0,
                                                            right: 4.0),
                                                    child: Container(
                                                      width: 10,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: isSwitched
                                                            ? Colors.white
                                                            : Colors
                                                                .white, // Color of the thumb based on the state
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          CustomText(
                                            text: "Active",
                                            fontColor: const Color(0xff444444),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Chillax",
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        _showAddLink(context);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 5.0),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color(0xff3C0061),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.add,
                                                color: Color(0xffFD5201),
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              CustomText(
                                                text: "Add Link",
                                                fontColor:
                                                    const Color(0xff3C0061),
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Chillax",
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: authCont.profileModel
                                          ?.associatedLinks?.length ??
                                      0,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var link = authCont
                                        .profileModel?.associatedLinks?[index];

                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/svg/tabler_menu-order.svg",
                                              ),
                                              SizedBox(width: 10.w),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color:
                                                        const Color(0xffF6F5FB),
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        "assets/icons/ion_ticket.png"),
                                                    SizedBox(width: 12.w),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                          // adjust the width as needed
                                                          child: LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                              return CustomText(
                                                                text: link
                                                                    ?.linkLabel,
                                                                fontColor: Color(
                                                                    0xff444444),
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    "Poppins",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                          // adjust the width as needed
                                                          child: LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  if (link?.customLink !=
                                                                      null) {
                                                                    launch(
                                                                        link?.customLink ??
                                                                            "");
                                                                  }
                                                                },
                                                                child:
                                                                    CustomText(
                                                                  text: link !=
                                                                          null
                                                                      ? Uri.parse(
                                                                              link.customLink!)
                                                                          .host
                                                                      : '',
                                                                  fontColor: Color(
                                                                      0xff444444),
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontFamily:
                                                                      "Poppins",
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                              onTap: () {
                                                auth.linkEdited.text =
                                                    link?.customLink ?? "";
                                                auth.labelEdited.text =
                                                    link?.linkLabel ?? "";
                                                auth.linkIdEdited =
                                                    link?.linkId ?? 1;
                                                _showEditLink(context);
                                              },
                                              child: SvgPicture.asset(
                                                "assets/svg/Edit Icon.svg",
                                                color: const Color(0xff3C0061),
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
          );
        });
  }

  void _showEditLink(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
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
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffF6F5FB),
                          width: 2.0,
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/Edit Icon.svg",
                              color: const Color(0xffFD5201),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            CustomText(
                              text: 'Edit Link',
                              fontColor: const Color(0xff160323),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          ],
                        ),
                        SvgPicture.asset("assets/svg/Delete.svg"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Container(
                    width: 66,
                    height: 66,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Make the container circular
                      border: Border.all(
                        color: const Color(
                            0xffC6BEE3), // Border color (red in this case)
                        width: 1, // Border width
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                          color: Color(0xff3C0061),
                          width: 1,
                        ),
                      ),
                    ),
                    child: CustomText(
                      text: 'Change Link Icon',
                      fontColor: const Color(0xff3C0061),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Chillax",
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Link Label',
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
                          controller: auth.labelEdited,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            hintText: '',
                            hintStyle: TextStyle(
                                color: Color(0xff727272),
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
                        children: [
                          CustomText(
                            text: 'Link',
                            fontColor: const Color(0xff444444),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Chillax",
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          SvgPicture.asset("assets/svg/Link.svg"),
                        ],
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
                          controller: auth.linkEdited,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            hintText: '',
                            hintStyle: TextStyle(
                                color: Color(0xff727272),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.italic),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 44.h,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Get.back();
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
                          SizedBox(
                            width: 20.w,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              auth.EditLink();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFF3C0061),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 10.0, 16.0, 10.0),
                            ),
                            child: CustomText(
                              text: 'Save Link',
                              fontColor: const Color(0xffFFFFFF),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ));
      },
    );
  }

  void _showAddLink(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xffD9D9D9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      height: 50,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Color(0xffF6F5FB),
                            width: 2.0,
                            style: BorderStyle.solid,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svg/Edit Icon.svg",
                                color: const Color(0xffFD5201),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              CustomText(
                                text: 'Edit Link',
                                fontColor: const Color(0xff160323),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ],
                          ),
                          SvgPicture.asset("assets/svg/Delete.svg"),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    Container(
                      width: 66,
                      height: 66,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Make the container circular
                        border: Border.all(
                          color: const Color(
                              0xffC6BEE3), // Border color (red in this case)
                          width: 1, // Border width
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: const BorderSide(
                            color: Color(0xff3C0061),
                            width: 1,
                          ),
                        ),
                      ),
                      child: CustomText(
                        text: 'Change Link Icon',
                        fontColor: const Color(0xff3C0061),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Chillax",
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Link Label',
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
                            controller: auth.label,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintText: 'Enter text here',
                              hintStyle: TextStyle(
                                  color: Color(0xff727272),
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
                          children: [
                            CustomText(
                              text: 'Link',
                              fontColor: const Color(0xff444444),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            SvgPicture.asset("assets/svg/Link.svg"),
                          ],
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
                            controller: auth.link,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                              hintText: 'Paste link here',
                              hintStyle: TextStyle(
                                  color: Color(0xff727272),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontStyle: FontStyle.italic),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 44.h,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.back();
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
                            SizedBox(
                              width: 20.w,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                auth.createLink();
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xFF3C0061),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 10.0, 16.0, 10.0),
                              ),
                              child: CustomText(
                                text: 'Save Link',
                                fontColor: const Color(0xffFFFFFF),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
          ),
        );
      },
    );
  }
}
