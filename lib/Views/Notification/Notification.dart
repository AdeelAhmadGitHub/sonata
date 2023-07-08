import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sonata/Controllers/HomeController/HomeController.dart';

import '../../Controllers/Get Notification Controller/Get Notification Controller.dart';
import '../../Controllers/ProfileController/ProfileController.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../Profile View/Profile View.dart';
import '../SideBar/SideBar.dart';
import '../Widgets/custom_text.dart';
import '../../Controllers/auth_controller.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  //final List<ExModel> list = ExModel.dummyData;
  var auth = Get.find<AuthController>();
  var homeCont = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder(
        init: getNotificationController(),
        builder: (notiCont) {
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
                    GestureDetector(
                      onTap: () {
                        Get.offAll(const NavigationBarScreen());
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
                                    String.fromCharCodes(base64Decode(
                                        auth.user?.profileImage ?? "")),
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
                                    height: 50,
                                    width: 50,
                                  ),
                          ),
                        ),
                      ),
                    ),
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
                        Image.asset("assets/icons/Notifications.png"),
                        SizedBox(
                          width: 10.w,
                        ),
                        CustomText(
                          text: 'Notifications',
                          fontColor: const Color(0xff160323),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffC6BEE3)),
                    SizedBox(height: 16.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: notiCont.getNoti.length,
                          itemBuilder: (BuildContext context, int index) {
                            var notification = notiCont.getNoti[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Container(
                                padding: const EdgeInsets.all(12.0),
                                width: double.infinity,
                                height: null,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: const Color(0xffC6BEE3), width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 10.h,
                                              width: 10,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xffFD5201),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                                child:
                                                    notification.profileImage !=
                                                            null
                                                        ? Image.network(
                                                            String.fromCharCodes(
                                                                base64Decode(
                                                                    notification
                                                                            .profileImage ??
                                                                        "")),
                                                            fit: BoxFit.cover,
                                                            errorBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Object
                                                                        exception,
                                                                    StackTrace?
                                                                        stackTrace) {
                                                              print(
                                                                  'Error loading image: $exception');
                                                              return SvgPicture
                                                                  .asset(
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
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                homeCont.otherHandle =
                                                    notification
                                                        .notificationUserHandle;
                                                auth.otherUserHandel = notification
                                                        .notificationUserHandle ??
                                                    "";
                                                otherUserHandel = notification
                                                        .notificationUserHandle ??
                                                    "";
                                                notiCont.notificationId =
                                                    notification.notificationId;
                                                notiCont.viewNotification();
                                                if (notification
                                                        .notificationType ==
                                                    "note.liked") {
                                                  notiCont.noteId =
                                                      notification.noteId;
                                                  notiCont.viewNotes();
                                                } else if (notification
                                                        .notificationType ==
                                                    "note.replied") {
                                                  notiCont.noteId =
                                                      notification.noteId;
                                                  notiCont.viewNotes();
                                                } else if (notification
                                                        .notificationType ==
                                                    "note.renoted") {
                                                  notiCont.noteId =
                                                      notification.noteId;
                                                  notiCont.viewNotes();
                                                } else if (notification
                                                        .notificationType ==
                                                    "user.followed") {
                                                  notiCont.viewNotification();
                                                  auth.otherUserserProfile();
                                                }
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width *
                                                        0.5, // adjust the width as needed
                                                    child: LayoutBuilder(
                                                      builder: (context,
                                                          constraints) {
                                                        return RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: notification
                                                                        .notificationUserName ??
                                                                    "",
                                                                style:
                                                                    TextStyle(
                                                                  color: const Color(
                                                                      0xff444444),
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      "Poppins",
                                                                ),
                                                              ),
                                                              const TextSpan(
                                                                text: " ",
                                                              ),
                                                              if (notification
                                                                      .notificationType ==
                                                                  "note.liked")
                                                                TextSpan(
                                                                  text:
                                                                      "liked your post",
                                                                  style:
                                                                      TextStyle(
                                                                    color: const Color(
                                                                        0xff444444),
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                  ),
                                                                )
                                                              else if (notification
                                                                      .notificationType ==
                                                                  "note.replied")
                                                                TextSpan(
                                                                  text:
                                                                      "commented on your post",
                                                                  style:
                                                                      TextStyle(
                                                                    color: const Color(
                                                                        0xff444444),
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        "Poppins",
                                                                  ),
                                                                )
                                                              else if (notification
                                                                      .notificationType ==
                                                                  "note.renoted")
                                                                TextSpan(
                                                                  text:
                                                                      "re-noted your post",
                                                                  style:
                                                                      TextStyle(
                                                                    color: const Color(
                                                                        0xff444444),
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        "Poppins",
                                                                  ),
                                                                )
                                                              else if (notification
                                                                      .notificationType ==
                                                                  "user.followed")
                                                                TextSpan(
                                                                  text:
                                                                      "has followed you",
                                                                  style:
                                                                      TextStyle(
                                                                    color: const Color(
                                                                        0xff444444),
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        "Poppins",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .clip,
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  CustomText(
                                                    text: notification
                                                        .notificationTimeAgo,
                                                    fontColor:
                                                        const Color(0xff767676),
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 35.h,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
