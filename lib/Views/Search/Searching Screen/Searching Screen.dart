import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';

import '../../../Controllers/Search Controller/SearchController.dart';
import '../../../Controllers/auth_controller.dart';
import '../../NaviationBar/NavigationBarScreen.dart';
import '../../SideBar/SideBar.dart';

class SearchingScreen extends StatefulWidget {
  const SearchingScreen({Key? key}) : super(key: key);

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen> {
  TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  double _blackLinePosition = 0.0;
  var searchCont = Get.put(SearchingController());
  var auth = Get.find<AuthController>();

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
                    // Container(
                    //   padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    //   width: double.infinity,
                    //   height: 54.h,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(6.r)),
                    //   child: Center(
                    //       child: TextField(
                    //         onSubmitted: (String text) {
                    //           searchCont
                    //               .searchUser();
                    //         },
                    //         controller: searchController,
                    //         decoration: InputDecoration(
                    //           prefixIcon: InkWell(
                    //             onTap: () {
                    //               searchCont.searchUser();
                    //             },
                    //             child: const Icon(
                    //               Icons.search,
                    //               size: 22,
                    //               color: Color(0xff677294),
                    //             ),
                    //           ),
                    //           suffixIcon: IconButton(
                    //             icon: const Icon(
                    //               Icons.clear,
                    //               color: Color(0xff677294),
                    //               size: 22,
                    //             ),
                    //             onPressed: () {
                    //               searchController.clear();
                    //             },
                    //           ),
                    //           hintText: 'Search doctor'.tr,
                    //           hintStyle: const TextStyle(
                    //             color: Color(0xff677294),
                    //             fontFamily: 'Rubik',
                    //             fontSize: 15,
                    //             fontWeight: FontWeight.w400,
                    //           ),
                    //           border: InputBorder.none,
                    //         ),
                    //       )),
                    // ),
                    Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 16),
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            width: 1, color: const Color(0xffC6BEE3)),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              searchCont.searchUser(searchController.text);
                            },
                            child:
                                SvgPicture.asset("assets/svg/Search Icon.svg"),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: TextField(
                            autofocus: true,
                            onSubmitted: (value) {
                              searchCont.searchUser(value);
                            },
                            controller: searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search for users',
                              hintStyle: TextStyle(
                                color: Color(0xff727272),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                              border: InputBorder.none,
                            ),
                          )),
                          IconButton(
                            icon: const Icon(Icons.clear,
                                color: Color(0xff727272)),
                            onPressed: () {
                              searchController.clear();
                            },
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 20.h),
                        Container(
                          height: 450,
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 8, top: 16, bottom: 16),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                width: 1, color: const Color(0xffC6BEE3)),
                          ),
                          child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification notification) {
                              if (notification is ScrollUpdateNotification) {
                                double scrollPosition =
                                    notification.metrics.pixels;
                                double maxScrollExtent =
                                    notification.metrics.maxScrollExtent;
                                double containerHeight = 450;
                                double redLineHeight = containerHeight;
                                double blackLineHeight = 214.87;

                                double maxBlackLinePosition =
                                    redLineHeight - blackLineHeight;
                                double newBlackLinePosition =
                                    (scrollPosition / maxScrollExtent) *
                                        maxBlackLinePosition;

                                if (newBlackLinePosition.isNaN) {
                                  newBlackLinePosition = 0.0;
                                } else if (newBlackLinePosition.isInfinite) {
                                  newBlackLinePosition = maxBlackLinePosition;
                                } else if (newBlackLinePosition < 0) {
                                  newBlackLinePosition = 0.0;
                                } else if (newBlackLinePosition >
                                    maxBlackLinePosition) {
                                  newBlackLinePosition = maxBlackLinePosition;
                                }

                                setState(() {
                                  _blackLinePosition = newBlackLinePosition;
                                });
                              }
                              return false;
                            },
                            child: Stack(
                              children: [
                                SingleChildScrollView(
                                  controller: _scrollController,
                                  physics: const ScrollPhysics(),
                                  child: userCont.searchModel.isEmpty
                                      ? Center(child: Text("No Data Found".tr))
                                      : ListView.builder(
                                          controller: _scrollController,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              userCont.searchModel.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final searcUser =
                                                userCont.searchModel[index];
                                            print(searcUser.userName);
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 16),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
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
                                                                  .circular(
                                                                      6.0),
                                                          child: searcUser
                                                                      .profileImage !=
                                                                  null
                                                              ? Image.network(
                                                                  String.fromCharCodes(
                                                                      base64Decode(
                                                                          searcUser.profileImage ??
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
                                                      const SizedBox(width: 10),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          CustomText(
                                                            text: searcUser
                                                                .userName,
                                                            fontColor:
                                                                const Color(
                                                                    0xff444444),
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                "Poppins",
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          CustomText(
                                                            text:
                                                                "${searcUser.userHandle}",
                                                            fontColor:
                                                                const Color(
                                                                    0xff444444),
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w300,
                                                            fontFamily:
                                                                "Poppins",
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 8,
                                                  ),
                                                  Container(
                                                    height: 1,
                                                    width: double.infinity,
                                                    color:
                                                        const Color(0xffF6F5FB),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  ),
                                                  CustomText(
                                                    text: searcUser
                                                        .profileTagline,
                                                    fontColor:
                                                        const Color(0xff444444),
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w300,
                                                    fontFamily: "Poppins",
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
                                    decoration: BoxDecoration(
                                      color: const Color(0xffF4F4F4),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: _blackLinePosition.isNaN
                                      ? 0.0
                                      : _blackLinePosition,
                                  child: Container(
                                    width: 4,
                                    height: 214.87,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff868686),
                                      borderRadius: BorderRadius.circular(8),
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
              ),
            ),
          );
        });
  }
}
