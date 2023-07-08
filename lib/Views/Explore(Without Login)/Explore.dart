import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sonata/Controllers/Explore%20Controller/Explore_controller.dart';
import 'package:sonata/Views/Create%20Profile/Create%20Profile.dart';
import 'package:sonata/Views/Sign%20In/SignIn.dart';
import 'package:sonata/Views/Widgets/CommentIcon.dart';
import 'package:sonata/Views/Widgets/FavoriteIcon.dart';
import 'package:sonata/Views/Widgets/Retweet.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';
import '../../Controllers/auth_controller.dart';
import '../../api/api_client.dart';
import '../Forgot Password/Forgot Password.dart';
import '../Widgets/CustomButton.dart';
import 'dart:convert';

import '../Widgets/customeline/DashedBorderPainter.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final auth = Get.put(AuthController());
  ScrollController scrollController = ScrollController();
  bool _isValidCredentials = true;
  bool _isSearchVisible = false;
  var expCont = Get.put(ExploreController());
  bool noMore = true;
  bool? noMoreExplore = true;

  bool apiHit = true;
  @override
  initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      apiHit ? await expCont.exploreUser() : null;
    });
    if (expCont.lengthExploreList >= 5) {
      noMore = false;
    }
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print("good");
        fetchMoreHomeData();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    expCont.isRefresh = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {  print("dataaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa${expCont.explore}");
    return GetBuilder(
        init: ExploreController(),
        builder: (exploreCont) {
          return Scaffold(
            backgroundColor: const Color(0xffE3E3E3),
            appBar: AppBar(
              leadingWidth: _isSearchVisible
                  ? 0
                  : 170.w, // Set leadingWidth to 0 when search is visible
              leading: _isSearchVisible
                  ? null
                  : Padding(
                      padding: EdgeInsets.only(left: 24.0.w),
                      child: SvgPicture.asset(
                          "assets/svg/Sonata_Logo_Main_RGB 1.svg"),
                    ),
              actions: <Widget>[
                Visibility(
                  visible: !_isSearchVisible,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 10.0.w,
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        "assets/svg/Search Noteappbar.svg",
                      ),
                      onPressed: () {
                        setState(() {
                          _isSearchVisible = true;
                        });
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: _isSearchVisible,
                  child: Expanded(
                      child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 24.0.w),
                            child: Image.asset(
                              'assets/icons/sonata.png',
                            ),
                          ),
                          SizedBox(
                            width: 24.w,
                          ),
                          Expanded(
                            child: Container(
                              height: 48.h,
                              //margin: const EdgeInsets.only(left: 81.9),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1, color: const Color(0xffC6BEE3)),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "Search for users",
                                  hintStyle: TextStyle(
                                    color: const Color(0xff727272),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                  ),
                                  border: InputBorder.none,
                                  prefixIcon: const Icon(Icons.search,
                                      color: Color(0xff727272)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
                ),
              ],
              elevation: 0.0,
              backgroundColor: const Color(0xff3C0061),
              toolbarHeight: 78.h,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                expCont.isRefresh = false;
                expCont.isRefreshApi = true;
                expCont.explorePage = 1;
                await expCont.exploreUser();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/Explore.svg",
                          color: Color(0xffFD5201),
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
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      height: 1.h,
                      width: double.infinity.w,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/mdi_latest.svg",
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
                    SizedBox(
                      height: 20.h,
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        physics: const ScrollPhysics(),
                        // shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: expCont.explore.length + 1,
                        addRepaintBoundaries: true,
                        itemBuilder: (context, index) {
                          if (index >= expCont.explore.length) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 30.0.h),
                              child: Center(
                                  child: noMoreExplore!
                                      ? CustomText(
                                          text: '',
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                        )
                                      :Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                        width: 20.w,
                                        height: 20.h,
                                        child: AnimatedCircleAnimation()),
                                  )),
                            );
                          }
                          var exploreItem = expCont.explore[index];
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
                                    height: 72.h,
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
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 50.h,
                                              height: 50.w,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                                child: exploreItem
                                                            .profileImage !=
                                                        null
                                                    ? Image.network(
                                                        String.fromCharCodes(
                                                            base64Decode(exploreItem
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4, // adjust the width as needed
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      return CustomText(
                                                        text: exploreItem
                                                            .userName,
                                                        fontColor: const Color(
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4, // adjust the width as needed
                                                  child: LayoutBuilder(
                                                    builder:
                                                        (context, constraints) {
                                                      return CustomText(
                                                        text:
                                                            "@${exploreItem.userHandle}",
                                                        fontColor: const Color(
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
                                                text: exploreItem.noteTimeAgo ??
                                                    "N/A",
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
                                  ),
                                  Visibility(
                                    visible: exploreItem.renotedId == null,
                                    child: SizedBox(
                                      height: 16.h,
                                    ),
                                  ),
                                  Visibility(
                                    visible: exploreItem.renotedId == null,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.0.w),
                                      child: Container(
                                        padding: const EdgeInsets.all(5.0),
                                        constraints: BoxConstraints(
                                          maxHeight: 40.h,
                                          maxWidth: 250.w,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: const Color(0xffC6BEE3)),
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
                                                text:
                                                    exploreItem.channelsName ??
                                                        "",
                                                fontColor:
                                                    const Color(0xff444444),
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Chillax",
                                                overflow: TextOverflow.clip,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: exploreItem.noteBody != null &&
                                        exploreItem.noteBody!.isNotEmpty,
                                    child: SizedBox(
                                      height: 16.h,
                                    ),
                                  ),
                                  Visibility(
                                    visible: exploreItem.noteBody != null &&
                                        exploreItem.noteBody!.isNotEmpty,
                                    child: Container(
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(
                                          left: 16, right: 16),
                                      child: CustomText(
                                        text: exploreItem.noteBody,
                                        fontColor: const Color(0xff444444),
                                        fontSize: 16.sp,
                                        height: 1.5,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: exploreItem.noteImage != null,
                                    child: SizedBox(
                                      height: 16.h,
                                    ),
                                  ),
                                  Visibility(
                                    visible: exploreItem.noteImage != null,
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
                                                    base64Decode(
                                                        exploreItem.noteImage ??
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
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffF7F7F7),
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
                                                    expCont.threadNoteId =
                                                        exploreItem.noteId;
                                                    expCont.viewThread();
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
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            top: 8,
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
                                                      width: 50.h,
                                                      height: 50.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
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
                                                        CustomText(
                                                          text: exploreItem
                                                                  .renotedUserName ??
                                                              "N/A",
                                                          fontColor:
                                                              Color(0xff160323),
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: "Chillax",
                                                        ),
                                                        Text(
                                                          "@${exploreItem.renotedUserHandle}",
                                                          style:
                                                              const TextStyle(
                                                            color: Color(
                                                                0xff3C0061),
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                'Chillax',
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
                                            Container(
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
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            CustomText(
                                              text: exploreItem.renotedBody ??
                                                  "N/A",
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
                                                height: null,
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
                                                                    BoxDecoration(
                                                                  color: const Color(
                                                                      0xffF7F7F7),
                                                                ),
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/svg/Image.svg"),
                                                              );
                                                            },
                                                          )
                                                        : null),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 8.h,
                                            ),
                                            Visibility(
                                              visible:
                                                  exploreItem.threadStart ??
                                                      false,
                                              child: Column(
                                                children: [
                                                  Center(
                                                    child: SizedBox(
                                                      height: 30.0,
                                                      width: 2.0,
                                                      child: CustomPaint(
                                                        painter:
                                                            DashedBorderPainter(
                                                          color: const Color(
                                                              0xff3C0061),
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
                                                        radius: const Radius
                                                            .circular(20),
                                                        color: const Color(
                                                            0xff3C0061),
                                                        dashPattern: [6, 3],
                                                        strokeWidth: 1,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          30)),
                                                          child: InkWell(
                                                            onTap: () {
                                                              expCont.threadNoteId =
                                                                  exploreItem
                                                                      .noteId;
                                                              expCont
                                                                  .viewThread();
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
                                                                      text:
                                                                          "View Thread",
                                                                      fontColor:
                                                                          const Color(
                                                                              0xff3C0061),
                                                                      fontSize:
                                                                          14.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          "Chillax",
                                                                    ),
                                                                    CustomText(
                                                                      text:
                                                                          " (+${exploreItem.threadLength.toString()})",
                                                                      fontColor:
                                                                          const Color(
                                                                              0xff868686),
                                                                      fontSize:
                                                                          12.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
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
                                                _showBottomLogin(context);
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
                                                _showBottomLogin(context);
                                              },
                                              icon: const Icon(
                                                Icons.comment_outlined,
                                                color: Color(0xff0FA958),
                                              ),
                                              label: Text(
                                                "${exploreItem.totalNoteReply.toString()}",
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
                                                _showBottomLogin(context);
                                              },
                                              icon: SvgPicture.asset(
                                                "assets/svg/mdi_renote.svg",
                                              ),
                                              label: Text(
                                                "${exploreItem.totalNoteRepost ?? "N/A"}",
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
                                          GestureDetector(
                                            onTap: () {
                                              //  _showBottomLogin(context);
                                            },
                                            child: const Icon(
                                              Icons.share,
                                              color: Color(0xff699BF7),
                                            ),
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
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              height: 92.h,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44.h,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(const CreateProfile());
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            elevation: 0,
                            onPrimary: const Color(0xFF3C0061),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(
                                width: 2,
                                color: Color(0xFF3C0061),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                text: 'Register',
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
                            Get.to(const SignIn());
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFF3C0061),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 10.0, 12.0, 10.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset("assets/svg/Sign In.svg"),
                              const SizedBox(width: 10.0),
                              CustomText(
                                text: 'Sign In',
                                fontColor: const Color(0xffFFFFFF),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _showBottomLogin(BuildContext context) {
    final formKey = GlobalKey<FormState>();
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
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Container(
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset("assets/svg/SignIn.svg"),
                                    CustomText(
                                      text: 'Sign In',
                                      fontColor: const Color(0xff160323),
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Chillax",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: _isValidCredentials
                                    ? SizedBox.shrink()
                                    : Row(
                                        children: [
                                          Center(
                                            child: Image.asset(
                                              "assets/icons/incorrect password.png",
                                              height: 18.h,
                                              width: 20.w,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          CustomText(
                                            text:
                                                'Password must contain at least one letter, one number, and one special character',
                                            fontColor: const Color(0xffDA0000),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              CustomText(
                                text: 'Email',
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
                                  controller: auth.emailContL,
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(16, 10, 16, 10),
                                    hintText: 'Enter your email address',
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
                              CustomText(
                                text: 'Password',
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
                                  controller: auth.passContL,
                                  // validator: (value) {
                                  //   if (value!.isEmpty) {
                                  //     return 'Enter your password';
                                  //   }
                                  //   return null;
                                  // },
                                  decoration: const InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(16, 10, 16, 10),
                                    hintText: 'Enter your password',
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
                                height: 8.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.to(const ForgetPassword());
                                    },
                                    child: CustomText(
                                      text: 'Forgot Password?',
                                      fontColor: const Color(0xff3C0061),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Chillax",
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 80.h,
                              ),
                              Container(
                                height: 1.h,
                                width: double.infinity.w,
                                color: const Color(0xffF6F5FB),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              CustomButton(
                                height: 48.h,
                                borderRadius: (8),
                                buttonColor: const Color(0xff3C0061),
                                width: double.infinity,
                                text: "Sign in",
                                textColor: const Color(0xffFFFFFF),
                                textSize: 16.sp,
                                textFontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                                iconPath:
                                  'assets/icons/Sign In Icon.png',
                                onPressed: () {
                                  if (auth.emailContL.text.isEmpty ||
                                      auth.passContL.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please enter your email and password'),
                                      ),
                                    );
                                  } else if (auth.emailContL.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Please enter your email address'),
                                      ),
                                    );
                                  } else if (auth.passContL.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Please enter your password'),
                                      ),
                                    );
                                  }
                                  auth.loginUser();
                                  //Get.to(NavigationBarScreen());
                                },
                              ),
                            ],
                          ),
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

  fetchMoreHomeData() async {
    print("ewgfiunlsck");
    expCont.isRefreshApi = false;
    expCont.isRefresh = false;
    noMoreExplore = false;
    setState(() {});
    if (expCont.lengthExploreList >= 5) {
      expCont.explorePage = expCont.explorePage + 1;
    } else {
      noMoreExplore = true;
      setState(() {});
      return;
    }
    await expCont.exploreUser();
    setState(() {});
  }
}
