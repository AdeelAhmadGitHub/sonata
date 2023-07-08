import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sonata/Views/Discover/Discover.dart';
import 'package:sonata/Views/NaviationBar/NavigationBarScreen.dart';

import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/ProfileController/ProfileController.dart';
import '../../Controllers/Search Controller/SearchController.dart';
import '../../Controllers/auth_controller.dart';
import '../../Controllers/userUsingSonataController/userUsingSonataControlloer.dart';
import '../../Models/UserModel/UserModel.dart';
import '../Explore Navigation/Explore Navigation.dart';
import '../Follow Button/Follow Button.dart';
import '../SideBar/SideBar.dart';
import '../Widgets/custom_text.dart';
import 'Searching Screen/Searching Screen.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  var auth = Get.find<AuthController>();
  var discoverCont = Get.put(userUsingSonataController());
  TextEditingController searchController = TextEditingController();
  var searchCont = Get.put(SearchingController());
  ScrollController _scrollController = ScrollController();
  double _blackLinePosition = 0.0;
  bool isFollowing = false;
  Map<String, bool> followingMap = {};
  int _currentIndex = 0;
  Map<String, bool> _followingMap = {};
  var homeCont = Get.put(HomeController());
  @override
  initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      searchCont.latestNotes();
      discoverCont.createUserFollow();
    });
    super.initState();
  }

  void _handleFollow(String userHandle) async {
    _followingMap[userHandle] = true;
    discoverCont.followHandle = userHandle;
    await discoverCont.createUserFollow();
    _followingMap[userHandle] = true;
    setState(() {
      isFollowing = true;
    });
    discoverCont.isRefresh = true;
    await discoverCont.userUsingSonata();
    discoverCont.update();
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isFollowing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SearchingController(),
        builder: (userCont) {
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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Stack(
                      children: [
                        Obx(
                          () => searchCont.isSearchingVisible.value
                              ? Container(
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        height: 48.h,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            width: 1,
                                            color: const Color(0xffC6BEE3),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.search,
                                                color: Color(0xff727272)),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: TextField(
                                                  autofocus: true,
                                                  cursorColor:
                                                      Color(0xff3C0061),
                                                  onSubmitted: (value) {
                                                    if (value.isEmpty) {
                                                      searchCont
                                                          .isSearchingVisible
                                                          .value = false;
                                                    } else {
                                                      searchCont
                                                          .searchUser(value);
                                                    }
                                                  },
                                                  controller: searchController,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    suffixIcon: IconButton(
                                                      icon: const Icon(
                                                          Icons.clear,
                                                          color: Color(
                                                              0xff727272)),
                                                      onPressed: () {
                                                        searchController
                                                            .clear();
                                                        searchCont
                                                            .isSearchingVisible
                                                            .value = false;
                                                        searchCont.searchModel
                                                            .clear();
                                                      },
                                                    ),
                                                    hintText:
                                                        "Search for users",
                                                    hintStyle: TextStyle(
                                                      color: const Color(
                                                          0xff727272),
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: "Poppins",
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    searchCont
                                                        .searchUser(value);
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (searchCont.searchModel.isNotEmpty)
                                        Column(
                                          children: [
                                            SizedBox(height: 20.h),
                                            Container(
                                              height: 450,
                                              padding: const EdgeInsets.only(
                                                  left: 16.0,
                                                  right: 8,
                                                  top: 16,
                                                  bottom: 16),
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: Border.all(
                                                    width: 1,
                                                    color: const Color(
                                                        0xffC6BEE3)),
                                              ),
                                              child: NotificationListener<
                                                  ScrollNotification>(
                                                onNotification:
                                                    (ScrollNotification
                                                        notification) {
                                                  if (notification
                                                      is ScrollUpdateNotification) {
                                                    double scrollPosition =
                                                        notification
                                                            .metrics.pixels;
                                                    double maxScrollExtent =
                                                        notification.metrics
                                                            .maxScrollExtent;
                                                    double containerHeight =
                                                        450;
                                                    double redLineHeight =
                                                        containerHeight;
                                                    double blackLineHeight =
                                                        214.87;

                                                    double
                                                        maxBlackLinePosition =
                                                        redLineHeight -
                                                            blackLineHeight;
                                                    double
                                                        newBlackLinePosition =
                                                        (scrollPosition /
                                                                maxScrollExtent) *
                                                            maxBlackLinePosition;

                                                    if (newBlackLinePosition
                                                        .isNaN) {
                                                      newBlackLinePosition =
                                                          0.0;
                                                    } else if (newBlackLinePosition
                                                        .isInfinite) {
                                                      newBlackLinePosition =
                                                          maxBlackLinePosition;
                                                    } else if (newBlackLinePosition <
                                                        0) {
                                                      newBlackLinePosition =
                                                          0.0;
                                                    } else if (newBlackLinePosition >
                                                        maxBlackLinePosition) {
                                                      newBlackLinePosition =
                                                          maxBlackLinePosition;
                                                    }

                                                    setState(() {
                                                      _blackLinePosition =
                                                          newBlackLinePosition;
                                                    });
                                                  }
                                                  return false;
                                                },
                                                child: Stack(
                                                  children: [
                                                    SingleChildScrollView(
                                                      controller:
                                                          _scrollController,
                                                      physics:
                                                          const ScrollPhysics(),
                                                      child: userCont
                                                              .searchModel
                                                              .isEmpty
                                                          ? Center(
                                                              child: Text(
                                                                  "No Data Found"
                                                                      .tr))
                                                          : ListView.builder(
                                                              controller:
                                                                  _scrollController,
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount: userCont
                                                                  .searchModel
                                                                  .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                final searcUser =
                                                                    userCont.searchModel[
                                                                        index];
                                                                print(searcUser
                                                                    .userName);
                                                                return Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          16),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          homeCont.otherHandle =
                                                                              searcUser?.userHandle;
                                                                          auth.otherUserHandel =
                                                                              searcUser?.userHandle ?? "";
                                                                          otherUserHandel =
                                                                              searcUser?.userHandle ?? "";
                                                                          auth.otherUserserProfile();
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Container(
                                                                              width: 50,
                                                                              height: 50,
                                                                              decoration: const BoxDecoration(),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(6.0),
                                                                                child: searcUser.profileImage != null
                                                                                    ? Image.network(
                                                                                        String.fromCharCodes(base64Decode(searcUser.profileImage ?? "")),
                                                                                        fit: BoxFit.cover,
                                                                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
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
                                                                            const SizedBox(width: 10),
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                CustomText(
                                                                                  text: searcUser.userName,
                                                                                  fontColor: const Color(0xff444444),
                                                                                  fontSize: 16.sp,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  fontFamily: "Poppins",
                                                                                ),
                                                                                const SizedBox(
                                                                                  height: 8,
                                                                                ),
                                                                                CustomText(
                                                                                  text: "${searcUser.userHandle}",
                                                                                  fontColor: const Color(0xff444444),
                                                                                  fontSize: 14.sp,
                                                                                  fontWeight: FontWeight.w300,
                                                                                  fontFamily: "Poppins",
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            8,
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            1,
                                                                        width: double
                                                                            .infinity,
                                                                        color: const Color(
                                                                            0xffF6F5FB),
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            12,
                                                                      ),
                                                                      CustomText(
                                                                        text: searcUser
                                                                            .profileTagline,
                                                                        fontColor:
                                                                            const Color(0xff444444),
                                                                        fontSize:
                                                                            12.sp,
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                        fontFamily:
                                                                            "Poppins",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                    ),
                                                    Positioned(
                                                      right: 0,
                                                      top: 0,
                                                      bottom: 0,
                                                      child: Container(
                                                        width: 4,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xffF4F4F4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 0,
                                                      top: _blackLinePosition
                                                              .isNaN
                                                          ? 0.0
                                                          : _blackLinePosition,
                                                      child: Container(
                                                        width: 4,
                                                        height: 214.87,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xff868686),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 35.h,
                                            )
                                          ],
                                        ),
                                    ],
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    searchCont.showSearch();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    height: 48.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 1,
                                          color: const Color(0xffC6BEE3)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.search,
                                            color: Color(0xff727272)),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        CustomText(
                                          text: "Search for users",
                                          fontColor: const Color(0xff727272),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Poppins",
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfffFAF8F5),
                        border: Border.all(
                            color: const Color(0xffEAE4D9), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 12.h),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/mdi_latest.png",
                                  height: 24.h,
                                  width: 24.w,
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
                          SizedBox(height: 12.h),
                          ListView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: searchCont.latestnote.length,
                            itemBuilder: (BuildContext context, int index) {
                              var searchItem = searchCont.latestnote[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, bottom: 16),
                                child: GestureDetector(
                                  onTap: () {
                                    homeCont.noteId = searchItem.noteId;
                                    homeCont.viewNotes();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12.0),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color(0xffEAE4D9),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                      child: searchItem
                                                                  .profileImage !=
                                                              null
                                                          ? Image.network(
                                                              String.fromCharCodes(
                                                                  base64Decode(
                                                                      searchItem
                                                                              .profileImage ??
                                                                          "")),
                                                              fit: BoxFit.cover,
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
                                                    )),
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
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.5,
                                                      // adjust the width as needed
                                                      child: LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          return CustomText(
                                                            text: searchItem
                                                                    .userName ??
                                                                "",
                                                            fontColor:
                                                                const Color(
                                                                    0xff160323),
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontFamily:
                                                                "Chillax",
                                                            // maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.3,
                                                      // adjust the width as needed
                                                      child: LayoutBuilder(
                                                        builder: (context,
                                                            constraints) {
                                                          return CustomText(
                                                            text:
                                                                "@${searchItem.userHandle}",
                                                            fontColor:
                                                                const Color(
                                                                    0xff3C0061),
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontFamily:
                                                                "Poppins",
                                                            // maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            // Padding(
                                            //   padding: const EdgeInsets.only(
                                            //       top: 12.0),
                                            //   child: Row(
                                            //     crossAxisAlignment:
                                            //         CrossAxisAlignment.center,
                                            //     mainAxisAlignment:
                                            //         MainAxisAlignment.center,
                                            //     children: [
                                            //       GestureDetector(
                                            //         onTap: () {
                                            //           _showBottomMenu(context);
                                            //         },
                                            //         child: Row(
                                            //           children: const [
                                            //             Icon(
                                            //               Icons.more_vert,
                                            //               color:
                                            //                   Color(0xfff444444),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       )
                                            //     ],
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                        Visibility(
                                          visible: searchItem.noteBody != null,
                                          child: SizedBox(
                                            height: 8.h,
                                          ),
                                        ),
                                        Visibility(
                                          visible: searchItem.noteBody !=
                                                  null &&
                                              searchItem.noteBody!.isNotEmpty,
                                          child: Container(
                                            width: double.infinity,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              searchItem.noteBody ?? '',
                                              style: TextStyle(
                                                color: const Color(0xff444444),
                                                fontSize: 16.sp,
                                                height: 1.5,
                                                fontFamily: "Poppins",
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const ExploreNavigation();
                              }));
                            },
                            child: CustomText(
                              text: 'Show More',
                              fontColor: const Color(0xff330320),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xfffFAF8F5),
                        border: Border.all(
                            color: const Color(0xffEAE4D9), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 12.h),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/icons/Discover.png",
                                  height: 24.h,
                                  width: 24.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                CustomText(
                                  text: 'Discover',
                                  fontColor: const Color(0xff160323),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Chillax",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          StatefulBuilder(builder:
                              (BuildContext context, StateSetter setState) {
                            return ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: discoverCont.userUsingSonataModel
                                      ?.jsonSideArray?.length ??
                                  0,
                              itemBuilder: (BuildContext context, int index) {
                                var disItem = discoverCont.userUsingSonataModel
                                    ?.jsonSideArray?[index];
                                bool isFollowing =
                                    _followingMap[disItem?.userHandle ?? ""] ??
                                        false;

                                return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 16.0, bottom: 16),
                                  child: Visibility(
                                    visible: !isFollowing,
                                    child: GestureDetector(
                                      onTap: () => _handleFollow(
                                          disItem?.userHandle ?? ""),
                                      child: Container(
                                        padding: const EdgeInsets.all(12.0),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color(0xffEAE4D9),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
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
                                                  CrossAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    homeCont.otherHandle =
                                                        disItem?.userHandle;
                                                    otherUserHandel =
                                                        disItem?.userHandle ??
                                                            "";
                                                    auth.otherUserHandel =
                                                        disItem?.userHandle ??
                                                            "";
                                                    auth.otherUserserProfile();
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
                                                                      6.0),
                                                          child:
                                                              disItem?.profileImage !=
                                                                      null
                                                                  ? Image
                                                                      .network(
                                                                      String.fromCharCodes(base64Decode(
                                                                          disItem?.profileImage ??
                                                                              "")),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      errorBuilder: (BuildContext context,
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
                                                                      height:
                                                                          50,
                                                                      width: 50,
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
                                                          Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.3,
                                                            // adjust the width as needed
                                                            child:
                                                                LayoutBuilder(
                                                              builder: (context,
                                                                  constraints) {
                                                                return CustomText(
                                                                  text: disItem
                                                                          ?.userName ??
                                                                      "",
                                                                  fontColor:
                                                                      const Color(
                                                                          0xff160323),
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      "Chillax",
                                                                  // maxLines: 1,
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
                                                                0.3,
                                                            // adjust the width as needed
                                                            child:
                                                                LayoutBuilder(
                                                              builder: (context,
                                                                  constraints) {
                                                                return CustomText(
                                                                  text:
                                                                      "@${disItem?.userHandle}",
                                                                  fontColor:
                                                                      const Color(
                                                                          0xff3C0061),
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300,
                                                                  fontFamily:
                                                                      "Poppins",
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () => _handleFollow(
                                                          disItem?.userHandle ??
                                                              ""),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: isFollowing
                                                              ? Colors.white
                                                              : const Color(
                                                                  0xff330320),
                                                          border: Border.all(
                                                              color: const Color(
                                                                  0xff330320)),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8,
                                                                vertical: 8),
                                                        child: CustomText(
                                                          text: isFollowing
                                                              ? "Following"
                                                              : "Follow",
                                                          fontColor: isFollowing
                                                              ? const Color(
                                                                  0xff330320)
                                                              : Colors.white,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: "Chillax",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const Discover();
                              }));
                            },
                            child: CustomText(
                              text: 'Show More',
                              fontColor: const Color(0xff330320),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                        ],
                      ),
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

void _showBottomMenu(BuildContext context) {
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/icons/Hide Note.png"),
                        SizedBox(
                          width: 12.w,
                        ),
                        CustomText(
                          text: 'Hide Note',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/icons/Save Note.png"),
                        SizedBox(
                          width: 12.w,
                        ),
                        CustomText(
                          text: 'Save Note',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/icons/Follow.png"),
                        SizedBox(
                          width: 12.w,
                        ),
                        CustomText(
                          text: 'Follow User',
                          fontColor: const Color(0xff444444),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset("assets/icons/Block.png"),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],
                ),
              ),
            )),
      );
    },
  );
}
