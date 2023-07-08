import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/ProfileController/ProfileController.dart';
import '../../Controllers/auth_controller.dart';
import '../../api/api_client.dart';
import '../Create Note (Replying)/Replying Notes.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../Profile View/Profile View.dart';
import '../Renote/Renote.dart';
import '../SideBar/SideBar.dart';
import '../View Notes/View Notes.dart';
import 'package:sonata/Controllers/Explore%20Controller/Explore_controller.dart';
import 'package:flutter/scheduler.dart';
import '../Widgets/customeline/DashedBorderPainter.dart';
import 'ExploreRenote.dart';

class ExploreNavigation extends StatefulWidget {
  const ExploreNavigation({Key? key}) : super(key: key);

  @override
  State<ExploreNavigation> createState() => _ExploreNavigationState();
}

class _ExploreNavigationState extends State<ExploreNavigation> {
  var auth = Get.find<AuthController>();
  var homeCont = Get.put(HomeController());
  ScrollController scrollController = ScrollController();
  bool isUserLoggedIn = false;
  bool noMore = true;
  bool? noMoreExplore = true;

  @override
  initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      homeCont.exploreUserLogin();
    });
    if (homeCont.lengthExploreList >= 5) {
      noMore = false;
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print("good");
        fetchMoreExploreData();
      }
    });
    super.initState();
  }

  void dispose() {
    // TODO: implement dispose
    homeCont.isRefresh = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomeController(),
        builder: (homeCont) {
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
            body: RefreshIndicator(
              onRefresh: () async {
                homeCont.isRefresh = false;
                homeCont.isRefreshApi = true;
                homeCont.explorePage = 1;
                await homeCont.exploreUserLogin();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () async {
                        homeCont.isRefresh = false;
                        await homeCont.exploreUserLogin();
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/Explore.png",
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          CustomText(
                            text: 'Explore',
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
                    Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffC6BEE3)),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: () async {
                        homeCont.isRefresh = false;
                        await homeCont.exploreUserLogin();
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/icons/mdi_latest.png",
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          CustomText(
                            text: 'Latest Notes',
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
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: homeCont.explore.length + 1,
                        addRepaintBoundaries: true,
                        itemBuilder: (context, index) {
                          if (index >= homeCont.explore.length) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 30.0.h),
                              child: Center(
                                  child: noMoreExplore!
                                      ? CustomText(
                                          text: '',
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SizedBox(
                                              width: 20.w,
                                              height: 20.h,
                                              child: AnimatedCircleAnimation()),
                                        )),
                            );
                          }
                          var exploreItem = homeCont.explore[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.0.h),
                            child: Container(
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
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color:
                                              Color.fromRGBO(60, 0, 97, 0.06),
                                          offset: Offset(0, 2),
                                          blurRadius: 6,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            homeCont.otherHandle =
                                                exploreItem.userHandle;
                                            otherUserHandel =
                                                exploreItem.userHandle ?? "";
                                            auth.otherUserHandel =
                                                exploreItem.userHandle ?? "";
                                            if (exploreItem.userHandle ==
                                                auth.user?.userHandle) {
                                              auth.userProfile();
                                            } else {
                                              homeCont.otherHandle =
                                                  exploreItem.userHandle;
                                              otherUserHandel =
                                                  exploreItem.userHandle ?? "";
                                              auth.otherUserserProfile();
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                  child: exploreItem
                                                              .profileImage !=
                                                          null
                                                      ? Image.network(
                                                          String.fromCharCodes(
                                                              base64Decode(
                                                                  exploreItem
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
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width *
                                                        0.4, // adjust the width as needed
                                                    child: LayoutBuilder(
                                                      builder: (context,
                                                          constraints) {
                                                        return CustomText(
                                                          text: exploreItem
                                                              .userName,
                                                          fontColor:
                                                              const Color(
                                                                  0xff160323),
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: "Chillax",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width *
                                                        0.4, // adjust the width as needed
                                                    child: LayoutBuilder(
                                                      builder: (context,
                                                          constraints) {
                                                        return CustomText(
                                                          text:
                                                              "@${exploreItem.userHandle}",
                                                          fontColor:
                                                              const Color(
                                                                  0xff3C0061),
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontFamily: "Poppins",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomText(
                                                text: exploreItem.noteTimeAgo,
                                                fontColor:
                                                    const Color(0xff767676),
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: "Poppins",
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  homeCont.noteId =
                                                      exploreItem.noteId;
                                                  homeCont.otherHandle =
                                                      exploreItem.userHandle;
                                                  if (exploreItem.userHandle ==
                                                      auth.user?.userHandle) {
                                                    _showBottomMenuOfUserExplore(
                                                      context,
                                                      exploreItem
                                                              .noteSavedStatus ??
                                                          0,
                                                      exploreItem.threadStart ??
                                                          false,
                                                      index,
                                                    );
                                                  } else {
                                                    _showBottomMenuExplore(
                                                        context,
                                                        exploreItem
                                                                .noteSavedStatus ??
                                                            0,
                                                        exploreItem
                                                                .threadStart ??
                                                            false,
                                                        exploreItem
                                                                .userFollowStatus ??
                                                            0,
                                                        index);
                                                  }
                                                },
                                                child: Row(
                                                  children: const [
                                                    Icon(
                                                      Icons.more_vert,
                                                      color: Color(0xfff444444),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: exploreItem.renotedId == null,
                                    child: SizedBox(
                                      height: 16.h,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: 16.0.w,
                                      right: 16.0.w,
                                      top: 16.0.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Visibility(
                                          visible:
                                              exploreItem.renotedId == null,
                                          child: GestureDetector(
                                            onTap: () {
                                              homeCont.otherHandle =
                                                  exploreItem.userHandle;
                                              otherUserHandel =
                                                  exploreItem.userHandle ?? "";
                                              auth.otherUserHandel =
                                                  exploreItem.userHandle ?? "";
                                              if (exploreItem.userHandle ==
                                                  auth.user?.userHandle) {
                                                auth.userProfile();
                                              } else {
                                                homeCont.otherHandle =
                                                    exploreItem.userHandle;
                                                otherUserHandel =
                                                    exploreItem.userHandle ??
                                                        "";
                                                auth.otherUserserProfile();
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              constraints: BoxConstraints(
                                                maxHeight: 40.h,
                                                maxWidth: 250.w,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 2,
                                                    color: const Color(
                                                        0xffC6BEE3)),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/svg/Channel Tag.svg',
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Flexible(
                                                    child: CustomText(
                                                      text: exploreItem
                                                              .channelsName ??
                                                          "",
                                                      fontColor: const Color(
                                                          0xff444444),
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Chillax",
                                                      overflow:
                                                          TextOverflow.clip,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                            visible:
                                                exploreItem.noteSavedStatus !=
                                                    0,
                                            child: SvgPicture.asset(
                                                "assets/svg/Save Notees.svg")),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: exploreItem.noteBody != null,
                                    child: SizedBox(
                                      height: 16.h,
                                    ),
                                  ),
                                  Visibility(
                                    visible: exploreItem.noteBody != null ||
                                        exploreItem.renotedBody != null,
                                    child: GestureDetector(
                                      onTap: () {
                                        homeCont.noteId = exploreItem.noteId;
                                        userHandel =
                                            exploreItem.userHandle ?? "";
                                        homeCont.viewNotes();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: exploreItem.noteBody != null &&
                                                exploreItem.noteBody!
                                                    .startsWith('http')
                                            ? InkWell(
                                                onTap: () {
                                                  if (exploreItem.noteBody !=
                                                      null) {
                                                    launch(
                                                        exploreItem.noteBody ??
                                                            '');
                                                  }
                                                },
                                                child: CustomText(
                                                  text: exploreItem != null
                                                      ? Uri.parse(exploreItem
                                                              .noteBody!)
                                                          .host
                                                      : '',
                                                  fontColor: Color.fromRGBO(
                                                      105,
                                                      155,
                                                      247,
                                                      1), // RGB color: (105, 155, 247)
                                                  fontSize: 16.sp,
                                                  height: 1.5,
                                                  fontFamily: 'Poppins',
                                                ),
                                              )
                                            : CustomText(
                                                text:
                                                    exploreItem.noteBody ?? "",
                                                fontColor:
                                                    const Color(0xff444444),
                                                fontSize: 16.sp,
                                                height: 1.5,
                                                fontFamily: "Poppins",
                                              ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: exploreItem.noteImage != null,
                                    child: SizedBox(
                                      height: 8.h,
                                    ),
                                  ),
                                  Visibility(
                                    visible: exploreItem.noteImage != null,
                                    child: GestureDetector(
                                      onTap: () {
                                        homeCont.noteId = exploreItem.noteId;
                                        userHandel =
                                            exploreItem.userHandle ?? "";
                                        homeCont.viewNotes();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        height: null,
                                        margin: const EdgeInsets.only(
                                            left: 16.0, right: 16.0),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(6.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: exploreItem.noteImage != null
                                              ? Image.network(
                                                  String.fromCharCodes(
                                                      base64Decode(exploreItem
                                                              .noteImage ??
                                                          "")),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    print(
                                                        'Error loading image: $exception');
                                                    return Container(
                                                      height: 178,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xffF7F7F7),
                                                      ),
                                                      child: SvgPicture.asset(
                                                          "assets/svg/Image.svg"),
                                                    );
                                                  },
                                                )
                                              : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Visibility(
                                    visible: exploreItem.threadStart ?? false,
                                    child: Column(
                                      children: [
                                        Center(
                                          child: SizedBox(
                                            height: 30.0,
                                            width: 2.0,
                                            child: CustomPaint(
                                              painter: DashedBorderPainter(
                                                color: const Color(0xff3C0061),
                                                strokeWidth: 2.0,
                                                dashWidth: 4.0,
                                                dashSpace: 3.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: SizedBox(
                                            height: 28,
                                            width: 170,
                                            child: DottedBorder(
                                              radius: const Radius.circular(20),
                                              color: const Color(0xff3C0061),
                                              dashPattern: [6, 3],
                                              strokeWidth: 1,
                                              child: ClipRRect(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(30)),
                                                child: InkWell(
                                                  onTap: () {
                                                    homeCont.threadNoteId =
                                                        exploreItem.noteId;
                                                    homeCont.viewThread();
                                                  },
                                                  child: Center(
                                                    child: Container(
                                                      height: 28,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          CustomText(
                                                            text: "View Thread",
                                                            fontColor:
                                                                const Color(
                                                                    0xff3C0061),
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "Chillax",
                                                          ),
                                                          CustomText(
                                                            text:
                                                                " (+${exploreItem.threadLength.toString()})",
                                                            fontColor:
                                                                const Color(
                                                                    0xff868686),
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontFamily:
                                                                "Poppins",
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Visibility(
                                    visible: exploreItem.renotedId != null,
                                    child: SizedBox(
                                      height: 16.h,
                                    ),
                                  ),
                                  Visibility(
                                    visible: exploreItem.renotedId != null,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 10,
                                            bottom: 16),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            left: BorderSide(
                                                width: 6,
                                                color: Color(0xff3C0061)),
                                            bottom: BorderSide(
                                                width: 6,
                                                color: Color(0xff3C0061)),
                                          ),
                                          // borderRadius: BorderRadius.only(
                                          //   bottomRight: Radius.circular(12),
                                          // ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration:
                                                          const BoxDecoration(),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(6.0),
                                                        child: exploreItem
                                                                    .renotedProfileImage !=
                                                                null
                                                            ? Image.network(
                                                                String.fromCharCodes(
                                                                    base64Decode(
                                                                        exploreItem.renotedProfileImage ??
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
                                                            : SvgPicture.asset(
                                                                "assets/svg/UserProfile.svg",
                                                                height: 50,
                                                                width: 50,
                                                              ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4, // adjust the width as needed
                                                          child: LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                              return CustomText(
                                                                text: exploreItem
                                                                    .renotedUserName,
                                                                fontColor:
                                                                    const Color(
                                                                        0xff160323),
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    "Chillax",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4, // adjust the width as needed
                                                          child: LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                              return Text(
                                                                "@${exploreItem.renotedUserHandle}",
                                                                style:
                                                                    const TextStyle(
                                                                  color: Color(
                                                                      0xff3C0061),
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      'Chillax',
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
                                                // Add more widgets here
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            GestureDetector(
                                              onTap: () {
                                                homeCont.otherHandle =
                                                    exploreItem.userHandle;
                                                otherUserHandel =
                                                    exploreItem.userHandle ??
                                                        "";
                                                auth.otherUserHandel =
                                                    exploreItem.userHandle ??
                                                        "";
                                                if (exploreItem.userHandle ==
                                                    auth.user?.userHandle) {
                                                  auth.userProfile();
                                                } else {
                                                  homeCont.otherHandle =
                                                      exploreItem.userHandle;
                                                  otherUserHandel =
                                                      exploreItem.userHandle ??
                                                          "";
                                                  auth.otherUserserProfile();
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                constraints: BoxConstraints(
                                                  maxHeight: 40.h,
                                                  maxWidth: 250.w,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: const Color(
                                                          0xffC6BEE3)),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    SvgPicture.asset(
                                                      'assets/svg/Channel Tag.svg',
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Flexible(
                                                      child: CustomText(
                                                        text: exploreItem
                                                                .renotedChannelName ??
                                                            "",
                                                        fontColor: const Color(
                                                            0xff444444),
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontFamily: "Chillax",
                                                        overflow:
                                                            TextOverflow.clip,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            CustomText(
                                              text: exploreItem.renotedBody,
                                              fontColor:
                                                  const Color(0xff444444),
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins",
                                            ),
                                            SizedBox(
                                              height: 16.h,
                                            ),
                                            Visibility(
                                              visible:
                                                  exploreItem.renotedImage !=
                                                      null,
                                              child: Container(
                                                width: double.infinity,
                                                // height: 400,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                  child: exploreItem
                                                              .renotedImage !=
                                                          null
                                                      ? Image.network(
                                                          String.fromCharCodes(
                                                              base64Decode(
                                                                  exploreItem
                                                                          .renotedImage ??
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
                                                            return Container(
                                                              height: 178,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color(
                                                                    0xffF7F7F7),
                                                              ),
                                                              child: SvgPicture
                                                                  .asset(
                                                                      "assets/svg/Image.svg"),
                                                            );
                                                          },
                                                        )
                                                      : null,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: const Color(0xFFF6F5FB),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Container(
                                            height: 30,
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                homeCont.noteId =
                                                    exploreItem.noteId;
                                                homeCont
                                                    .createNoteLike()
                                                    .then((_) {
                                                  homeCont.exploreUserLogin();
                                                });
                                              },
                                              icon: const Icon(
                                                Icons.favorite_border,
                                                color: Color(0xffCE1616),
                                              ),
                                              label: Text(
                                                exploreItem.totalNoteLikes
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Color(0xff444444),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                primary: exploreItem
                                                            .likeStatus ==
                                                        1
                                                    ? const Color(0xffFFF0F0)
                                                    : Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                            ),
                                          ),

                                          Container(
                                            height: 30,
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                replyId = exploreItem.noteId;
                                                channelId =
                                                    exploreItem.channelsId;
                                                userHandel =
                                                    exploreItem.userHandle ??
                                                        "";
                                                Get.to(const ReplyingNotes());
                                              },
                                              icon: const Icon(
                                                Icons.comment_outlined,
                                                color: Color(0xff0FA958),
                                              ),
                                              label: Text(
                                                exploreItem.totalNoteReply
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Color(0xff444444),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                shadowColor: Colors.transparent,
                                                elevation: 0,
                                                backgroundColor: exploreItem
                                                            .noteRepliedStatus ==
                                                        1
                                                    ? const Color(0xffE2F5EB)
                                                    : Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                            ),
                                          ),

                                          Container(
                                            height: 30,
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                homeCont.renoteId =
                                                    exploreItem.noteId;
                                                channelId =
                                                    exploreItem.channelsId;
                                                userHandel =
                                                    exploreItem.userHandle ??
                                                        "";
                                                selectedExplorePost =
                                                    exploreItem;
                                                Get.to(const ExploreRenote());
                                              },
                                              icon: SvgPicture.asset(
                                                "assets/svg/mdi_renote.svg",
                                              ),
                                              label: Text(
                                                exploreItem.totalNoteRepost
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Color(0xff444444),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Poppins",
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                shadowColor: Colors.transparent,
                                                elevation: 0,
                                                backgroundColor: exploreItem
                                                            .noteRenotedStatus ==
                                                        1
                                                    ? const Color(0xffF6EFFF)
                                                    : Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // const RetweetButton(),
                                          const Icon(
                                            Icons.share,
                                            color: Color(0xff699BF7),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Row(
                    //   children: [
                    //     Image.asset(
                    //       "assets/icons/Interests.png",
                    //       height: 24.h,
                    //       width: 24.w,
                    //     ),
                    //     SizedBox(
                    //       width: 10.w,
                    //     ),
                    //     CustomText(
                    //       text: 'Based on your interests',
                    //       fontColor: const Color(0xff160323),
                    //       fontSize: 18.sp,
                    //       fontWeight: FontWeight.w600,
                    //       fontFamily: "Chillax",
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 24.h,
                    // ),
                    // ListView.builder(
                    //   physics: const ScrollPhysics(),
                    //   shrinkWrap: true,
                    //   scrollDirection: Axis.vertical,
                    //   itemCount: 3,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return Padding(
                    //       padding: EdgeInsets.only(bottom: 16.0.h),
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           Get.to(const ViewNotes());
                    //         },
                    //         child: Container(
                    //           width: double.infinity,
                    //           decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             borderRadius: BorderRadius.circular(12),
                    //           ),
                    //           //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
                    //           child: Column(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               Container(
                    //                 width: double.infinity,
                    //                 height: 72.h,
                    //                 padding: const EdgeInsets.symmetric(
                    //                     vertical: 12, horizontal: 16),
                    //                 decoration: BoxDecoration(
                    //                   color: Colors.white,
                    //                   boxShadow: const [
                    //                     BoxShadow(
                    //                       color:
                    //                           Color.fromRGBO(60, 0, 97, 0.06),
                    //                       offset: Offset(0, 2),
                    //                       blurRadius: 6,
                    //                     )
                    //                   ],
                    //                   borderRadius: BorderRadius.circular(12),
                    //                 ),
                    //                 child: Row(
                    //                   mainAxisAlignment:
                    //                       MainAxisAlignment.spaceBetween,
                    //                   crossAxisAlignment:
                    //                       CrossAxisAlignment.start,
                    //                   children: [
                    //                     Row(
                    //                       children: [
                    //                         Container(
                    //                           width: 50.h,
                    //                           height: 50.w,
                    //                           decoration: BoxDecoration(
                    //                             borderRadius:
                    //                                 BorderRadius.circular(8),
                    //                             image: DecorationImage(
                    //                               image: AssetImage(
                    //                                 ExModel.dummyData[index]
                    //                                     .profile,
                    //                               ),
                    //                               fit: BoxFit.cover,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                         const SizedBox(
                    //                           width: 10,
                    //                         ),
                    //                         Column(
                    //                           mainAxisAlignment:
                    //                               MainAxisAlignment.start,
                    //                           crossAxisAlignment:
                    //                               CrossAxisAlignment.start,
                    //                           children: [
                    //                             CustomText(
                    //                               text: ExModel
                    //                                   .dummyData[index].name,
                    //                               fontColor:
                    //                                   const Color(0xff160323),
                    //                               fontSize: 16.sp,
                    //                               fontWeight: FontWeight.w600,
                    //                               fontFamily: "Chillax",
                    //                             ),
                    //                             CustomText(
                    //                               text: ExModel
                    //                                   .dummyData[index].gmail,
                    //                               fontColor:
                    //                                   const Color(0xff3C0061),
                    //                               fontSize: 14.sp,
                    //                               fontWeight: FontWeight.w300,
                    //                               fontFamily: "Poppins",
                    //                             ),
                    //                           ],
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     Padding(
                    //                       padding: const EdgeInsets.only(
                    //                           top: 12.0),
                    //                       child: Row(
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.center,
                    //                         mainAxisAlignment:
                    //                             MainAxisAlignment.center,
                    //                         children: [
                    //                           CustomText(
                    //                             text: '2h',
                    //                             fontColor:
                    //                                 const Color(0xff767676),
                    //                             fontSize: 14.sp,
                    //                             fontWeight: FontWeight.w300,
                    //                             fontFamily: "Poppins",
                    //                           ),
                    //                           SizedBox(
                    //                             width: 16.w,
                    //                           ),
                    //                           GestureDetector(
                    //                             onTap: () {
                    //                               _showBottomMenu(context);
                    //                             },
                    //                             child: Row(
                    //                               children: const [
                    //                                 Icon(
                    //                                   Icons.more_vert,
                    //                                   color:
                    //                                       Color(0xfff444444),
                    //                                 ),
                    //                               ],
                    //                             ),
                    //                           )
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ],
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 height: 16.h,
                    //               ),
                    //               Padding(
                    //                 padding: EdgeInsets.symmetric(
                    //                     horizontal: 16.0),
                    //                 child: Container(
                    //                   padding: EdgeInsets.symmetric(
                    //                       horizontal: 8, vertical: 4),
                    //                   decoration: BoxDecoration(
                    //                     border: Border.all(
                    //                         width: 2,
                    //                         color: const Color(0xffC6BEE3)),
                    //                     borderRadius:
                    //                         BorderRadius.circular(8),
                    //                   ),
                    //                   child: Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.center,
                    //                     crossAxisAlignment:
                    //                         CrossAxisAlignment.center,
                    //                     mainAxisSize: MainAxisSize.min,
                    //                     children: [
                    //                       Image.asset(
                    //                           'assets/images/Channel Tag.jpg'),
                    //                       const SizedBox(width: 4),
                    //                       CustomText(
                    //                         text: 'Channel',
                    //                         fontColor:
                    //                             const Color(0xff444444),
                    //                         fontSize: 14.sp,
                    //                         fontWeight: FontWeight.w500,
                    //                         fontFamily: "Chillax",
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 height: 16.h,
                    //               ),
                    //               Container(
                    //                 width: double.infinity,
                    //                 margin: const EdgeInsets.only(
                    //                     left: 16, right: 16),
                    //                 child: CustomText(
                    //                   text: ExModel
                    //                       .dummyData[index].description,
                    //                   fontColor: const Color(0xff444444),
                    //                   fontSize: 16.sp,
                    //                   height: 1.5,
                    //                   fontFamily: "Poppins",
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 height: 16.h,
                    //               ),
                    //               Visibility(
                    //                 visible: ExModel.dummyData[index].image !=
                    //                     null,
                    //                 child: Container(
                    //                   width: double.infinity,
                    //                   height: 200.h,
                    //                   margin: const EdgeInsets.only(
                    //                       left: 16.0, right: 16.0),
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.white,
                    //                     borderRadius:
                    //                         BorderRadius.circular(6.0),
                    //                     image: DecorationImage(
                    //                       image: AssetImage(
                    //                         ExModel.dummyData[index].image ??
                    //                             "",
                    //                       ),
                    //                       fit: BoxFit.cover,
                    //                     ),
                    //                   ),
                    //                   // child: Image.asset(
                    //                   //   ExploreModel.dummyData[index].image ?? "",
                    //                   //   height: 200.h,
                    //                   //   fit: BoxFit.cover,
                    //                   // ),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 height: 16.h,
                    //               ),
                    //               Padding(
                    //                 padding: const EdgeInsets.symmetric(
                    //                     horizontal: 16.0),
                    //                 child: Container(
                    //                   // padding: EdgeInsets.symmetric(vertical: 10.h),
                    //                   width: double.infinity,
                    //                   // height: 50.h,
                    //                   decoration: BoxDecoration(
                    //                     color: Colors.transparent,
                    //                     borderRadius:
                    //                         BorderRadius.circular(8),
                    //                     border: Border.all(
                    //                       color: const Color(0xFFF6F5FB),
                    //                       width: 1,
                    //                     ),
                    //                   ),
                    //                   child: Row(
                    //                     mainAxisAlignment:
                    //                         MainAxisAlignment.spaceAround,
                    //                     children: [
                    //                       // Row(
                    //                       //   mainAxisSize: MainAxisSize.min,
                    //                       //   children: [
                    //                       //     IconButton(
                    //                       //       icon: Icon(
                    //                       //         _liked
                    //                       //             ? Icons.favorite
                    //                       //             : Icons.favorite_border,
                    //                       //         color:
                    //                       //             const Color(0x8ace1616),
                    //                       //       ),
                    //                       //     ),
                    //                       //     CustomText(
                    //                       //       text: "",
                    //                       //       fontColor:
                    //                       //           const Color(0xff444444),
                    //                       //       fontSize: 12.sp,
                    //                       //       fontWeight: FontWeight.w400,
                    //                       //       fontFamily: "Poppins",
                    //                       //     ),
                    //                       //   ],
                    //                       // ),
                    //                       // GestureDetector(
                    //                       //   onTap: () {
                    //                       //     _addComment();
                    //                       //     // Open comment dialog here
                    //                       //   },
                    //                       //   child: Row(
                    //                       //     mainAxisSize: MainAxisSize.min,
                    //                       //     children: [
                    //                       //       const Icon(
                    //                       //         Icons.comment_outlined,
                    //                       //         color: Color(0xff0FA958),
                    //                       //       ),
                    //                       //       const SizedBox(width: 8.0),
                    //                       //       Text(
                    //                       //         _retweetCount.toString(),
                    //                       //         style: const TextStyle(
                    //                       //           color: Color(0xff444444),
                    //                       //           fontSize: 12.0,
                    //                       //           fontWeight:
                    //                       //               FontWeight.w400,
                    //                       //           fontFamily: "Poppins",
                    //                       //         ),
                    //                       //       ),
                    //                       //     ],
                    //                       //   ),
                    //                       // ),
                    //                       // GestureDetector(
                    //                       //   onTap: _toggleRetweeted,
                    //                       //   child: Row(
                    //                       //     mainAxisSize: MainAxisSize.min,
                    //                       //     children: [
                    //                       //       Image.asset(
                    //                       //         _retweeted
                    //                       //             ? 'assets/icons/retweet.png'
                    //                       //             : 'assets/icons/retweet.png',
                    //                       //         height: 20.w,
                    //                       //         width: 20.w,
                    //                       //       ),
                    //                       //       const SizedBox(width: 8.0),
                    //                       //       Text(
                    //                       //         _commentCount.toString(),
                    //                       //         style: const TextStyle(
                    //                       //           color: Color(0xff444444),
                    //                       //           fontSize: 12.0,
                    //                       //           fontWeight:
                    //                       //               FontWeight.w400,
                    //                       //           fontFamily: "Poppins",
                    //                       //         ),
                    //                       //       ),
                    //                       //     ],
                    //                       //   ),
                    //                       // ),
                    //                       GestureDetector(
                    //                         onTap: () {
                    //                           _showShare(context);
                    //                         },
                    //                         child: const Icon(
                    //                           Icons.share,
                    //                           color: Color(0xff699BF7),
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   ),
                    //                 ),
                    //               ),
                    //               SizedBox(
                    //                 height: 16.h,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _showBottomMenuExplore(
    BuildContext context,
    int saveNoteStatus,
    bool threadStart,
    int userFollowStatus,
    int index,
  ) {
    print(
        "?????????????????????????????????????${saveNoteStatus}??????????????????????????????????????????????/");
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
                        onTap: () async {
                          bool isHitApi = await homeCont.saveNote() ?? false;
                          if (isHitApi) {
                            homeCont.explore[index].noteSavedStatus == 0
                                ? homeCont.explore[index].noteSavedStatus = 1
                                : homeCont.explore[index].noteSavedStatus = 0;
                            Navigator.pop(context);
                            homeCont.homeUser();
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: CustomText(
                              text: homeCont.explore[index].noteSavedStatus == 0
                                  ? "Note Not Saved"
                                  : "Note Not remove",
                            )));
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (saveNoteStatus == 0)
                              SvgPicture.asset("assets/svg/Save Note (1).svg")
                            else
                              SvgPicture.asset("assets/svg/Remove Note.svg"),
                            SizedBox(
                              width: 12.w,
                            ),
                            CustomText(
                                text: (threadStart == true)
                                    ? (saveNoteStatus == 0
                                        ? 'Save Thread'
                                        : 'Remove from Save Thread')
                                    : (saveNoteStatus == 0
                                        ? 'Save Note'
                                        : 'Remove from Save Note'),
                                fontColor: const Color(0xff444444),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffE7E7E7),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      GestureDetector(
                        onTap: () async {
                          bool isHitApi = await homeCont.createUserFollow();
                          if (isHitApi) {
                            homeCont.explore[index].userFollowStatus == 0
                                ? homeCont.explore[index].userFollowStatus = 1
                                : homeCont.explore[index].userFollowStatus = 0;
                            Navigator.pop(context);
                            homeCont.homeUser();
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: CustomText(
                              text:
                                  homeCont.explore[index].userFollowStatus == 0
                                      ? "Note Not Saved"
                                      : "Note Not remove",
                            )));
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (userFollowStatus == 0)
                              SvgPicture.asset("assets/svg/Follow.svg")
                            else
                              SvgPicture.asset("assets/svg/Unfollow.svg"),
                            SizedBox(
                              width: 12.w,
                            ),
                            CustomText(
                              text: (userFollowStatus == 0)
                                  ? "Follow User"
                                  : "Unfollow User",
                              fontColor: const Color(0xff444444),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffE7E7E7),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      GestureDetector(
                        onTap: () async {
                          try {
                            await homeCont.userInteractionsMute();
                            Navigator.pop(context);
                            await homeCont.exploreUserLogin();
                          } catch (e) {
                            // Handle any errors that occur during the API calls
                            print('Error: $e');
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/svg/Mute.svg"),
                            SizedBox(
                              width: 12.w,
                            ),
                            CustomText(
                              text: 'Mute User',
                              fontColor: const Color(0xff444444),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffE7E7E7),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          homeCont.userInteractionsBlocked();
                          Navigator.pop(context);
                          homeCont.homeUser();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/svg/Block.svg"),
                            SizedBox(
                              width: 12.w,
                            ),
                            CustomText(
                              text: 'Block User',
                              fontColor: const Color(0xff444444),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffE7E7E7),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          //  homeCont.noteId = noteId;
                          //  Get.to(const ReportNote());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/Report.png"),
                            SizedBox(
                              width: 12.w,
                            ),
                            CustomText(
                              text: 'Report User',
                              fontColor: const Color(0xffC80000),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }

  void _showBottomMenuOfUserExplore(
      BuildContext context, int saveNoteStatus, bool threadStart, int index) {
    print(saveNoteStatus);
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
                        onTap: () async {
                          bool isHitApi = await homeCont.saveNote() ?? false;
                          if (isHitApi) {
                            homeCont.explore[index].noteSavedStatus == 0
                                ? homeCont.explore[index].noteSavedStatus = 1
                                : homeCont.explore[index].noteSavedStatus = 0;
                            Navigator.pop(context);
                            homeCont.exploreUserLogin();
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: CustomText(
                              text: homeCont.explore[index].noteSavedStatus == 0
                                  ? "Note Not Saved"
                                  : "Note Not remove",
                            )));
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (saveNoteStatus == 0)
                              SvgPicture.asset("assets/svg/Save Note (1).svg")
                            else
                              SvgPicture.asset("assets/svg/Remove Note.svg"),
                            SizedBox(
                              width: 12.w,
                            ),
                            CustomText(
                                text: (threadStart == true)
                                    ? (saveNoteStatus == 0
                                        ? 'Save Thread'
                                        : 'Remove from Save Thread')
                                    : (saveNoteStatus == 0
                                        ? 'Save Note'
                                        : 'Remove from Save Note'),
                                fontColor: const Color(0xff444444),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffE7E7E7),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      InkWell(
                        onTap: () {
                          deleteBottomSheet(context);
                          Navigator.pop(context);
                          homeCont.exploreUserLogin();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/svg/Delete.svg"),
                            SizedBox(
                              width: 12.w,
                            ),
                            CustomText(
                              text: 'Delete Note',
                              fontColor: const Color(0xffC80000),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
    );
  }

  Future<void> deleteBottomSheet(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: SvgPicture.asset("assets/svg/Delete.svg"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: CustomText(
                        text: 'Are you sure you want to delete?',
                        fontColor: const Color(0xff3C0061),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Poppins",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 2.h,
                      width: double.infinity.w,
                      color: const Color(0xffE7E7E7),
                    ),
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
                                    fontColor: const Color(0xff3C0061),
                                    fontSize: 16.sp,
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
                                homeCont.deleteNote().then((_) {
                                  Navigator.pop(context);
                                  homeCont.exploreUserLogin();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xFF3C0061),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 10.0, 12.0, 10.0),
                              ),
                              child: CustomText(
                                text: 'Yes',
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
            ));
      },
    );
  }

  void _showLink(
    BuildContext context,
    int homeItem,
  ) {
    var userNotes = homeCont.viewsNotes();
    String noteLink = "http://192.168.18.89:3000/n/$homeItem";
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

  fetchMoreExploreData() async {
    print("ewgfiunlsck");
    homeCont.isRefreshApi = false;
    homeCont.isRefresh = false;
    noMoreExplore = false;
    setState(() {});
    if (homeCont.lengthExploreList >= 5) {
      homeCont.explorePage = homeCont.explorePage + 1;
    } else {
      noMoreExplore = true;
      setState(() {});
      return;
    }
    await homeCont.exploreUserLogin();
    setState(() {});
  }
}
