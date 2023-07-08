import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Controllers/ProfileController/ProfileController.dart';
import '../../Controllers/auth_controller.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../SideBar/SideBar.dart';
import '../Widgets/custom_text.dart';

class Follows extends StatefulWidget {
  final int followIndex;
  const Follows({Key? key, required this.followIndex}) : super(key: key);

  @override
  State<Follows> createState() => _FollowsState();
}

class _FollowsState extends State<Follows> {
  var auth = Get.find<AuthController>();
  int followIndex = 0;
  bool isFollowing = false;
  var profileFollows = Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
    followIndex=widget.followIndex;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      profileFollows.followingUser();
      profileFollows.followersUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ProfileController(),
        builder: (profileCont) {
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child:
                                SvgPicture.asset("assets/svg/arrorback.svg")),
                        SvgPicture.asset("assets/svg/Follows.svg"),
                        SizedBox(
                          width: 20.w,
                        ),
                        CustomText(
                          text: 'Follows',
                          fontColor: const Color(0xff160323),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 2, color: Color(0xfff3C0061)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  followIndex = 0;
                                });
                              },
                              child: Container(
                                // padding: const EdgeInsets.symmetric(
                                //   horizontal: 30,
                                // ),
                                height: 30,
                                decoration: BoxDecoration(
                                  color: followIndex == 0
                                      ? const Color(0xffF6F5FB)
                                      : null,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: CustomText(
                                    text: "You Follow",
                                    fontColor: followIndex == 0
                                        ? const Color(0xff3C0061)
                                        : const Color(0xff666666),
                                    fontSize: followIndex == 1 ? 16.sp : 14.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Chillax",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  followIndex = 1;
                                });
                              },
                              child: Container(
                                height: 30,
                                // padding: const EdgeInsets.symmetric(
                                //   horizontal: 8,
                                // ),
                                // margin: EdgeInsets.only(right: 4.w),
                                decoration: BoxDecoration(
                                  color: followIndex == 1
                                      ? const Color(0xffF6F5FB)
                                      : null,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: CustomText(
                                    text: "Follows You",
                                    fontColor: followIndex == 1
                                        ? const Color(0xff3C0061)
                                        : const Color(0xff666666),
                                    fontSize: followIndex == 1 ? 16.sp : 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Chillax",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      height: 1.h,
                      width: double.infinity.w,
                      color: const Color(0xffC6BEE3),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    followIndex == 0
                        ? Column(
                            children: [
                              ListView.builder(
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: profileFollows.following.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var followItem =
                                      profileFollows.following[index];
                                  return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: Container(
                                        padding: const EdgeInsets.all(12.0),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color(0xffC6BEE3),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    // homeCont.otherHandle =
                                                    //     disItem?.userHandle;
                                                    // auth.otherUserHandel =
                                                    //     disItem?.userHandle ?? "";
                                                    // otherUserHandel =
                                                    //     disItem?.userHandle ?? "";
                                                    // auth.otherUserserProfile();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration:
                                                            const BoxDecoration(),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          child: followItem
                                                                      .profileImage !=
                                                                  null
                                                              ? Image.network(
                                                                  String.fromCharCodes(
                                                                      base64Decode(
                                                                          followItem.profileImage ??
                                                                              "")),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  errorBuilder: (BuildContext
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
                                                              : SvgPicture
                                                                  .asset(
                                                                  "assets/svg/UserProfile.svg",
                                                                ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          CustomText(
                                                            text: followItem
                                                                    .userName ??
                                                                "",
                                                            fontColor:
                                                                const Color(
                                                                    0xff444444),
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "Chillax",
                                                          ),
                                                          CustomText(
                                                            text:
                                                                "@${followItem.userHandle}",
                                                            fontColor:
                                                                const Color(
                                                                    0xff444444),
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontFamily:
                                                                "Poppins",
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 12.0),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap:() async {
                                                          print(followItem.userHandle);
                                                          print(followItem.userFollowStatus);
                                                         await profileFollows.createUsersFollow(followItem.userHandle);
                                                          followItem.userFollowStatus==0?followItem.userFollowStatus=1:followItem.userFollowStatus=0;
                                                          profileFollows.update();
                                                        },                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: followItem.userFollowStatus==0
                                                                ? Color(
                                                                0xff3C0061)
                                                                :  Colors.white,
                                                            border: Border.all(
                                                                color: const Color(
                                                                    0xff3C0061)),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(8),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 8),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize.min,
                                                            children: [
                                                              SvgPicture.asset(
                                                                "assets/svg/Following.svg",
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              CustomText(
                                                                text: followItem.userFollowStatus==1
                                                                    ? "Following"
                                                                    : "Follow",
                                                                fontColor: followItem.userFollowStatus==0
                                                                    ?  Colors.white
                                                                    : Color(
                                                                    0xff3C0061),
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    "Chillax",
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 16.h),
                                            Container(
                                              height: 1.h,
                                              width: double.infinity.w,
                                              color: const Color(0xffE7E7E7),
                                            ),
                                            SizedBox(height: 16.h),
                                            CustomText(
                                              text: followItem.profileTagline,
                                              fontColor:
                                                  const Color(0xff444444),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: "Poppins",
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                              ),
                            ],
                          )
                        : Column(
                      children: [
                        ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: profileFollows.followers.length,
                          itemBuilder: (BuildContext context, int index) {
                            var followItem =
                            profileFollows.followers[index];
                            return Padding(
                                padding:
                                const EdgeInsets.only(bottom: 16),
                                child: Container(
                                  padding: const EdgeInsets.all(12.0),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: const Color(0xffC6BEE3),
                                        width: 1),
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              // homeCont.otherHandle =
                                              //     disItem?.userHandle;
                                              // auth.otherUserHandel =
                                              //     disItem?.userHandle ?? "";
                                              // otherUserHandel =
                                              //     disItem?.userHandle ?? "";
                                              // auth.otherUserserProfile();
                                            },
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration:
                                                  const BoxDecoration(),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        5.0),
                                                    child: followItem
                                                        .profileImage !=
                                                        null
                                                        ? Image.network(
                                                      String.fromCharCodes(
                                                          base64Decode(
                                                              followItem.profileImage ??
                                                                  "")),
                                                      fit: BoxFit
                                                          .cover,
                                                      errorBuilder: (BuildContext
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
                                                        : SvgPicture
                                                        .asset(
                                                      "assets/svg/UserProfile.svg",
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .start,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    CustomText(
                                                      text: followItem
                                                          .userName ??
                                                          "",
                                                      fontColor:
                                                      const Color(
                                                          0xff444444),
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      fontFamily:
                                                      "Chillax",
                                                    ),
                                                    CustomText(
                                                      text:
                                                      "@${followItem.userHandle}",
                                                      fontColor:
                                                      const Color(
                                                          0xff444444),
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                      FontWeight
                                                          .normal,
                                                      fontFamily:
                                                      "Poppins",
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                top: 12.0),
                                            child: Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                GestureDetector(
                                                  onTap:() async {
                                                    await profileFollows.createUsersFollow(followItem.userHandle);
                                                    followItem.userFollowStatus==0?followItem.userFollowStatus=1:followItem.userFollowStatus=0;
                                                    profileFollows.update();


                                                    //profileFollows.createUsersFollow();
                                                  },
                                                  child: Container(
                                                    decoration:
                                                    BoxDecoration(
                                                      color: followItem.userFollowStatus==0
                                                          ?const Color(
                                                          0xff3C0061)
                                                          :  Colors.white,
                                                      border: Border.all(
                                                          color: const Color(
                                                              0xff3C0061)),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(8),
                                                    ),
                                                    padding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 8),
                                                    child:Row(
                                                      mainAxisSize:
                                                      MainAxisSize.min,
                                                      children: [
                                                        SvgPicture.asset(
                                                          "assets/svg/Following.svg",
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        CustomText(
                                                          text: followItem.userFollowStatus==0
                                                              ? "Follow"
                                                              : "Following",
                                                          fontColor: followItem.userFollowStatus==0
                                                              ?  Colors.white
                                                              :const Color(
                                                              0xff3C0061),
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          fontFamily:
                                                          "Chillax",
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 16.h),
                                      Container(
                                        height: 1.h,
                                        width: double.infinity.w,
                                        color: const Color(0xffE7E7E7),
                                      ),
                                      SizedBox(height: 16.h),
                                      CustomText(
                                        text: followItem.profileTagline,
                                        fontColor:
                                        const Color(0xff444444),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: "Poppins",
                                      ),
                                    ],
                                  ),
                                ));
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
