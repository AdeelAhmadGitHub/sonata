import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/ProfileController/ProfileController.dart';
import '../../Controllers/auth_controller.dart';
import '../../Controllers/userUsingSonataController/userUsingSonataControlloer.dart';
import '../Follow Button/Follow Icon Button.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../NaviationBar/NavigationBarSearchScreen.dart';
import '../SideBar/SideBar.dart';
import '../Widgets/custom_text.dart';

class Discover extends StatefulWidget {
  const Discover({Key? key}) : super(key: key);

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  var auth = Get.find<AuthController>();
  var discoverCont = Get.put(userUsingSonataController());
  bool isFollowing = false;
  Map<String, bool> followingMap = {};

  Map<String, bool> _followingMap = {};
  var homeCont = Get.put(HomeController());

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
              GestureDetector(
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
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Color(0xfff160323),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  SvgPicture.asset(
                    "assets/svg/ri_compass-discover-line.svg",
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
              SizedBox(height: 16.h),

              Container(
                  height: 1.h,
                  width: double.infinity.w,
                  color: const Color(0xffC6BEE3)),
              SizedBox(height: 16.h),
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return ListView.builder(
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: discoverCont
                          .userUsingSonataModel?.jsonSideArray?.length ??
                      0,
                  itemBuilder: (BuildContext context, int index) {
                    var disItem = discoverCont
                        .userUsingSonataModel?.jsonSideArray?[index];
                    bool isFollowing =
                        _followingMap[disItem?.userHandle ?? ""] ?? false;
                    return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Visibility(
                          visible: !isFollowing,
                          child: GestureDetector(
                            onTap: () =>
                                _handleFollow(disItem?.userHandle ?? ""),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: const Color(0xffC6BEE3), width: 1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          homeCont.otherHandle =
                                              disItem?.userHandle;
                                          auth.otherUserHandel =
                                              disItem?.userHandle ?? "";
                                          otherUserHandel =
                                              disItem?.userHandle ?? "";
                                          auth.otherUserserProfile();
                                        },
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: const BoxDecoration(),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                child: disItem?.profileImage !=
                                                        null
                                                    ? Image.network(
                                                        String.fromCharCodes(
                                                            base64Decode(disItem
                                                                    ?.profileImage ??
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
                                                CustomText(
                                                  text: disItem?.userName ?? "",
                                                  fontColor:
                                                      const Color(0xff444444),
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Chillax",
                                                ),
                                                CustomText(
                                                  text:
                                                      "@${disItem?.userHandle}",
                                                  fontColor:
                                                      const Color(0xff444444),
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.normal,
                                                  fontFamily: "Poppins",
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
                                            GestureDetector(
                                              onTap: () => _handleFollow(
                                                  disItem?.userHandle ?? ""),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: isFollowing
                                                      ? Colors.white
                                                      : const Color(0xff3C0061),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xff3C0061)),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 8),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image.asset(
                                                      "assets/icons/Follow (1).png",
                                                    ),
                                                    const SizedBox(width: 8),
                                                    CustomText(
                                                      text: isFollowing
                                                          ? "Following"
                                                          : "Follow",
                                                      fontColor: isFollowing
                                                          ? const Color(
                                                              0xff3C0061)
                                                          : Colors.white,
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontFamily: "Chillax",
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
                                    text: disItem?.profileTagline ?? '',
                                    fontColor: const Color(0xff444444),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: "Poppins",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                );
              }),
              SizedBox(
                height: 35.h,
              )
            ],
          ),
        ),
      ),
    );
  }
}
