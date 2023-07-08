import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sonata/Models/ProfileModel/UserNotesModel.dart';
import 'package:sonata/Views/View%20Notes/View%20Notes.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/ProfileController/ProfileController.dart';
import '../../Controllers/auth_controller.dart';
import '../../Models/getChannel Model.dart';
import '../Create Note (Replying)/Replying Notes.dart';
import '../Follows/Follows.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../Profile/Profile.dart';
import '../Renote/Renote.dart';
import '../Renote/UserRenote.dart';
import '../SideBar/SideBar.dart';
import '../Widgets/custom_text.dart';
import '../Widgets/customeline/DashedBorderPainter.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var auth = Get.find<AuthController>();
  var profile = Get.put(ProfileController());
  var homeForOtherUser = Get.put(HomeController());
  bool isFollowing = false;
  void _handleFollow(String userHandle) async {
    profile.followHandle = userHandle;
    await profile.createUserFollow();
  }

  final List<String> items = [
    'All',
    'My Life',
    'Pets',
    'Music',
  ];
  final List<String> sorts = [
    'Most Recent',
    'Most Popular',
  ];
  final List<String> more = [
    'Liked',
    'Replied',
  ];
  String? selectedMoreNotes;
  String? selectedSortNotes;
  String? selectedSortReNotes;
  int visibleCount = 3;

  XFile? imageFile;

  List tex = ["Notes", "Renotes", "Channels", "Media"];
  int selectedIndex = 0;
  var getchannel = Get.find<ProfileController>();
  GetChannelMode? selectedValue;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      profile.getChannels();
      profile.userNotes();
      profile.userReNotes();
      profile.userChannels();
      profile.userMedia();
      profile.profileMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    // DateTime date =
    //     DateFormat('MMMM dd, yyyy').parse(auth.profileModel?.dateOfBirth ?? "");
    // String formattedDate = DateFormat('dd MMMM yyyy').format(date);
    return GetBuilder(
        init: ProfileController(),
        builder: (profileCont) {
          if (auth.getChannel.value) {
            return SvgPicture.asset(
              'assets/svg/sonata-loader-spin-1.svg',
            );
          } else {
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
                              child: auth.user?.profileImage != null
                                  ? Image.network(
                                      String.fromCharCodes(base64Decode(
                                          auth.user?.profileImage ?? "")),
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        print(
                                            'Error loading image: $exception');
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
                                Get.back();
                              },
                              child: const Icon(Icons.arrow_back)),
                          SizedBox(
                            width: 8.w,
                          ),
                          SvgPicture.asset(
                            "assets/svg/Profile.svg"
                            "",
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          CustomText(
                            text: auth.profileModel?.userName,
                            fontColor: const Color(0xff160323),
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Chillax",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffC6BEE3),
                      ),
                      SizedBox(height: 16.h),
                      Container(
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
                            SizedBox(
                              height: 280,
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 190,
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff3C0061),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(9.0),
                                      child: auth.profileModel?.profileImage !=
                                              null
                                          ? Image.network(
                                              String.fromCharCodes(base64Decode(
                                                  auth.profileModel
                                                          ?.coverImage ??
                                                      "")),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                print(
                                                    'Error loading image: $exception');
                                                return SvgPicture.asset(
                                                  "assets/svg/CoverImage.svg",
                                                );
                                              },
                                            )
                                          : SvgPicture.asset(
                                              "assets/svg/CoverImage.svg",
                                              width: double.infinity,
                                              height: 190,
                                            ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 16.0,
                                    top: 150,
                                    child: Container(
                                      width: 112,
                                      height: 112,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(9.0),
                                        child: auth.profileModel
                                                    ?.profileImage !=
                                                null
                                            ? Image.network(
                                                String.fromCharCodes(
                                                    base64Decode(auth
                                                            .profileModel
                                                            ?.profileImage ??
                                                        "")),
                                                fit: BoxFit.cover,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                                  print(
                                                      'Error loading image: $exception');
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
                                  Positioned(
                                    bottom: 15,
                                    right: 16,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          height: 44.h,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              setState(() async {
                                                print(auth.profileModel);
                                                print(auth.profileModel
                                                    ?.followStatus);
                                                await profile.createUsersFollow(
                                                    auth.otherUserHandel);
                                                auth.profileModel
                                                            ?.followStatus ==
                                                        0
                                                    ? auth.profileModel
                                                        ?.followStatus = 1
                                                    : auth.profileModel
                                                        ?.followStatus = 0;
                                                profile.update();
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor: auth
                                                          .profileModel
                                                          ?.followStatus ==
                                                      0
                                                  ? const Color(0xff3C0061)
                                                  : const  Color(0xffFFFFFF),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                side: const BorderSide(
                                                    color: Color(0xff3C0061)),
                                              ),
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 10),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/Follow (1).png",
                                                  height: 22.h,
                                                  width: 21.w,
                                                ),
                                                const SizedBox(width: 10.0),
                                                CustomText(
                                                  text: auth.profileModel
                                                              ?.followStatus ==
                                                          1
                                                      ? "Following"
                                                      : "Follow",
                                                  fontColor:
                                                      auth.profileModel
                                                                  ?.followStatus ==
                                                              0
                                                          ?  const Color(0xffFFFFFF)
                                                          : const Color(0xff3C0061),
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Chillax",
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                if (auth.profileModel
                                                    ?.followStatus ==
                                                    1)
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 12),
                                                    child: Container(
                                                      width: 1,
                                                      decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xfffF3EEF9),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                4), // set the border radius of the line
                                                      ),
                                                    ),
                                                  ),
                                                if (auth.profileModel
                                                    ?.followStatus ==
                                                    1)
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                if (auth.profileModel
                                                    ?.followStatus ==
                                                    1)
                                                  InkWell(
                                                    onTap: () {
                                                      _showMenu(context);
                                                    },
                                                    child: const Icon(
                                                      FontAwesomeIcons
                                                          .ellipsisVertical,
                                                      color: Color(0xfff3C0061),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                        ),
                                        auth.profileModel
                                            ?.followStatus ==
                                            1
                                            ? const SizedBox(
                                                width: 0,
                                              )
                                            : const SizedBox(
                                                width: 10,
                                              ),
                                        auth.profileModel
                                            ?.followStatus ==
                                            1
                                            ? Container()
                                            : Container(
                                                height: 44.h,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    border: Border.all(
                                                      width: 1,
                                                      color: const Color(
                                                          0xfff3C0061),
                                                    )),
                                                child: InkWell(
                                                  onTap: () {
                                                    _showMenu(context);
                                                  },
                                                  child: const Icon(
                                                    FontAwesomeIcons
                                                        .ellipsisVertical,
                                                    color: Color(0xfff3C0061),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20.0.h),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: CustomText(
                                text: auth.profileModel?.userName,
                                fontColor: const Color(0xff160323),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: CustomText(
                                text: '@${auth.profileModel?.userHandle}',
                                fontColor: const Color(0xff3C0061),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Chillax",
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                width: double.infinity,
                                child: CustomText(
                                  text: auth.profileModel?.profileTagline,
                                  fontColor: const Color(0xff444444),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset("assets/svg/location.svg"),
                                  SizedBox(width: 10.w),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text:
                                              auth.profileModel?.profileLocation,
                                          fontColor: const Color(0xff444444),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset("assets/svg/work.svg"),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  CustomText(
                                    text: 'Works at',
                                    fontColor: const Color(0xff444444),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text:
                                          auth.profileModel?.profileWork,
                                          fontColor:
                                          const Color(0xff444444),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [Container()],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  SvgPicture.asset("assets/svg/join.svg"),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Row(
                                    children: [
                                      CustomText(
                                        text: 'Joined',
                                        fontColor: const Color(0xff444444),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      CustomText(
                                        text: auth.profileModel?.dateOfBirth ?? "",
                                        fontColor: const Color(0xff444444),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Poppins",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Follows(followIndex: 0)));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xffC6BEE3)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          CustomText(
                                            text: auth
                                                .profileModel?.totalFollowing
                                                .toString(),
                                            fontColor: const Color(0xff444444),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Poppins",
                                          ),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          CustomText(
                                            text: 'Following',
                                            fontColor: const Color(0xff444444),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: "Poppins",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Follows(followIndex: 1)));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: const Color(0xffC6BEE3)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          CustomText(
                                            text: auth
                                                .profileModel?.totalFollower
                                                .toString(),
                                            fontColor: const Color(0xff444444),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Poppins",
                                          ),
                                          SizedBox(
                                            width: 6.w,
                                          ),
                                          CustomText(
                                            text: 'Followers',
                                            fontColor: const Color(0xff444444),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w300,
                                            fontFamily: "Poppins",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
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
                                      child: CustomText(
                                        text: 'My Links',
                                        fontColor: const Color(0xff160323),
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Chillax",
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: auth.profileModel
                                              ?.associatedLinks?.length ??
                                          0,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var link = auth.profileModel
                                            ?.associatedLinks?[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 12,
                                            ),

                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                color: const Color(0xffF6F5FB),
                                                width: 4,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/svg/ion_link.svg"),
                                                SizedBox(width: 12.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      CustomText(
                                                        text: link?.linkLabel,
                                                        fontColor: const Color(
                                                            0xff444444),
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          if (link?.customLink !=
                                                              null) {
                                                            launch(
                                                                link?.customLink ??
                                                                    "");
                                                          }
                                                        },
                                                        child:CustomText(
                                                          text: link != null
                                                              ? Uri.parse(link
                                                              .customLink!)
                                                              .host
                                                              : '',
                                                          fontColor: const Color(
                                                              0xff444444),
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                          FontWeight.w300,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
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
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                height: 44.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color.fromRGBO(60, 0, 97, 0.06),
                                      offset: Offset(0, 2),
                                      blurRadius: 6,
                                    )
                                  ],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Container(
                                  // margin: EdgeInsets.only(right: 30.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = 0;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          // margin: EdgeInsets.only(right: 4.w),
                                          decoration: BoxDecoration(
                                            color: selectedIndex == 0
                                                ? const Color(0xffF6F5FB)
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Center(
                                            child: CustomText(
                                              text: "Notes",
                                              fontColor: selectedIndex == 0
                                                  ? const Color(0xff3C0061)
                                                  : const Color(0xff444444),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Chillax",
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = 1;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          // margin: EdgeInsets.only(right: 4.w),
                                          decoration: BoxDecoration(
                                            color: selectedIndex == 1
                                                ? const Color(0xffF6F5FB)
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Center(
                                            child: CustomText(
                                              text: "Renotes",
                                              fontColor: selectedIndex == 1
                                                  ? const Color(0xff3C0061)
                                                  : const Color(0xff444444),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Chillax",
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = 2;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal   : 8,
                                          ),
                                          // margin: EdgeInsets.only(right: 4.w),
                                          decoration: BoxDecoration(
                                            color: selectedIndex == 2
                                                ? const Color(0xffF6F5FB)
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Center(
                                            child: CustomText(
                                              text: "Channels",
                                              fontColor: selectedIndex == 2
                                                  ? const Color(0xff3C0061)
                                                  : const Color(0xff444444),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Chillax",
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = 3;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          // margin: EdgeInsets.only(right: 4.w),
                                          decoration: BoxDecoration(
                                            color: selectedIndex == 3
                                                ? const Color(0xffF6F5FB)
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Center(
                                            child: CustomText(
                                              text: "Media",
                                              fontColor: selectedIndex == 3
                                                  ? const Color(0xff3C0061)
                                                  : const Color(0xff444444),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Chillax",
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = 4;
                                          });
                                        },
                                        child: Container(
                                          height: 28, width: 34,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          //margin: EdgeInsets.only(right: 4.w),
                                          decoration: BoxDecoration(
                                            color: selectedIndex == 4
                                                ? const Color(0xffF6F5FB)
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Image.asset(
                                            "assets/icons/MoreIcon.png",
                                            color: selectedIndex == 4
                                                ? const Color(0xff3C0061)
                                                : const Color(0xff444444),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              selectedIndex == 0
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/svg/Channel Tag.svg',
                                                color: const Color(0xff444444),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton2<
                                                    GetChannelMode>(
                                                  isExpanded: true,
                                                  hint: CustomText(
                                                    text: 'All Channels',
                                                    fontColor:
                                                        const Color(0xff444444),
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Poppins",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  items: getchannel.channels
                                                      .map((item) =>
                                                          DropdownMenuItem<
                                                              GetChannelMode>(
                                                            value: item,
                                                            child: CustomText(
                                                              text: item
                                                                  .chanelName,
                                                              fontColor:
                                                                  const Color(
                                                                      0xff444444),
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  "Poppins",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ))
                                                      .toList(),
                                                  value: selectedValue,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedValue = value;
                                                      profileCont
                                                              .channelNameNotes =
                                                          value?.chanelName;
                                                      profileCont.userNotes();
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      ButtonStyleData(
                                                    height: 36.h,
                                                    width: 110.w,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 9, right: 9),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        width: 2,
                                                        color: const Color(
                                                            0xfffE7E7E7),
                                                      ),
                                                      color: Colors.transparent,
                                                    ),
                                                    elevation: 0,
                                                  ),
                                                  iconStyleData:
                                                      const IconStyleData(
                                                    icon: ImageIcon(
                                                      AssetImage(
                                                          "assets/icons/tabler_chevron-down.png"),
                                                    ),
                                                    iconSize: 20,
                                                    iconEnabledColor:
                                                        Color(0xfff444444),
                                                    iconDisabledColor:
                                                        Colors.red,
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    maxHeight: 136.h,
                                                    width: 110.w,
                                                    padding: null,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        width: 2,
                                                        color: const Color(
                                                            0xfffE7E7E7),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    elevation: 0,
                                                    offset: const Offset(0, -5),
                                                    scrollbarTheme:
                                                        ScrollbarThemeData(
                                                      radius:
                                                          const Radius.circular(
                                                              8),
                                                      thickness:
                                                          MaterialStateProperty
                                                              .all<double>(4),
                                                      thumbVisibility:
                                                          MaterialStateProperty
                                                              .all<bool>(true),
                                                    ),
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    height: 40,
                                                    //padding: EdgeInsets.only(left: 14, right: 14),
                                                  ),
                                                ),
                                              ),
                                              SvgPicture.asset(
                                                'assets/svg/Sort.svg',
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                  isExpanded: true,
                                                  isDense: true,
                                                  hint: CustomText(
                                                    text: 'Most Recent',
                                                    fontColor:
                                                        const Color(0xff444444),
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Poppins",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  items: sorts
                                                      .map((item) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                            value: item,
                                                            child: CustomText(
                                                              text: item,
                                                              fontColor:
                                                                  const Color(
                                                                      0xff444444),
                                                              fontSize: 16.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily:
                                                                  "Poppins",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ))
                                                      .toList(),
                                                  value: selectedSortNotes,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      selectedSortNotes =
                                                          value as String;
                                                      print(value);
                                                      if (value ==
                                                          "Most Recent") {
                                                        profile.statisticsFilterNotes =
                                                            "most_recent";
                                                        profile.userNotes();
                                                      } else {
                                                        profile.statisticsFilterNotes =
                                                            "most_popular";
                                                        profile.userNotes();
                                                      }
                                                    });
                                                  },
                                                  buttonStyleData:
                                                      ButtonStyleData(
                                                    height: 36.h,
                                                    width: 110.w,
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 9, right: 9),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        width: 2,
                                                        color: const Color(
                                                            0xfffE7E7E7),
                                                      ),
                                                      color: Colors.transparent,
                                                    ),
                                                    elevation: 0,
                                                  ),
                                                  iconStyleData:
                                                      const IconStyleData(
                                                    icon: ImageIcon(
                                                      AssetImage(
                                                          "assets/icons/tabler_chevron-down.png"),
                                                    ),
                                                    iconSize: 20,
                                                    iconEnabledColor:
                                                        Color(0xfff444444),
                                                    iconDisabledColor:
                                                        Colors.red,
                                                  ),
                                                  dropdownStyleData:
                                                      DropdownStyleData(
                                                    maxHeight: 204.h,
                                                    width: 110.w,
                                                    padding: null,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                        width: 2,
                                                        color: const Color(
                                                            0xfffE7E7E7),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                    elevation: 0,
                                                    offset: const Offset(0, -5),
                                                    scrollbarTheme:
                                                        ScrollbarThemeData(
                                                      radius:
                                                          const Radius.circular(
                                                              8),
                                                      thickness:
                                                          MaterialStateProperty
                                                              .all<double>(4),
                                                      thumbVisibility:
                                                          MaterialStateProperty
                                                              .all<bool>(true),
                                                    ),
                                                  ),
                                                  menuItemStyleData:
                                                      const MenuItemStyleData(
                                                    height: 40,
                                                    //padding: EdgeInsets.only(left: 14, right: 14),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 16.h,
                                        ),
                                        profileCont.userNotesModel.isEmpty
                                            ? Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 16.0),
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 16,
                                                      ),
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 1,
                                                            color: const Color(
                                                                0xffF6F5FB),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12)),
                                                      child: Column(
                                                        children: [
                                                          Image.asset(
                                                              "assets/icons/Renote.png"),
                                                          CustomText(
                                                            text:
                                                                'No Notes Posted',
                                                            fontColor:
                                                                const Color(
                                                                    0xff666666),
                                                            fontSize: 18.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                "Poppins",
                                                          ),
                                                          CustomText(
                                                            text:
                                                                'Any notes you post will show up here',
                                                            fontColor:
                                                                const Color(
                                                                    0xff767676),
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontFamily:
                                                                "Poppins",
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 16.h),
                                                ],
                                              )
                                            : ListView.builder(
                                                physics: const ScrollPhysics(),
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: profileCont
                                                    .userNotesModel.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  var otherUserItem =
                                                      profileCont
                                                              .userNotesModel[
                                                          index];
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: 16.0.h),
                                                    child: Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                            child: Container(
                                                              height: 1,
                                                              width: double
                                                                  .infinity,
                                                              color: const Color(
                                                                  0xffE7E7E7),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 16.h,
                                                          ),
                                                          Container(
                                                            width:
                                                                double.infinity,
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        12,
                                                                    horizontal:
                                                                        16),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Container(
                                                                      width:
                                                                          44.h,
                                                                      height:
                                                                          44.w,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                      child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(6.0),
                                                                          child: otherUserItem.profileImage != null
                                                                              ? Image.network(
                                                                                  String.fromCharCodes(
                                                                                    base64Decode(otherUserItem.profileImage ?? ""),
                                                                                  ),
                                                                                  fit: BoxFit.cover,
                                                                                )
                                                                              : SvgPicture.asset(
                                                                                  "assets/svg/UserProfile.svg",
                                                                                  height: 50,
                                                                                  width: 50,
                                                                                )),
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
                                                                          text:
                                                                              otherUserItem.userName,
                                                                          fontColor:
                                                                              const Color(0xff160323),
                                                                          fontSize:
                                                                              16.sp,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                          fontFamily:
                                                                              "Chillax",
                                                                        ),
                                                                        CustomText(
                                                                          text:
                                                                              "@${otherUserItem.userHandle}",
                                                                          fontColor:
                                                                              const Color(0xff3C0061),
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                          fontFamily:
                                                                              "Poppins",
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          12.0),
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      CustomText(
                                                                        text: otherUserItem
                                                                            .noteTimeAgo,
                                                                        fontColor:
                                                                            const Color(0xff767676),
                                                                        fontSize:
                                                                            14.sp,
                                                                        fontWeight:
                                                                            FontWeight.w300,
                                                                        fontFamily:
                                                                            "Poppins",
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            16.w,
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          profile.noteId =
                                                                              otherUserItem.noteId;
                                                                          profile.otherHandle =
                                                                              otherUserItem.userHandle;
                                                                          _OtherUserBottomSheet(
                                                                            context,
                                                                            otherUserItem.noteSavedStatus ??
                                                                                0,
                                                                            otherUserItem.threadStart ??
                                                                                false,
                                                                            otherUserItem.userFollowStatus ??
                                                                                0,
                                                                            index,
                                                                          );
                                                                        },
                                                                        child:
                                                                             Row(
                                                                          children: [
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
                                                          SizedBox(
                                                            height: 16.h,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              left: 16.0.w,
                                                              right: 16.0.w,
                                                              bottom: 8.0.h,
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Container(
                                                                  padding:
                                                                       EdgeInsets
                                                                          .all(
                                                                              5.0),
                                                                  constraints:
                                                                      BoxConstraints(
                                                                    maxHeight:
                                                                        32.h,
                                                                    maxWidth:
                                                                        250.w,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border: Border.all(
                                                                        width:
                                                                            2,
                                                                        color: const Color(
                                                                            0xffC6BEE3)),
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      SvgPicture
                                                                          .asset(
                                                                        'assets/svg/Channel Tag.svg',
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              4),
                                                                      Flexible(
                                                                        child:
                                                                            CustomText(
                                                                          text: otherUserItem.channelsName ??
                                                                              "",
                                                                          fontColor:
                                                                              const Color(0xff444444),
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                          fontFamily:
                                                                              "Chillax",
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          maxLines:
                                                                              1,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Visibility(
                                                                    visible:
                                                                        otherUserItem.noteSavedStatus !=
                                                                            0,
                                                                    child: SvgPicture
                                                                        .asset(
                                                                            "assets/svg/Save Notees.svg")),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 16.h,
                                                          ),
                                                          GestureDetector(
                                                            onTap: () {
                                                              homeForOtherUser
                                                                      .noteId =
                                                                  otherUserItem
                                                                      .noteId;
                                                              homeForOtherUser
                                                                  .viewNotes();
                                                            },
                                                            child: Visibility(
                                                              visible: otherUserItem
                                                                          .noteBody !=
                                                                      null &&
                                                                  otherUserItem
                                                                      .noteBody!
                                                                      .isNotEmpty,
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16),
                                                                child: otherUserItem.noteBody !=
                                                                            null &&
                                                                        otherUserItem
                                                                            .noteBody!
                                                                            .startsWith('http')
                                                                    ? InkWell(
                                                                        onTap:
                                                                            () {
                                                                          if (otherUserItem.noteBody !=
                                                                              null) {
                                                                            launch(otherUserItem.noteBody ??
                                                                                '');
                                                                          }
                                                                        },
                                                                        child:
                                                                            CustomText(
                                                                          text: otherUserItem != null
                                                                              ? Uri.parse(otherUserItem.noteBody!).host
                                                                              : '',
                                                                          fontColor:
                                                                              const Color(0xff444444),
                                                                          fontSize:
                                                                              16.sp,
                                                                          height:
                                                                              1.5,
                                                                          fontFamily:
                                                                              'Poppins',
                                                                        ),
                                                                      )
                                                                    : CustomText(
                                                                        text: otherUserItem.noteBody ??
                                                                            "",
                                                                        fontColor:
                                                                            const Color(0xff444444),
                                                                        fontSize:
                                                                            16.sp,
                                                                        height:
                                                                            1.5,
                                                                        fontFamily:
                                                                            "Poppins",
                                                                      ),
                                                              ),
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible: otherUserItem
                                                                    .noteImage !=
                                                                null,
                                                            child: SizedBox(
                                                              height: 8.h,
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible: otherUserItem
                                                                    .noteImage !=
                                                                null,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () {
                                                                homeForOtherUser
                                                                        .noteId =
                                                                    otherUserItem
                                                                        .noteId;
                                                                homeForOtherUser
                                                                    .viewNotes();
                                                              },
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: null,
                                                                margin: const EdgeInsets
                                                                        .only(
                                                                    left: 16.0,
                                                                    right:
                                                                        16.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6.0),
                                                                ),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6.0),
                                                                  child: otherUserItem
                                                                              .noteImage !=
                                                                          null
                                                                      ? Image
                                                                          .network(
                                                                          String.fromCharCodes(base64Decode(otherUserItem.noteImage ??
                                                                              "")),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          errorBuilder: (BuildContext context,
                                                                              Object exception,
                                                                              StackTrace? stackTrace) {
                                                                            print('Error loading image: $exception');
                                                                            return Container(
                                                                              height: 178,
                                                                              decoration: const BoxDecoration(
                                                                                color: Color(0xffF7F7F7),
                                                                              ),
                                                                              child: SvgPicture.asset("assets/svg/Image.svg"),
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
                                                            visible: otherUserItem
                                                                    .threadStart ??
                                                                false,
                                                            child: Column(
                                                              children: [
                                                                Center(
                                                                  child:
                                                                      SizedBox(
                                                                    height:
                                                                        30.0,
                                                                    width: 2.0,
                                                                    child:
                                                                        CustomPaint(
                                                                      painter:
                                                                          DashedBorderPainter(
                                                                        color: const Color(
                                                                            0xff3C0061),
                                                                        strokeWidth:
                                                                            2.0,
                                                                        dashWidth:
                                                                            4.0,
                                                                        dashSpace:
                                                                            3.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Center(
                                                                  child:
                                                                      SizedBox(
                                                                    height: 28,
                                                                    width: 170,
                                                                    child:
                                                                        DottedBorder(
                                                                      radius:
                                                                          const Radius.circular(
                                                                              20),
                                                                      color: const Color(
                                                                          0xff3C0061),
                                                                      dashPattern: [
                                                                        6,
                                                                        3
                                                                      ],
                                                                      strokeWidth:
                                                                          1,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(30)),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            homeForOtherUser.threadNoteId =
                                                                                otherUserItem.noteId;
                                                                            homeForOtherUser.viewThread();
                                                                          },
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Container(
                                                                              height: 28,
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  CustomText(
                                                                                    text: "View Thread",
                                                                                    fontColor: const Color(0xff3C0061),
                                                                                    fontSize: 14.sp,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    fontFamily: "Chillax",
                                                                                  ),
                                                                                  CustomText(
                                                                                    text: " (+${otherUserItem.threadLength.toString()})",
                                                                                    fontColor: const Color(0xff868686),
                                                                                    fontSize: 12.sp,
                                                                                    fontWeight: FontWeight.w300,
                                                                                    fontFamily: "Poppins",
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
                                                            height: 16.h,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                              width: double
                                                                  .infinity,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .transparent,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                border:
                                                                    Border.all(
                                                                  color: const Color(
                                                                      0xFFF6F5FB),
                                                                  width: 1,
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Container(
                                                                    height: 30,
                                                                    child:
                                                                        ElevatedButton
                                                                            .icon(
                                                                      onPressed:
                                                                          () {
                                                                        profileCont
                                                                            .noteId = otherUserItem
                                                                                .noteId ??
                                                                            "";
                                                                        profileCont
                                                                            .createNoteLike();
                                                                      },
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .favorite_border,
                                                                        color: Color(
                                                                            0xffCE1616),
                                                                      ),
                                                                      label:
                                                                          Text(
                                                                        otherUserItem
                                                                            .totalNoteLikes
                                                                            .toString(),
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0xff444444),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontFamily:
                                                                              "Poppins",
                                                                        ),
                                                                      ),
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        elevation:
                                                                            0,
                                                                        primary: otherUserItem.likeStatus ==
                                                                                1
                                                                            ? const Color(0xffFFF0F0)
                                                                            : Colors.transparent,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  Container(
                                                                    height: 30,
                                                                    child:
                                                                        ElevatedButton
                                                                            .icon(
                                                                      onPressed:
                                                                          () {
                                                                        profileCont.replyId =
                                                                            otherUserItem.noteId;
                                                                        profileCont.channelId =
                                                                            otherUserItem.channelsId;
                                                                        profileCont
                                                                            .userHandel = otherUserItem
                                                                                .userHandle ??
                                                                            "";
                                                                        Get.to(
                                                                            const ReplyingNotes());
                                                                        profile
                                                                            .userNotes();
                                                                      },
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .comment_outlined,
                                                                        color: Color(
                                                                            0xff0FA958),
                                                                      ),
                                                                      label:
                                                                          Text(
                                                                        otherUserItem
                                                                            .totalNoteReply
                                                                            .toString(),
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0xff444444),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontFamily:
                                                                              "Poppins",
                                                                        ),
                                                                      ),
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        shadowColor:
                                                                            Colors.transparent,
                                                                        elevation:
                                                                            0,
                                                                        backgroundColor: otherUserItem.noteRepliedStatus ==
                                                                                1
                                                                            ? const Color(0xffE2F5EB)
                                                                            : Colors.transparent,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  // GestureDetector(
                                                                  //   onTap: () {
                                                                  //     homeCont.replyId =
                                                                  //         homeItem.noteId ?? "";
                                                                  //     homeCont.channelId =
                                                                  //         homeItem.channelsId ?? "";
                                                                  //     Get.to(const ReplyingNotes());
                                                                  //   },
                                                                  //   child: Row(
                                                                  //     mainAxisSize: MainAxisSize.min,
                                                                  //     children: [
                                                                  //       const Icon(
                                                                  //         Icons.comment_outlined,
                                                                  //         color: Color(0xff0FA958),
                                                                  //       ),
                                                                  //       const SizedBox(width: 8.0),
                                                                  //       CustomText(
                                                                  //         text: homeItem.totalNoteReply,
                                                                  //         fontColor: Color(0xff444444),
                                                                  //         fontSize: 12.sp,
                                                                  //         fontWeight: FontWeight.w400,
                                                                  //         fontFamily: "Poppins",
                                                                  //       ),
                                                                  //     ],
                                                                  //   ),
                                                                  // ),

                                                                  Container(
                                                                    height: 30,
                                                                    child:
                                                                        ElevatedButton
                                                                            .icon(
                                                                      onPressed:
                                                                          () {
                                                                        profile.renoteId =
                                                                            otherUserItem.noteId;
                                                                        ProCIhannel =
                                                                            otherUserItem.channelsId;
                                                                        userHandel =
                                                                            otherUserItem.userHandle ??
                                                                                "";
                                                                        selectedUserPost =
                                                                            otherUserItem;
                                                                        Get.to(
                                                                            const UserRenote());
                                                                      },
                                                                      icon: SvgPicture
                                                                          .asset(
                                                                        "assets/svg/mdi_renote.svg",
                                                                      ),
                                                                      label:
                                                                          Text(
                                                                        otherUserItem
                                                                            .totalNoteRepost
                                                                            .toString(),
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Color(0xff444444),
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontFamily:
                                                                              "Poppins",
                                                                        ),
                                                                      ),
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        shadowColor:
                                                                            Colors.transparent,
                                                                        elevation:
                                                                            0,
                                                                        backgroundColor: otherUserItem.noteRenotedStatus ==
                                                                                1
                                                                            ? const Color(0xffF6EFFF)
                                                                            : Colors.transparent,
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(4),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  // const RetweetButton(),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      homeForOtherUser
                                                                              .noteId =
                                                                          otherUserItem
                                                                              .noteId;
                                                                      _showLink(
                                                                        context,
                                                                        otherUserItem.noteId ??
                                                                            0,
                                                                      );
                                                                    },
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .share,
                                                                      color: Color(
                                                                          0xff699BF7),
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
                                      ],
                                    )
                                  : selectedIndex == 1
                                      ? Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/Sort.png',
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  DropdownButtonHideUnderline(
                                                    child: DropdownButton2(
                                                      // isExpanded: true,
                                                      hint: CustomText(
                                                        text: 'Most Recent',
                                                        fontColor: const Color(
                                                            0xff444444),
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: "Poppins",
                                                      ),
                                                      items: sorts
                                                          .map((item) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value: item,
                                                                child:
                                                                    CustomText(
                                                                  text: item,
                                                                  fontColor:
                                                                      const Color(
                                                                          0xff444444),
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      "Poppins",
                                                                ),
                                                              ))
                                                          .toList(),
                                                      value:
                                                          selectedSortReNotes,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedSortReNotes =
                                                              value as String;
                                                          if (value ==
                                                              "Most Recent") {
                                                            profile.statisticsFilterReNotes =
                                                                "most_recent";
                                                            profile
                                                                .userReNotes();
                                                          } else {
                                                            profile.statisticsFilterReNotes =
                                                                "most_popular";
                                                            profile
                                                                .userReNotes();
                                                          }
                                                        });
                                                      },
                                                      buttonStyleData:
                                                          ButtonStyleData(
                                                        height: 36.h,
                                                        // width: 150.w,
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 9,
                                                                right: 9),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                            width: 2,
                                                            color: const Color(
                                                                0xfffE7E7E7),
                                                          ),
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                        elevation: 0,
                                                      ),
                                                      iconStyleData:
                                                          const IconStyleData(
                                                        icon: ImageIcon(
                                                          AssetImage(
                                                              "assets/icons/tabler_chevron-down.png"),
                                                        ),
                                                        iconSize: 20,
                                                        iconEnabledColor:
                                                            Color(0xfff444444),
                                                        iconDisabledColor:
                                                            Colors.red,
                                                      ),
                                                      dropdownStyleData:
                                                          DropdownStyleData(
                                                        maxHeight: 204.h,
                                                        width: 145.w,
                                                        padding: null,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          border: Border.all(
                                                            width: 2,
                                                            color: const Color(
                                                                0xfffE7E7E7),
                                                          ),
                                                          color: Colors.white,
                                                        ),
                                                        elevation: 0,
                                                        offset:
                                                            const Offset(0, -5),
                                                        scrollbarTheme:
                                                            ScrollbarThemeData(
                                                          radius: const Radius
                                                              .circular(8),
                                                          thickness:
                                                              MaterialStateProperty
                                                                  .all<double>(
                                                                      4),
                                                          thumbVisibility:
                                                              MaterialStateProperty
                                                                  .all<bool>(
                                                                      true),
                                                        ),
                                                      ),
                                                      menuItemStyleData:
                                                          const MenuItemStyleData(
                                                        height: 40,
                                                        //padding: EdgeInsets.only(left: 14, right: 14),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 16.h,
                                            ),
                                            profileCont.userRenotesModel.isEmpty
                                                ? Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    16.0),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical: 16,
                                                          ),
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    width: 1,
                                                                    color: const Color(
                                                                        0xffF6F5FB),
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12)),
                                                          child: Column(
                                                            children: [
                                                              Image.asset(
                                                                  "assets/icons/Renote.png"),
                                                              CustomText(
                                                                text:
                                                                    'No Renotes Posted',
                                                                fontColor:
                                                                    const Color(
                                                                        0xff666666),
                                                                fontSize: 18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Poppins",
                                                              ),
                                                              CustomText(
                                                                text:
                                                                    'Any renotes you post will show up here',
                                                                fontColor:
                                                                    const Color(
                                                                        0xff767676),
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "Poppins",
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: 16.h),
                                                    ],
                                                  )
                                                : ListView.builder(
                                                    physics:
                                                        const ScrollPhysics(),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: profileCont
                                                        .userRenotesModel
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      var homeItem = profileCont
                                                              .userRenotesModel[
                                                          index];
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 16.0.h),
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                                child:
                                                                    Container(
                                                                  height: 1,
                                                                  width: double
                                                                      .infinity,
                                                                  color: const Color(
                                                                      0xffE7E7E7),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 16.h,
                                                              ),
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        12,
                                                                    horizontal:
                                                                        16),
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              44.h,
                                                                          height:
                                                                              44.w,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(6.0),
                                                                            child: homeItem.profileImage != null
                                                                                ? Image.network(
                                                                                    String.fromCharCodes(
                                                                                      base64Decode(homeItem.profileImage ?? ""),
                                                                                    ),
                                                                                    fit: BoxFit.cover,
                                                                                  )
                                                                                : SvgPicture.asset(
                                                                                    "assets/svg/UserProfile.svg",
                                                                                    height: 50,
                                                                                    width: 50,
                                                                                  ),
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            CustomText(
                                                                              text: homeItem.userName,
                                                                              fontColor: const Color(0xff160323),
                                                                              fontSize: 16.sp,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontFamily: "Chillax",
                                                                            ),
                                                                            CustomText(
                                                                              text: "@${homeItem.userHandle}",
                                                                              fontColor: const Color(0xff3C0061),
                                                                              fontSize: 14.sp,
                                                                              fontWeight: FontWeight.w300,
                                                                              fontFamily: "Poppins",
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              12.0),
                                                                      child:
                                                                          Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          CustomText(
                                                                            text:
                                                                                homeItem.noteTimeAgo,
                                                                            fontColor:
                                                                                const Color(0xff767676),
                                                                            fontSize:
                                                                                14.sp,
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                            fontFamily:
                                                                                "Poppins",
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                16.w,
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              _OtherUserBottomSheet(
                                                                                context,
                                                                                homeItem.noteSavedStatus ?? 0,
                                                                                homeItem.threadStart ?? false,
                                                                                homeItem.userFollowStatus ?? 0,
                                                                                index,
                                                                              );
                                                                            },
                                                                            child:
                                                                                 Row(
                                                                              children: [
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
                                                                visible: homeItem
                                                                        .noteBody !=
                                                                    null,
                                                                child: SizedBox(
                                                                  height: 16.h,
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible: homeItem
                                                                            .noteBody !=
                                                                        null ||
                                                                    homeItem.renotedBody !=
                                                                        null,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    homeForOtherUser
                                                                            .noteId =
                                                                        homeItem
                                                                            .noteId;
                                                                    homeForOtherUser
                                                                        .viewNotes();
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .infinity,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16),
                                                                    child:
                                                                        CustomText(
                                                                      text: homeItem
                                                                              .noteBody ??
                                                                          "", // Check for null value of homeItem.noteBody
                                                                      fontColor:
                                                                          const Color(
                                                                              0xff444444),
                                                                      fontSize:
                                                                          16.sp,
                                                                      height:
                                                                          1.5,
                                                                      fontFamily:
                                                                          "Poppins",
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible: homeItem
                                                                        .noteImage !=
                                                                    null,
                                                                child: SizedBox(
                                                                  height: 8.h,
                                                                ),
                                                              ),
                                                              Visibility(
                                                                visible: homeItem
                                                                        .noteImage !=
                                                                    null,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    homeForOtherUser
                                                                            .noteId =
                                                                        homeItem
                                                                            .noteId;
                                                                    homeForOtherUser
                                                                        .viewNotes();
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height:
                                                                        null,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16.0,
                                                                        right:
                                                                            16.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6.0),
                                                                    ),
                                                                    child:
                                                                        ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child: homeItem.noteImage !=
                                                                              null
                                                                          ? Image
                                                                              .network(
                                                                              String.fromCharCodes(base64Decode(homeItem.noteImage ?? "")),
                                                                              fit: BoxFit.cover,
                                                                              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                print('Error loading image: $exception');
                                                                                return Padding(
                                                                                  padding: const EdgeInsets.all(0.0),
                                                                                  child: SvgPicture.asset("assets/svg/Image.svg"),
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
                                                              SizedBox(
                                                                height: 16.h,
                                                              ),
                                                              Visibility(
                                                                visible: homeItem
                                                                        .renotedId !=
                                                                    null,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16.0),
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            16,
                                                                        right:
                                                                            16,
                                                                        top: 10,
                                                                        bottom:
                                                                            16),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      border:
                                                                          Border(
                                                                        left: BorderSide(
                                                                            width:
                                                                                6,
                                                                            color:
                                                                                Color(0xff3C0061)),
                                                                        bottom: BorderSide(
                                                                            width:
                                                                                6,
                                                                            color:
                                                                                Color(0xff3C0061)),
                                                                      ),
                                                                      // borderRadius: BorderRadius.only(
                                                                      //   bottomRight: Radius.circular(12),
                                                                      // ),
                                                                    ),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: 50,
                                                                                  height: 50,
                                                                                  decoration: const BoxDecoration(),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(6.0),
                                                                                    child: homeItem.renotedProfileImage != null
                                                                                        ? Image.network(
                                                                                            String.fromCharCodes(
                                                                                              base64Decode(homeItem.renotedProfileImage ?? ""),
                                                                                            ),
                                                                                            fit: BoxFit.cover,
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
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    CustomText(
                                                                                      text: homeItem.renotedUserName,
                                                                                      fontColor: const Color(0xff160323),
                                                                                      fontSize: 14.sp,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontFamily: "Chillax",
                                                                                    ),
                                                                                    Text(
                                                                                      "@${homeItem.renotedUserHandle}",
                                                                                      style: const TextStyle(
                                                                                        color: Color(0xff3C0061),
                                                                                        fontSize: 12,
                                                                                        fontWeight: FontWeight.w400,
                                                                                        fontFamily: 'Chillax',
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            // Add more widgets here
                                                                          ],
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                20),
                                                                        Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 4,
                                                                              vertical: 4),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 2, color: const Color(0xffC6BEE3)),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Image.asset('assets/images/Channel Tag.jpg'),
                                                                              const SizedBox(width: 4),
                                                                              CustomText(
                                                                                text: homeItem.renotedChannelName,
                                                                                fontColor: const Color(0xff444444),
                                                                                fontSize: 14.sp,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: "Chillax",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              8.h,
                                                                        ),
                                                                        CustomText(
                                                                          text:
                                                                              homeItem.renotedBody,
                                                                          fontColor:
                                                                              const Color(0xff444444),
                                                                          fontSize:
                                                                              16.sp,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontFamily:
                                                                              "Poppins",
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              16.h,
                                                                        ),
                                                                        Visibility(
                                                                          visible:
                                                                              homeItem.renotedImage != null,
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                double.infinity,
                                                                            // height: 400,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(4.0),
                                                                            ),
                                                                            child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(6.0),
                                                                                child: homeItem.renotedImage != null
                                                                                    ? Image.network(
                                                                                        String.fromCharCodes(base64Decode(homeItem.renotedImage ?? "")),
                                                                                        fit: BoxFit.cover,
                                                                                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                          print('Error loading image: $exception');
                                                                                          return Padding(
                                                                                            padding: const EdgeInsets.all(0.0),
                                                                                            child: SvgPicture.asset("assets/svg/Image.svg"),
                                                                                          );
                                                                                        },
                                                                                      )
                                                                                    : null),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8.h,
                                                              ),
                                                              Visibility(
                                                                visible: homeItem
                                                                        .threadStart ??
                                                                    false,
                                                                child: Column(
                                                                  children: [
                                                                    Center(
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            30.0,
                                                                        width:
                                                                            2.0,
                                                                        child:
                                                                            CustomPaint(
                                                                          painter:
                                                                              DashedBorderPainter(
                                                                            color:
                                                                                const Color(0xff3C0061),
                                                                            strokeWidth:
                                                                                2.0,
                                                                            dashWidth:
                                                                                4.0,
                                                                            dashSpace:
                                                                                3.0,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            28,
                                                                        width:
                                                                            170,
                                                                        child:
                                                                            DottedBorder(
                                                                          radius:
                                                                              const Radius.circular(20),
                                                                          color:
                                                                              const Color(0xff3C0061),
                                                                          dashPattern: const [
                                                                            6,
                                                                            3
                                                                          ],
                                                                          strokeWidth:
                                                                              1,
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                const BorderRadius.all(Radius.circular(30)),
                                                                            child:
                                                                                InkWell(
                                                                              onTap: () {
                                                                                homeForOtherUser.threadNoteId = homeItem.noteId;
                                                                                homeForOtherUser.viewThread();
                                                                              },
                                                                              child: Center(
                                                                                child: Container(
                                                                                  height: 28,
                                                                                  child: Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      CustomText(
                                                                                        text: "View Thread",
                                                                                        fontColor: const Color(0xff3C0061),
                                                                                        fontSize: 14.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontFamily: "Chillax",
                                                                                      ),
                                                                                      CustomText(
                                                                                        text: " (+${homeItem.threadLength.toString()})",
                                                                                        fontColor: const Color(0xff868686),
                                                                                        fontSize: 12.sp,
                                                                                        fontWeight: FontWeight.w300,
                                                                                        fontFamily: "Poppins",
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
                                                                height: 16.h,
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                                child:
                                                                    Container(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .transparent,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: const Color(
                                                                          0xFFF6F5FB),
                                                                      width: 1,
                                                                    ),
                                                                  ),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        child: ElevatedButton
                                                                            .icon(
                                                                          onPressed:
                                                                              () {
                                                                            profileCont.noteId =
                                                                                homeItem.noteId ?? "";
                                                                            profileCont.createNoteLike();
                                                                          },
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.favorite_border,
                                                                            color:
                                                                                Color(0xffCE1616),
                                                                          ),
                                                                          label:
                                                                              Text(
                                                                            homeItem.totalNoteLikes.toString(),
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Color(0xff444444),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: "Poppins",
                                                                            ),
                                                                          ),
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            elevation:
                                                                                0,
                                                                            primary: homeItem.likeStatus == 1
                                                                                ? const Color(0xffFFF0F0)
                                                                                : Colors.transparent,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(4),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        child: ElevatedButton
                                                                            .icon(
                                                                          onPressed:
                                                                              () {
                                                                            profileCont.replyId =
                                                                                homeItem.noteId;
                                                                            profileCont.channelId =
                                                                                homeItem.channelsId;
                                                                            profileCont.userHandel =
                                                                                homeItem.userHandle ?? "";
                                                                            Get.to(const ReplyingNotes());
                                                                            profile.userNotes();
                                                                          },
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.comment_outlined,
                                                                            color:
                                                                                Color(0xff0FA958),
                                                                          ),
                                                                          label:
                                                                              Text(
                                                                            homeItem.totalNoteReply.toString(),
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Color(0xff444444),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: "Poppins",
                                                                            ),
                                                                          ),
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            shadowColor:
                                                                                Colors.transparent,
                                                                            elevation:
                                                                                0,
                                                                            backgroundColor: homeItem.noteRepliedStatus == 1
                                                                                ? const Color(0xffE2F5EB)
                                                                                : Colors.transparent,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(4),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      // GestureDetector(
                                                                      //   onTap: () {
                                                                      //     homeCont.replyId =
                                                                      //         homeItem.noteId ?? "";
                                                                      //     homeCont.channelId =
                                                                      //         homeItem.channelsId ?? "";
                                                                      //     Get.to(const ReplyingNotes());
                                                                      //   },
                                                                      //   child: Row(
                                                                      //     mainAxisSize: MainAxisSize.min,
                                                                      //     children: [
                                                                      //       const Icon(
                                                                      //         Icons.comment_outlined,
                                                                      //         color: Color(0xff0FA958),
                                                                      //       ),
                                                                      //       const SizedBox(width: 8.0),
                                                                      //       CustomText(
                                                                      //         text: homeItem.totalNoteReply,
                                                                      //         fontColor: Color(0xff444444),
                                                                      //         fontSize: 12.sp,
                                                                      //         fontWeight: FontWeight.w400,
                                                                      //         fontFamily: "Poppins",
                                                                      //       ),
                                                                      //     ],
                                                                      //   ),
                                                                      // ),

                                                                      Container(
                                                                        height:
                                                                            30,
                                                                        child: ElevatedButton
                                                                            .icon(
                                                                          onPressed:
                                                                              () {
                                                                            homeForOtherUser.renoteId =
                                                                                homeItem.noteId;
                                                                            channelId =
                                                                                homeItem.channelsId;
                                                                            userHandel =
                                                                                homeItem.userHandle ?? "";
                                                                            // selectedUserPost =
                                                                            //     homeItem ;
                                                                            Get.to(const UserRenote());
                                                                          },
                                                                          icon:
                                                                              SvgPicture.asset(
                                                                            "assets/svg/mdi_renote.svg",
                                                                          ),
                                                                          label:
                                                                              Text(
                                                                            homeItem.totalNoteRepost.toString(),
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Color(0xff444444),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: "Poppins",
                                                                            ),
                                                                          ),
                                                                          style:
                                                                              ElevatedButton.styleFrom(
                                                                            shadowColor:
                                                                                Colors.transparent,
                                                                            elevation:
                                                                                0,
                                                                            backgroundColor: homeItem.noteRenotedStatus == 1
                                                                                ? const Color(0xffF6EFFF)
                                                                                : Colors.transparent,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(4),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      // const RetweetButton(),
                                                                      const Icon(
                                                                        Icons
                                                                            .share,
                                                                        color: Color(
                                                                            0xff699BF7),
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
                                          ],
                                        )
                                      // Column(
                                      //             children: [
                                      //               Padding(
                                      //                 padding: const EdgeInsets.symmetric(
                                      //                     horizontal: 16.0),
                                      //                 child: Container(
                                      //                   padding: const EdgeInsets.symmetric(
                                      //                     vertical: 16,
                                      //                   ),
                                      //                   width: double.infinity,
                                      //                   decoration: BoxDecoration(
                                      //                       border: Border.all(
                                      //                         width: 1,
                                      //                         color: const Color(0xffF6F5FB),
                                      //                       ),
                                      //                       borderRadius:
                                      //                           BorderRadius.circular(12)),
                                      //                   child: Column(
                                      //                     children: [
                                      //                       Image.asset(
                                      //                           "assets/icons/Renote.png"),
                                      //                       CustomText(
                                      //                         text: 'No Renotes Posted',
                                      //                         fontColor:
                                      //                             const Color(0xff666666),
                                      //                         fontSize: 18.sp,
                                      //                         fontWeight: FontWeight.w500,
                                      //                         fontFamily: "Poppins",
                                      //                       ),
                                      //                       CustomText(
                                      //                         text:
                                      //                             'Any renotes you post will show up here',
                                      //                         fontColor:
                                      //                             const Color(0xff767676),
                                      //                         fontSize: 14.sp,
                                      //                         fontWeight: FontWeight.w400,
                                      //                         fontFamily: "Poppins",
                                      //                       ),
                                      //                     ],
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //               SizedBox(height: 16.h),
                                      //             ],
                                      //           )
                                      // Column(
                                      //             children: [
                                      //               Padding(
                                      //                 padding: const EdgeInsets.symmetric(
                                      //                     horizontal: 16.0),
                                      //                 child: Row(
                                      //                   mainAxisAlignment:
                                      //                       MainAxisAlignment.start,
                                      //                   children: [
                                      //                     Image.asset(
                                      //                       'assets/icons/Sort.png',
                                      //                     ),
                                      //                     SizedBox(
                                      //                       width: 10.w,
                                      //                     ),
                                      //                     DropdownButtonHideUnderline(
                                      //                       child: DropdownButton2(
                                      //                         // isExpanded: true,
                                      //                         hint: CustomText(
                                      //                           text: 'Choose',
                                      //                           fontColor: Color(0xff868686),
                                      //                           fontSize: 16.sp,
                                      //                           fontWeight: FontWeight.w400,
                                      //                           fontFamily: "Poppins",
                                      //                         ),
                                      //                         items: sorts
                                      //                             .map((item) =>
                                      //                                 DropdownMenuItem<String>(
                                      //                                   value: item,
                                      //                                   child: CustomText(
                                      //                                     text: item,
                                      //                                     fontColor:
                                      //                                         const Color(
                                      //                                             0xff444444),
                                      //                                     fontSize: 16.sp,
                                      //                                     fontWeight:
                                      //                                         FontWeight.w400,
                                      //                                     fontFamily: "Poppins",
                                      //                                   ),
                                      //                                 ))
                                      //                             .toList(),
                                      //                         value: selectedSort,
                                      //                         onChanged: (value) {
                                      //                           setState(() {
                                      //                             selectedSort =
                                      //                                 value as String;
                                      //                           });
                                      //                         },
                                      //                         buttonStyleData: ButtonStyleData(
                                      //                           height: 36.h,
                                      //                           // width: 150.w,
                                      //                           padding: const EdgeInsets.only(
                                      //                               left: 9, right: 9),
                                      //                           decoration: BoxDecoration(
                                      //                             borderRadius:
                                      //                                 BorderRadius.circular(14),
                                      //                             border: Border.all(
                                      //                               width: 2,
                                      //                               color: const Color(
                                      //                                   0xfffE7E7E7),
                                      //                             ),
                                      //                             color: Colors.transparent,
                                      //                           ),
                                      //                           elevation: 0,
                                      //                         ),
                                      //                         iconStyleData:
                                      //                             const IconStyleData(
                                      //                           icon: ImageIcon(
                                      //                             AssetImage(
                                      //                                 "assets/icons/tabler_chevron-down.png"),
                                      //                           ),
                                      //                           iconSize: 20,
                                      //                           iconEnabledColor:
                                      //                               Color(0xfff444444),
                                      //                           iconDisabledColor: Colors.red,
                                      //                         ),
                                      //                         dropdownStyleData:
                                      //                             DropdownStyleData(
                                      //                           maxHeight: 204.h,
                                      //                           width: 145.w,
                                      //                           padding: null,
                                      //                           decoration: BoxDecoration(
                                      //                             borderRadius:
                                      //                                 BorderRadius.circular(8),
                                      //                             border: Border.all(
                                      //                               width: 2,
                                      //                               color: const Color(
                                      //                                   0xfffE7E7E7),
                                      //                             ),
                                      //                             color: Colors.white,
                                      //                           ),
                                      //                           elevation: 0,
                                      //                           offset: const Offset(0, -5),
                                      //                           scrollbarTheme:
                                      //                               ScrollbarThemeData(
                                      //                             radius:
                                      //                                 const Radius.circular(8),
                                      //                             thickness:
                                      //                                 MaterialStateProperty.all<
                                      //                                     double>(4),
                                      //                             thumbVisibility:
                                      //                                 MaterialStateProperty.all<
                                      //                                     bool>(true),
                                      //                           ),
                                      //                         ),
                                      //                         menuItemStyleData:
                                      //                             const MenuItemStyleData(
                                      //                           height: 40,
                                      //                           //padding: EdgeInsets.only(left: 14, right: 14),
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //               SizedBox(
                                      //                 height: 16.h,
                                      //               ),
                                      //             ],
                                      //           )
                                      : selectedIndex == 2
                                          ? Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 16.0.w),
                                              child: Column(
                                                children: [
                                                  ListView.builder(
                                                    physics:
                                                        const ScrollPhysics(),
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: profileCont
                                                        .userChannelsModel!
                                                        .jsonChannelsArray!
                                                        .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      var homeItem = profileCont
                                                              .userChannelsModel!
                                                              .jsonChannelsArray![
                                                          index];
                                                      return Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 16.0.h),
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          6.w,
                                                                      vertical:
                                                                          16.h),
                                                              width: double
                                                                  .infinity,
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  border: Border.all(
                                                                      color: const Color(
                                                                          0xffF6F5FB),
                                                                      width:
                                                                          2)),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        height:
                                                                            144.h,
                                                                        width:
                                                                            120.w,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(6),
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(9.0),
                                                                          child: homeItem.channelImage != null
                                                                              ? Image.network(
                                                                                  String.fromCharCodes(
                                                                                    base64Decode(homeItem.channelImage ?? ""),
                                                                                  ),
                                                                                  fit: BoxFit.cover,
                                                                                )
                                                                              : Container(
                                                                                  padding: const EdgeInsets.all(20.0),
                                                                                  height: 144.h,
                                                                                  width: 120.w,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(8.0),
                                                                                    border: Border.all(width: 2, color: const Color(0xffC6BEE3)),
                                                                                  ),
                                                                                  child: SvgPicture.asset(
                                                                                    "assets/svg/Channel Tag.svg",
                                                                                  ),
                                                                                ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            13.w,
                                                                      ),
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              CustomText(
                                                                                text: homeItem.chanelName,
                                                                                fontColor: const Color(0xff444444),
                                                                                fontSize: 18.sp,
                                                                                fontWeight: FontWeight.w600,
                                                                                fontFamily: "Chillax",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                13.h,
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              const Icon(
                                                                                Icons.calendar_month,
                                                                                color: Color(0xff444444),
                                                                                size: 20,
                                                                              ),
                                                                              SizedBox(
                                                                                width: 6.w,
                                                                              ),
                                                                              CustomText(
                                                                                text: homeItem.channelCreateDate,
                                                                                fontColor: const Color(0xff868686),
                                                                                fontSize: 12.sp,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: "Poppins",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                13.h,
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 36.h,
                                                                                child: ElevatedButton(
                                                                                  onPressed: () {},
                                                                                  style: ElevatedButton.styleFrom(
                                                                                      foregroundColor: const Color(0xFF3C0061),
                                                                                      backgroundColor: Colors.white,
                                                                                      elevation: 0,
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(8),
                                                                                        side: const BorderSide(
                                                                                          width: 2,
                                                                                          color: Color(0xFFF6F5FB),
                                                                                        ),
                                                                                      ),
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0)),
                                                                                  child: Row(
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      SvgPicture.asset(
                                                                                        "assets/svg/Default Channel Tag.svg",
                                                                                        color: const Color(0xff3C0061),
                                                                                      ),
                                                                                      const SizedBox(width: 8.0),
                                                                                      CustomText(
                                                                                        text: '${homeItem.totalNotesInChannel?.toString() ?? ""} Notes',
                                                                                        fontColor: const Color(0xff444444),
                                                                                        fontSize: 14.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        fontFamily: "Chillax",
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                8.h,
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed:
                                                                                () async {
                                                                                  await profile.createUsersFollow(
                                                                                      auth.otherUserHandel);
                                                                                  auth.profileModel
                                                                                      ?.followStatus ==
                                                                                      0
                                                                                      ? auth.profileModel
                                                                                      ?.followStatus = 1
                                                                                      : auth.profileModel
                                                                                      ?.followStatus = 0;
                                                                                  profile.update();},
                                                                            style: ElevatedButton.styleFrom(
                                                                                foregroundColor: const Color(0xFF3C0061),
                                                                                backgroundColor:  auth.profileModel?.followStatus==0
                                                                                    ? const Color(
                                                                                    0xff3C0061)
                                                                                    :  Colors.white,
                                                                                elevation: 0,
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius.circular(8),
                                                                                  side: const BorderSide(
                                                                                    color:Color(0xFF3C0061), // Set the border color to red
                                                                                    width: 1, // Set the border width
                                                                                  ),
                                                                                ),
                                                                                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5.0)),
                                                                            child:
                                                                                CustomText(
                                                                              text: auth.profileModel?.followStatus==1
                                                                                  ? "Following"
                                                                                  : "Follow",
                                                                              fontColor: auth.profileModel?.followStatus==0
                                                                                  ?  Colors.white
                                                                                  : Color(0xff3C0061),
                                                                              fontSize: 14.sp,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontFamily: "Chillax",
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        16.h,
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.only(
                                                                        right: 8
                                                                            .w),
                                                                    width: double
                                                                        .infinity,
                                                                    height: 50,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .transparent,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: const Color(
                                                                            0xFFF6F5FB),
                                                                        width:
                                                                            1,
                                                                      ),
                                                                    ),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 8,
                                                                              vertical: 16),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            border:
                                                                                Border.all(
                                                                              color: const Color(0xFFF6F5FB),
                                                                              width: 1,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              CustomText(
                                                                                text: homeItem.totalChannelFollower?.toString() ?? "",
                                                                                fontColor: const Color(0xff3C0061),
                                                                                fontSize: 14.sp,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: "Poppins",
                                                                              ),
                                                                              const SizedBox(
                                                                                width: 10,
                                                                              ),
                                                                              CustomText(
                                                                                text: 'Followers',
                                                                                fontColor: const Color(0xff444444),
                                                                                fontSize: 14.sp,
                                                                                fontWeight: FontWeight.w300,
                                                                                fontFamily: "Poppins",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            IconButton(
                                                                              icon: const Icon(
                                                                                Icons.favorite_border,
                                                                                color: Color(0xff444444),
                                                                              ),
                                                                              onPressed: () {},
                                                                            ),
                                                                            CustomText(
                                                                              text: homeItem.totalLikesInChannel?.toString() ?? "",
                                                                              fontColor: const Color(0xff444444),
                                                                              fontSize: 12.sp,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: "Poppins",
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.comment_outlined,
                                                                              color: Color(0xff444444),
                                                                            ),
                                                                            const SizedBox(width: 8.0),
                                                                            Text(
                                                                              homeItem.totalNoteReplyInChannel?.toString() ?? "",
                                                                              style: const TextStyle(
                                                                                color: Color(0xff444444),
                                                                                fontSize: 12.0,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontFamily: "Poppins",
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            SvgPicture.asset(
                                                                              "assets/svg/note-multiple-outline.svg",
                                                                              height: 20,
                                                                              width: 20,
                                                                            ),
                                                                            const SizedBox(width: 8.0),
                                                                            Text(
                                                                              homeItem.totalRenotesInChannel?.toString() ?? "",
                                                                              style: const TextStyle(
                                                                                color: Color(0xff444444),
                                                                                fontSize: 12.0,
                                                                                fontWeight: FontWeight.w400,
                                                                                fontFamily: "Poppins",
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  )
                                                ],
                                              ),
                                            )
                                          : selectedIndex == 3
                                              ? Column(
                                                  children: [
                                                    // Padding(
                                                    //   padding:
                                                    //       const EdgeInsets.symmetric(
                                                    //           horizontal: 16.0),
                                                    //   child: Row(
                                                    //     mainAxisAlignment:
                                                    //         MainAxisAlignment
                                                    //             .spaceBetween,
                                                    //     children: [
                                                    //       Image.asset(
                                                    //         'assets/icons/Channel Tag Profil.png',
                                                    //       ),
                                                    //       DropdownButtonHideUnderline(
                                                    //         child: DropdownButton2(
                                                    //           // isExpanded: true,
                                                    //           hint: CustomText(
                                                    //             text: 'Choose',
                                                    //             fontColor: const Color(
                                                    //                 0xff868686),
                                                    //             fontSize: 16.sp,
                                                    //             fontWeight:
                                                    //                 FontWeight.w400,
                                                    //             fontFamily: "Poppins",
                                                    //           ),
                                                    //           items: items
                                                    //               .map((item) =>
                                                    //                   DropdownMenuItem<
                                                    //                       String>(
                                                    //                     value: item,
                                                    //                     child:
                                                    //                         CustomText(
                                                    //                       text: item,
                                                    //                       fontColor:
                                                    //                           const Color(
                                                    //                               0xff444444),
                                                    //                       fontSize:
                                                    //                           16.sp,
                                                    //                       fontWeight:
                                                    //                           FontWeight
                                                    //                               .w400,
                                                    //                       fontFamily:
                                                    //                           "Poppins",
                                                    //                     ),
                                                    //                   ))
                                                    //               .toList(),
                                                    //           value: selectedValue,
                                                    //           onChanged: (value) {
                                                    //             setState(() {
                                                    //               selectedValue =
                                                    //                   value as String;
                                                    //             });
                                                    //           },
                                                    //           buttonStyleData:
                                                    //               ButtonStyleData(
                                                    //             height: 36.h,
                                                    //             // width: 150.w,
                                                    //             padding:
                                                    //                 const EdgeInsets
                                                    //                         .only(
                                                    //                     left: 9,
                                                    //                     right: 9),
                                                    //             decoration:
                                                    //                 BoxDecoration(
                                                    //               borderRadius:
                                                    //                   BorderRadius
                                                    //                       .circular(8),
                                                    //               border: Border.all(
                                                    //                 width: 2,
                                                    //                 color: const Color(
                                                    //                     0xfffE7E7E7),
                                                    //               ),
                                                    //               color: Colors
                                                    //                   .transparent,
                                                    //             ),
                                                    //             elevation: 0,
                                                    //           ),
                                                    //           iconStyleData:
                                                    //               const IconStyleData(
                                                    //             icon: ImageIcon(
                                                    //               AssetImage(
                                                    //                   "assets/icons/tabler_chevron-down.png"),
                                                    //             ),
                                                    //             iconSize: 20,
                                                    //             iconEnabledColor:
                                                    //                 Color(0xfff444444),
                                                    //             iconDisabledColor:
                                                    //                 Colors.red,
                                                    //           ),
                                                    //           dropdownStyleData:
                                                    //               DropdownStyleData(
                                                    //             maxHeight: 136.h,
                                                    //             width: 100.w,
                                                    //             padding: null,
                                                    //             decoration:
                                                    //                 BoxDecoration(
                                                    //               borderRadius:
                                                    //                   BorderRadius
                                                    //                       .circular(8),
                                                    //               border: Border.all(
                                                    //                 width: 2,
                                                    //                 color: const Color(
                                                    //                     0xfffE7E7E7),
                                                    //               ),
                                                    //               color: Colors.white,
                                                    //             ),
                                                    //             elevation: 0,
                                                    //             offset:
                                                    //                 const Offset(0, -5),
                                                    //             scrollbarTheme:
                                                    //                 ScrollbarThemeData(
                                                    //               radius: const Radius
                                                    //                   .circular(8),
                                                    //               thickness:
                                                    //                   MaterialStateProperty
                                                    //                       .all<double>(
                                                    //                           4),
                                                    //               thumbVisibility:
                                                    //                   MaterialStateProperty
                                                    //                       .all<bool>(
                                                    //                           true),
                                                    //             ),
                                                    //           ),
                                                    //           menuItemStyleData:
                                                    //               const MenuItemStyleData(
                                                    //             height: 40,
                                                    //             //padding: EdgeInsets.only(left: 14, right: 14),
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //       Image.asset(
                                                    //         'assets/icons/Sort.png',
                                                    //       ),
                                                    //       DropdownButtonHideUnderline(
                                                    //         child: DropdownButton2(
                                                    //           // isExpanded: true,
                                                    //           hint: CustomText(
                                                    //             text: 'Choose',
                                                    //             fontColor: const Color(
                                                    //                 0xff868686),
                                                    //             fontSize: 16.sp,
                                                    //             fontWeight:
                                                    //                 FontWeight.w400,
                                                    //             fontFamily: "Poppins",
                                                    //           ),
                                                    //           items: sorts
                                                    //               .map((item) =>
                                                    //                   DropdownMenuItem<
                                                    //                       String>(
                                                    //                     value: item,
                                                    //                     child:
                                                    //                         CustomText(
                                                    //                       text: item,
                                                    //                       fontColor:
                                                    //                           const Color(
                                                    //                               0xff444444),
                                                    //                       fontSize:
                                                    //                           16.sp,
                                                    //                       fontWeight:
                                                    //                           FontWeight
                                                    //                               .w400,
                                                    //                       fontFamily:
                                                    //                           "Poppins",
                                                    //                     ),
                                                    //                   ))
                                                    //               .toList(),
                                                    //           value: selectedSort,
                                                    //           onChanged: (value) {
                                                    //             setState(() {
                                                    //               selectedSort =
                                                    //                   value as String;
                                                    //             });
                                                    //           },
                                                    //           buttonStyleData:
                                                    //               ButtonStyleData(
                                                    //             height: 36.h,
                                                    //             // width: 150.w,
                                                    //             padding:
                                                    //                 const EdgeInsets
                                                    //                         .only(
                                                    //                     left: 9,
                                                    //                     right: 9),
                                                    //             decoration:
                                                    //                 BoxDecoration(
                                                    //               borderRadius:
                                                    //                   BorderRadius
                                                    //                       .circular(8),
                                                    //               border: Border.all(
                                                    //                 width: 2,
                                                    //                 color: const Color(
                                                    //                     0xfffE7E7E7),
                                                    //               ),
                                                    //               color: Colors
                                                    //                   .transparent,
                                                    //             ),
                                                    //             elevation: 0,
                                                    //           ),
                                                    //           iconStyleData:
                                                    //               const IconStyleData(
                                                    //             icon: ImageIcon(
                                                    //               AssetImage(
                                                    //                   "assets/icons/tabler_chevron-down.png"),
                                                    //             ),
                                                    //             iconSize: 20,
                                                    //             iconEnabledColor:
                                                    //                 Color(0xfff444444),
                                                    //             iconDisabledColor:
                                                    //                 Colors.red,
                                                    //           ),
                                                    //           dropdownStyleData:
                                                    //               DropdownStyleData(
                                                    //             maxHeight: 204.h,
                                                    //             width: 145.w,
                                                    //             padding: null,
                                                    //             decoration:
                                                    //                 BoxDecoration(
                                                    //               borderRadius:
                                                    //                   BorderRadius
                                                    //                       .circular(8),
                                                    //               border: Border.all(
                                                    //                 width: 2,
                                                    //                 color: const Color(
                                                    //                     0xfffE7E7E7),
                                                    //               ),
                                                    //               color: Colors.white,
                                                    //             ),
                                                    //             elevation: 0,
                                                    //             offset:
                                                    //                 const Offset(0, -5),
                                                    //             scrollbarTheme:
                                                    //                 ScrollbarThemeData(
                                                    //               radius: const Radius
                                                    //                   .circular(8),
                                                    //               thickness:
                                                    //                   MaterialStateProperty
                                                    //                       .all<double>(
                                                    //                           4),
                                                    //               thumbVisibility:
                                                    //                   MaterialStateProperty
                                                    //                       .all<bool>(
                                                    //                           true),
                                                    //             ),
                                                    //           ),
                                                    //           menuItemStyleData:
                                                    //               const MenuItemStyleData(
                                                    //             height: 40,
                                                    //             //padding: EdgeInsets.only(left: 14, right: 14),
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    SizedBox(
                                                      height: 16.h,
                                                    ),
                                                    profileCont.userMediaModel
                                                            .isEmpty
                                                        ? Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical:
                                                                        16,
                                                                  ),
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          border: Border
                                                                              .all(
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                const Color(0xffF6F5FB),
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(12)),
                                                                  child: Column(
                                                                    children: [
                                                                      Image.asset(
                                                                          "assets/icons/Renote.png"),
                                                                      CustomText(
                                                                        text:
                                                                            'No Notes with Media Posted',
                                                                        fontColor:
                                                                            const Color(0xff666666),
                                                                        fontSize:
                                                                            18.sp,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            "Poppins",
                                                                      ),
                                                                      CustomText(
                                                                        text:
                                                                            'Any notes you post that contain \n images will show up here',
                                                                        fontColor:
                                                                            const Color(0xff767676),
                                                                        fontSize:
                                                                            14.sp,
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        fontFamily:
                                                                            "Poppins",
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 16.h),
                                                            ],
                                                          )
                                                        : ListView.builder(
                                                            physics:
                                                                const ScrollPhysics(),
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            itemCount: profileCont
                                                                .userMediaModel
                                                                .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              var homeItem =
                                                                  profileCont
                                                                          .userMediaModel[
                                                                      index];
                                                              return Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            16.0.h),
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 16.0),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              1,
                                                                          width:
                                                                              double.infinity,
                                                                          color:
                                                                              const Color(0xffE7E7E7),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            16.h,
                                                                      ),
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                12,
                                                                            horizontal:
                                                                                16),
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        child:
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
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(6.0),
                                                                                    child: homeItem.profileImage != null
                                                                                        ? Image.network(
                                                                                            String.fromCharCodes(
                                                                                              base64Decode(homeItem.profileImage ?? ""),
                                                                                            ),
                                                                                            fit: BoxFit.cover,
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
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    CustomText(
                                                                                      text: homeItem.userName,
                                                                                      fontColor: const Color(0xff160323),
                                                                                      fontSize: 16.sp,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontFamily: "Chillax",
                                                                                    ),
                                                                                    CustomText(
                                                                                      text: "@${homeItem.userHandle}",
                                                                                      fontColor: const Color(0xff3C0061),
                                                                                      fontSize: 14.sp,
                                                                                      fontWeight: FontWeight.w300,
                                                                                      fontFamily: "Poppins",
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 12.0),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  CustomText(
                                                                                    text: homeItem.noteTimeAgo,
                                                                                    fontColor: const Color(0xff767676),
                                                                                    fontSize: 14.sp,
                                                                                    fontWeight: FontWeight.w300,
                                                                                    fontFamily: "Poppins",
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 16.w,
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      _showDelete(context);
                                                                                    },
                                                                                    child:  Row(
                                                                                      children: [
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
                                                                      SizedBox(
                                                                        height:
                                                                            16.h,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 16.0.w),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              100.w,
                                                                          height:
                                                                              32.h,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 2, color: const Color(0xffC6BEE3)),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Image.asset('assets/images/Channel Tag.jpg'),
                                                                              const SizedBox(width: 4),
                                                                              CustomText(
                                                                                text: homeItem.channelsName,
                                                                                fontColor: const Color(0xff444444),
                                                                                fontSize: 14.sp,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: "Chillax",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            homeItem.noteBody !=
                                                                                null,
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              16.h,
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            homeItem.noteBody !=
                                                                                null,
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            profileCont.noteId =
                                                                                homeItem.noteId ?? "";
                                                                            profileCont.userHandel =
                                                                                homeItem.userHandle ?? "";
                                                                            profileCont.viewNotes();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                double.infinity,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 16, right: 16),
                                                                            child:
                                                                                CustomText(
                                                                              text: homeItem.noteBody ?? "", // Check for null value of homeItem.noteBody
                                                                              fontColor: const Color(0xff444444),
                                                                              fontSize: 16.sp,
                                                                              height: 1.5,
                                                                              fontFamily: "Poppins",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            homeItem.noteImage !=
                                                                                null,
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              8.h,
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            homeItem.noteImage !=
                                                                                null,
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            profileCont.noteId =
                                                                                homeItem.noteId ?? "";
                                                                            profileCont.userHandel =
                                                                                homeItem.userHandle ?? "";
                                                                            profileCont.viewNotes();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                null,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 16.0, right: 16.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(6.0),
                                                                            ),
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child: homeItem.noteImage != null
                                                                                  ? Image.network(
                                                                                      String.fromCharCodes(base64Decode(homeItem.noteImage ?? "")),
                                                                                      fit: BoxFit.cover,
                                                                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                        print('Error loading image: $exception');
                                                                                        return Padding(
                                                                                          padding: const EdgeInsets.all(0.0),
                                                                                          child: SvgPicture.asset("assets/svg/Image.svg"),
                                                                                        );
                                                                                      },
                                                                                    )
                                                                                  : null,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            8.h,
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            homeItem.renotedId !=
                                                                                null,
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              16.h,
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            homeItem.renotedId !=
                                                                                null,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 16.0),
                                                                          child:
                                                                              Container(
                                                                            padding: const EdgeInsets.only(
                                                                                left: 16,
                                                                                right: 16,
                                                                                top: 10,
                                                                                bottom: 16),
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              border: Border(
                                                                                left: BorderSide(width: 6, color: Color(0xff3C0061)),
                                                                                bottom: BorderSide(width: 6, color: Color(0xff3C0061)),
                                                                              ),
                                                                              // borderRadius: BorderRadius.only(
                                                                              //   bottomRight: Radius.circular(12),
                                                                              // ),
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          width: 50,
                                                                                          height: 50,
                                                                                          decoration: const BoxDecoration(),
                                                                                          child: ClipRRect(
                                                                                            borderRadius: BorderRadius.circular(6.0),
                                                                                            child: homeItem.renotedProfileImage != null
                                                                                                ? Image.network(
                                                                                                    String.fromCharCodes(
                                                                                                      base64Decode(homeItem.renotedProfileImage ?? ""),
                                                                                                    ),
                                                                                                    fit: BoxFit.cover,
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
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            CustomText(
                                                                                              text: homeItem.renotedUserName,
                                                                                              fontColor: const Color(0xff160323),
                                                                                              fontSize: 14.sp,
                                                                                              fontWeight: FontWeight.w600,
                                                                                              fontFamily: "Chillax",
                                                                                            ),
                                                                                            Text(
                                                                                              "@${homeItem.renotedUserHandle}",
                                                                                              style: const TextStyle(
                                                                                                color: Color(0xff3C0061),
                                                                                                fontSize: 12,
                                                                                                fontWeight: FontWeight.w400,
                                                                                                fontFamily: 'Chillax',
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
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                                                                  decoration: BoxDecoration(
                                                                                    border: Border.all(width: 2, color: const Color(0xffC6BEE3)),
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisSize: MainAxisSize.min,
                                                                                    children: [
                                                                                      Image.asset('assets/images/Channel Tag.jpg'),
                                                                                      const SizedBox(width: 4),
                                                                                      CustomText(
                                                                                        text: homeItem.renotedChannelName,
                                                                                        fontColor: const Color(0xff444444),
                                                                                        fontSize: 14.sp,
                                                                                        fontWeight: FontWeight.w500,
                                                                                        fontFamily: "Chillax",
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 8.h,
                                                                                ),
                                                                                CustomText(
                                                                                  text: homeItem.renotedBody,
                                                                                  fontColor: const Color(0xff444444),
                                                                                  fontSize: 16.sp,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  fontFamily: "Poppins",
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 16.h,
                                                                                ),
                                                                                // Visibility(
                                                                                //   visible:
                                                                                //       homeItem.renotedImage != null,
                                                                                //   child:
                                                                                //       Container(
                                                                                //     width: double.infinity,
                                                                                //     // height: 400,
                                                                                //     decoration: BoxDecoration(
                                                                                //       color: Colors.white,
                                                                                //       borderRadius: BorderRadius.circular(4.0),
                                                                                //     ),
                                                                                //     child: ClipRRect(
                                                                                //         borderRadius: BorderRadius.circular(6.0),
                                                                                //         child: homeItem.re != null
                                                                                //             ? Image
                                                                                //             .network(
                                                                                //           String.fromCharCodes(base64Decode(homeItem.noteImage ?? "")),
                                                                                //           fit: BoxFit.cover,
                                                                                //           errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                //             print('Error loading image: $exception');
                                                                                //             return Padding(
                                                                                //               padding: const EdgeInsets.all(0.0),
                                                                                //               child: SvgPicture.asset("assets/svg/Image.svg"),
                                                                                //             );
                                                                                //           },
                                                                                //         )
                                                                                //             : null),
                                                                                //   ),
                                                                                // ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            16.h,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 16.0),
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 8.0),
                                                                          width:
                                                                              double.infinity,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.transparent,
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            border:
                                                                                Border.all(
                                                                              color: const Color(0xFFF6F5FB),
                                                                              width: 1,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceAround,
                                                                            children: [
                                                                              Container(
                                                                                height: 30,
                                                                                child: ElevatedButton.icon(
                                                                                  onPressed: () {
                                                                                    profileCont.noteId = homeItem.noteId ?? "";
                                                                                    profileCont.createNoteLike();
                                                                                  },
                                                                                  icon: const Icon(
                                                                                    Icons.favorite_border,
                                                                                    color: Color(0xffCE1616),
                                                                                  ),
                                                                                  label: Text(
                                                                                    homeItem.totalNoteLikes.toString(),
                                                                                    style: const TextStyle(
                                                                                      color: Color(0xff444444),
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      fontFamily: "Poppins",
                                                                                    ),
                                                                                  ),
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    elevation: 0,
                                                                                    primary: homeItem.likeStatus == 1 ? const Color(0xffFFF0F0) : Colors.transparent,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(4),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              Container(
                                                                                height: 30,
                                                                                child: ElevatedButton.icon(
                                                                                  onPressed: () {
                                                                                    profileCont.replyId = homeItem.noteId;
                                                                                    profileCont.channelId = homeItem.channelsId;
                                                                                    profileCont.userHandel = homeItem.userHandle ?? "";
                                                                                    Get.to(const ReplyingNotes());
                                                                                  },
                                                                                  icon: const Icon(
                                                                                    Icons.comment_outlined,
                                                                                    color: Color(0xff0FA958),
                                                                                  ),
                                                                                  label: Text(
                                                                                    homeItem.totalNoteReply.toString(),
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
                                                                                    backgroundColor: homeItem.noteRepliedStatus == 1 ? const Color(0xffE2F5EB) : Colors.transparent,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(4),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              // GestureDetector(
                                                                              //   onTap: () {
                                                                              //     homeCont.replyId =
                                                                              //         homeItem.noteId ?? "";
                                                                              //     homeCont.channelId =
                                                                              //         homeItem.channelsId ?? "";
                                                                              //     Get.to(const ReplyingNotes());
                                                                              //   },
                                                                              //   child: Row(
                                                                              //     mainAxisSize: MainAxisSize.min,
                                                                              //     children: [
                                                                              //       const Icon(
                                                                              //         Icons.comment_outlined,
                                                                              //         color: Color(0xff0FA958),
                                                                              //       ),
                                                                              //       const SizedBox(width: 8.0),
                                                                              //       CustomText(
                                                                              //         text: homeItem.totalNoteReply,
                                                                              //         fontColor: Color(0xff444444),
                                                                              //         fontSize: 12.sp,
                                                                              //         fontWeight: FontWeight.w400,
                                                                              //         fontFamily: "Poppins",
                                                                              //       ),
                                                                              //     ],
                                                                              //   ),
                                                                              // ),

                                                                              Container(
                                                                                height: 30,
                                                                                child: ElevatedButton.icon(
                                                                                  onPressed: () {
                                                                                    profileCont.renoteId = homeItem.noteId ?? "";
                                                                                    profileCont.channelId = homeItem.channelsId;
                                                                                    profileCont.userHandel = homeItem.userHandle ?? "";
                                                                                    // homeCont.selectedHomePost = homeItem;
                                                                                    Get.to(const Renote());
                                                                                  },
                                                                                  icon: SvgPicture.asset(
                                                                                    "assets/svg/mdi_renote.svg",
                                                                                  ),
                                                                                  label: Text(
                                                                                    homeItem.totalNoteRepost.toString(),
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
                                                                                    backgroundColor: homeItem.noteRenotedStatus == 1 ? const Color(0xffF6EFFF) : Colors.transparent,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(4),
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
                                                                        height:
                                                                            16.h,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                  ],
                                                )
                                              : Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 16.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset(
                                                                'assets/svg/Sort.svg',
                                                              ),
                                                              SizedBox(
                                                                width: 10.w,
                                                              ),
                                                              Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical:
                                                                        6),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0),
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: const Color(
                                                                          0xffE7E7E7)),
                                                                ),
                                                                child:
                                                                    CustomText(
                                                                  text:
                                                                      'Most Recent',
                                                                  fontColor:
                                                                      const Color(
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
                                                            ],
                                                          ),
                                                          DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton2(
                                                              isExpanded: true,
                                                              isDense: true,
                                                              hint: CustomText(
                                                                text: 'Liked',
                                                                fontColor:
                                                                    const Color(
                                                                        0xff444444),
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontFamily:
                                                                    "Poppins",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                              items: more
                                                                  .map((item) =>
                                                                      DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            item,
                                                                        child:
                                                                            CustomText(
                                                                          text:
                                                                              item,
                                                                          fontColor:
                                                                              const Color(0xff444444),
                                                                          fontSize:
                                                                              16.sp,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontFamily:
                                                                              "Poppins",
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                              value:
                                                                  selectedMoreNotes,
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  selectedMoreNotes =
                                                                      value
                                                                          as String;
                                                                  print(value);
                                                                  if (value ==
                                                                      "Liked") {
                                                                    profile.statisticsFilterMore =
                                                                        "liked";
                                                                    profile
                                                                        .profileMore();
                                                                  } else {
                                                                    profile.statisticsFilterMore =
                                                                        "replied";
                                                                    profile
                                                                        .profileMore();
                                                                  }
                                                                });
                                                              },
                                                              buttonStyleData:
                                                                  ButtonStyleData(
                                                                height: 40.h,
                                                                width: 110.w,
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 9,
                                                                        right:
                                                                            9),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  border: Border
                                                                      .all(
                                                                    width: 2,
                                                                    color: const Color(
                                                                        0xfff3C0061),
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                                elevation: 0,
                                                              ),
                                                              iconStyleData:
                                                                  const IconStyleData(
                                                                icon: ImageIcon(
                                                                  AssetImage(
                                                                    "assets/icons/tabler_chevron-down.png",
                                                                  ),
                                                                ),
                                                                iconSize: 20,
                                                                iconEnabledColor:
                                                                    Color(
                                                                        0xfff3C0061),
                                                                iconDisabledColor:
                                                                    Colors.red,
                                                              ),
                                                              dropdownStyleData:
                                                                  DropdownStyleData(
                                                                maxHeight:
                                                                    204.h,
                                                                width: 110.w,
                                                                padding: null,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8),
                                                                  border: Border
                                                                      .all(
                                                                    width: 2,
                                                                    color: const Color(
                                                                        0xfffE7E7E7),
                                                                  ),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                elevation: 0,
                                                                offset:
                                                                    const Offset(
                                                                        0, -5),
                                                                scrollbarTheme:
                                                                    ScrollbarThemeData(
                                                                  radius: const Radius
                                                                      .circular(8),
                                                                  thickness:
                                                                      MaterialStateProperty
                                                                          .all<double>(
                                                                              4),
                                                                  thumbVisibility:
                                                                      MaterialStateProperty.all<
                                                                              bool>(
                                                                          true),
                                                                ),
                                                              ),
                                                              menuItemStyleData:
                                                                  const MenuItemStyleData(
                                                                height: 40,
                                                                //padding: EdgeInsets.only(left: 14, right: 14),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // Padding(
                                                    //   padding:
                                                    //       const EdgeInsets.symmetric(
                                                    //           horizontal: 16.0),
                                                    //   child: Row(
                                                    //     mainAxisAlignment:
                                                    //         MainAxisAlignment
                                                    //             .spaceBetween,
                                                    //     children: [
                                                    //       Image.asset(
                                                    //         'assets/icons/Channel Tag Profil.png',
                                                    //       ),
                                                    //       DropdownButtonHideUnderline(
                                                    //         child: DropdownButton2(
                                                    //           // isExpanded: true,
                                                    //           hint: CustomText(
                                                    //             text: 'Choose',
                                                    //             fontColor: const Color(
                                                    //                 0xff868686),
                                                    //             fontSize: 16.sp,
                                                    //             fontWeight:
                                                    //                 FontWeight.w400,
                                                    //             fontFamily: "Poppins",
                                                    //           ),
                                                    //           items: items
                                                    //               .map((item) =>
                                                    //                   DropdownMenuItem<
                                                    //                       String>(
                                                    //                     value: item,
                                                    //                     child:
                                                    //                         CustomText(
                                                    //                       text: item,
                                                    //                       fontColor:
                                                    //                           const Color(
                                                    //                               0xff444444),
                                                    //                       fontSize:
                                                    //                           16.sp,
                                                    //                       fontWeight:
                                                    //                           FontWeight
                                                    //                               .w400,
                                                    //                       fontFamily:
                                                    //                           "Poppins",
                                                    //                     ),
                                                    //                   ))
                                                    //               .toList(),
                                                    //           value: selectedValue,
                                                    //           onChanged: (value) {
                                                    //             setState(() {
                                                    //               selectedValue =
                                                    //                   value as String;
                                                    //             });
                                                    //           },
                                                    //           buttonStyleData:
                                                    //               ButtonStyleData(
                                                    //             height: 36.h,
                                                    //             // width: 150.w,
                                                    //             padding:
                                                    //                 const EdgeInsets
                                                    //                         .only(
                                                    //                     left: 9,
                                                    //                     right: 9),
                                                    //             decoration:
                                                    //                 BoxDecoration(
                                                    //               borderRadius:
                                                    //                   BorderRadius
                                                    //                       .circular(8),
                                                    //               border: Border.all(
                                                    //                 width: 2,
                                                    //                 color: const Color(
                                                    //                     0xfffE7E7E7),
                                                    //               ),
                                                    //               color: Colors
                                                    //                   .transparent,
                                                    //             ),
                                                    //             elevation: 0,
                                                    //           ),
                                                    //           iconStyleData:
                                                    //               const IconStyleData(
                                                    //             icon: ImageIcon(
                                                    //               AssetImage(
                                                    //                   "assets/icons/tabler_chevron-down.png"),
                                                    //             ),
                                                    //             iconSize: 20,
                                                    //             iconEnabledColor:
                                                    //                 Color(0xfff444444),
                                                    //             iconDisabledColor:
                                                    //                 Colors.red,
                                                    //           ),
                                                    //           dropdownStyleData:
                                                    //               DropdownStyleData(
                                                    //             maxHeight: 136.h,
                                                    //             width: 100.w,
                                                    //             padding: null,
                                                    //             decoration:
                                                    //                 BoxDecoration(
                                                    //               borderRadius:
                                                    //                   BorderRadius
                                                    //                       .circular(8),
                                                    //               border: Border.all(
                                                    //                 width: 2,
                                                    //                 color: const Color(
                                                    //                     0xfffE7E7E7),
                                                    //               ),
                                                    //               color: Colors.white,
                                                    //             ),
                                                    //             elevation: 0,
                                                    //             offset:
                                                    //                 const Offset(0, -5),
                                                    //             scrollbarTheme:
                                                    //                 ScrollbarThemeData(
                                                    //               radius: const Radius
                                                    //                   .circular(8),
                                                    //               thickness:
                                                    //                   MaterialStateProperty
                                                    //                       .all<double>(
                                                    //                           4),
                                                    //               thumbVisibility:
                                                    //                   MaterialStateProperty
                                                    //                       .all<bool>(
                                                    //                           true),
                                                    //             ),
                                                    //           ),
                                                    //           menuItemStyleData:
                                                    //               const MenuItemStyleData(
                                                    //             height: 40,
                                                    //             //padding: EdgeInsets.only(left: 14, right: 14),
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //       Image.asset(
                                                    //         'assets/icons/Sort.png',
                                                    //       ),
                                                    //       DropdownButtonHideUnderline(
                                                    //         child: DropdownButton2(
                                                    //           // isExpanded: true,
                                                    //           hint: CustomText(
                                                    //             text: 'Choose',
                                                    //             fontColor: const Color(
                                                    //                 0xff868686),
                                                    //             fontSize: 16.sp,
                                                    //             fontWeight:
                                                    //                 FontWeight.w400,
                                                    //             fontFamily: "Poppins",
                                                    //           ),
                                                    //           items: sortss
                                                    //               .map((item) =>
                                                    //                   DropdownMenuItem<
                                                    //                       String>(
                                                    //                     value: item,
                                                    //                     child:
                                                    //                         CustomText(
                                                    //                       text: item,
                                                    //                       fontColor:
                                                    //                           const Color(
                                                    //                               0xff444444),
                                                    //                       fontSize:
                                                    //                           16.sp,
                                                    //                       fontWeight:
                                                    //                           FontWeight
                                                    //                               .w400,
                                                    //                       fontFamily:
                                                    //                           "Poppins",
                                                    //                     ),
                                                    //                   ))
                                                    //               .toList(),
                                                    //           value: selectedSort,
                                                    //           onChanged: (value) {
                                                    //             setState(() {
                                                    //               selectedSort =
                                                    //                   value as String;
                                                    //             });
                                                    //           },
                                                    //           buttonStyleData:
                                                    //               ButtonStyleData(
                                                    //             height: 36.h,
                                                    //             // width: 150.w,
                                                    //             padding:
                                                    //                 const EdgeInsets
                                                    //                         .only(
                                                    //                     left: 9,
                                                    //                     right: 9),
                                                    //             decoration:
                                                    //                 BoxDecoration(
                                                    //               borderRadius:
                                                    //                   BorderRadius
                                                    //                       .circular(8),
                                                    //               border: Border.all(
                                                    //                 width: 2,
                                                    //                 color: const Color(
                                                    //                     0xfff3C0061),
                                                    //               ),
                                                    //               color: Colors
                                                    //                   .transparent,
                                                    //             ),
                                                    //             elevation: 0,
                                                    //           ),
                                                    //           iconStyleData:
                                                    //               const IconStyleData(
                                                    //             icon: ImageIcon(
                                                    //               AssetImage(
                                                    //                   "assets/icons/tabler_chevron-down.png"),
                                                    //             ),
                                                    //             iconSize: 20,
                                                    //             iconEnabledColor:
                                                    //                 Color(0xfff444444),
                                                    //             iconDisabledColor:
                                                    //                 Colors.red,
                                                    //           ),
                                                    //           dropdownStyleData:
                                                    //               DropdownStyleData(
                                                    //             maxHeight: 204.h,
                                                    //             width: 145.w,
                                                    //             padding: null,
                                                    //             decoration:
                                                    //                 BoxDecoration(
                                                    //               borderRadius:
                                                    //                   BorderRadius
                                                    //                       .circular(8),
                                                    //               border: Border.all(
                                                    //                 width: 2,
                                                    //                 color: const Color(
                                                    //                     0xfff3C0061),
                                                    //               ),
                                                    //               color: Colors.white,
                                                    //             ),
                                                    //             elevation: 0,
                                                    //             offset:
                                                    //                 const Offset(0, -5),
                                                    //             scrollbarTheme:
                                                    //                 ScrollbarThemeData(
                                                    //               radius: const Radius
                                                    //                   .circular(8),
                                                    //               thickness:
                                                    //                   MaterialStateProperty
                                                    //                       .all<double>(
                                                    //                           4),
                                                    //               thumbVisibility:
                                                    //                   MaterialStateProperty
                                                    //                       .all<bool>(
                                                    //                           true),
                                                    //             ),
                                                    //           ),
                                                    //           menuItemStyleData:
                                                    //               const MenuItemStyleData(
                                                    //             height: 40,
                                                    //             //padding: EdgeInsets.only(left: 14, right: 14),
                                                    //           ),
                                                    //         ),
                                                    //       ),
                                                    //     ],
                                                    //   ),
                                                    // ),
                                                    SizedBox(
                                                      height: 16.h,
                                                    ),
                                                    profileCont.userMoreModel
                                                            .isEmpty
                                                        ? Column(
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    vertical:
                                                                        16,
                                                                  ),
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          border: Border
                                                                              .all(
                                                                            width:
                                                                                1,
                                                                            color:
                                                                                const Color(0xffF6F5FB),
                                                                          ),
                                                                          borderRadius:
                                                                              BorderRadius.circular(12)),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Image.asset(
                                                                          "assets/icons/Renote.png"),
                                                                      CustomText(
                                                                        text:
                                                                            'No Notes Interacted With',
                                                                        fontColor:
                                                                            const Color(0xff666666),
                                                                        fontSize:
                                                                            18.sp,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                        fontFamily:
                                                                            "Poppins",
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      Center(
                                                                        child:
                                                                            CustomText(
                                                                          text:
                                                                              'Any notes you like, reply or share will \n show up here',
                                                                          fontColor:
                                                                              const Color(0xff767676),
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                          fontFamily:
                                                                              "Poppins",
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 16.h),
                                                            ],
                                                          )
                                                        : ListView.builder(
                                                            physics:
                                                                const ScrollPhysics(),
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            itemCount: profileCont
                                                                .userMoreModel
                                                                .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              var homeItem =
                                                                  profileCont
                                                                          .userMoreModel[
                                                                      index];
                                                              return Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            16.0.h),
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                  //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 16.0),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              1,
                                                                          width:
                                                                              double.infinity,
                                                                          color:
                                                                              const Color(0xffE7E7E7),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            16.h,
                                                                      ),
                                                                      Container(
                                                                        width: double
                                                                            .infinity,
                                                                        padding: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                12,
                                                                            horizontal:
                                                                                16),
                                                                        decoration:
                                                                            const BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                        child:
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
                                                                                    borderRadius: BorderRadius.circular(8),
                                                                                  ),
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(6.0),
                                                                                    child: homeItem.profileImage != null
                                                                                        ? Image.network(
                                                                                            String.fromCharCodes(
                                                                                              base64Decode(homeItem.profileImage ?? ""),
                                                                                            ),
                                                                                            fit: BoxFit.cover,
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
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    CustomText(
                                                                                      text: homeItem.userName,
                                                                                      fontColor: const Color(0xff160323),
                                                                                      fontSize: 16.sp,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      fontFamily: "Chillax",
                                                                                    ),
                                                                                    CustomText(
                                                                                      text: "@${homeItem.userHandle}",
                                                                                      fontColor: const Color(0xff3C0061),
                                                                                      fontSize: 14.sp,
                                                                                      fontWeight: FontWeight.w300,
                                                                                      fontFamily: "Poppins",
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 12.0),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  CustomText(
                                                                                    text: homeItem.noteTimeAgo,
                                                                                    fontColor: const Color(0xff767676),
                                                                                    fontSize: 14.sp,
                                                                                    fontWeight: FontWeight.w300,
                                                                                    fontFamily: "Poppins",
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 16.w,
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      _showDelete(context);
                                                                                    },
                                                                                    child:  Row(
                                                                                      children: [
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
                                                                      SizedBox(
                                                                        height:
                                                                            16.h,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 16.0.w),
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              100.w,
                                                                          height:
                                                                              32.h,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            border:
                                                                                Border.all(width: 2, color: const Color(0xffC6BEE3)),
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              Image.asset('assets/images/Channel Tag.jpg'),
                                                                              const SizedBox(width: 4),
                                                                              CustomText(
                                                                                text: homeItem.channelsName,
                                                                                fontColor: const Color(0xff444444),
                                                                                fontSize: 14.sp,
                                                                                fontWeight: FontWeight.w500,
                                                                                fontFamily: "Chillax",
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            homeItem.noteBody !=
                                                                                null,
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              16.h,
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            homeItem.noteBody !=
                                                                                null,
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            profileCont.noteId =
                                                                                homeItem.noteId ?? "";
                                                                            profileCont.userHandel =
                                                                                homeItem.userHandle ?? "";
                                                                            profileCont.viewNotes();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                double.infinity,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 16, right: 16),
                                                                            child:
                                                                                CustomText(
                                                                              text: homeItem.noteBody ?? "", // Check for null value of homeItem.noteBody
                                                                              fontColor: const Color(0xff444444),
                                                                              fontSize: 16.sp,
                                                                              height: 1.5,
                                                                              fontFamily: "Poppins",
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            homeItem.noteImage !=
                                                                                null,
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              8.h,
                                                                        ),
                                                                      ),
                                                                      Visibility(
                                                                        visible:
                                                                            homeItem.noteImage !=
                                                                                null,
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            profileCont.noteId =
                                                                                homeItem.noteId ?? "";
                                                                            profileCont.userHandel =
                                                                                homeItem.userHandle ?? "";
                                                                            profileCont.viewNotes();
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            width:
                                                                                double.infinity,
                                                                            height:
                                                                                null,
                                                                            margin:
                                                                                const EdgeInsets.only(left: 16.0, right: 16.0),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(6.0),
                                                                            ),
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(8.0),
                                                                              child: homeItem.noteImage != null
                                                                                  ? Image.network(
                                                                                      String.fromCharCodes(base64Decode(homeItem.noteImage ?? "")),
                                                                                      fit: BoxFit.cover,
                                                                                      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                                                                        print('Error loading image: $exception');
                                                                                        return Padding(
                                                                                          padding: const EdgeInsets.all(0.0),
                                                                                          child: SvgPicture.asset("assets/svg/Image.svg"),
                                                                                        );
                                                                                      },
                                                                                    )
                                                                                  : null,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            8.h,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            16.h,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 16.0),
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 8.0),
                                                                          width:
                                                                              double.infinity,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.transparent,
                                                                            borderRadius:
                                                                                BorderRadius.circular(8),
                                                                            border:
                                                                                Border.all(
                                                                              color: const Color(0xFFF6F5FB),
                                                                              width: 1,
                                                                            ),
                                                                          ),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceAround,
                                                                            children: [
                                                                              Container(
                                                                                height: 30,
                                                                                child: ElevatedButton.icon(
                                                                                  onPressed: () {
                                                                                    profileCont.noteId = homeItem.noteId ?? "";
                                                                                    profileCont.createNoteLike();
                                                                                  },
                                                                                  icon: const Icon(
                                                                                    Icons.favorite_border,
                                                                                    color: Color(0xffCE1616),
                                                                                  ),
                                                                                  label: Text(
                                                                                    homeItem.totalNoteLikes.toString(),
                                                                                    style: const TextStyle(
                                                                                      color: Color(0xff444444),
                                                                                      fontSize: 12,
                                                                                      fontWeight: FontWeight.w400,
                                                                                      fontFamily: "Poppins",
                                                                                    ),
                                                                                  ),
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    elevation: 0,
                                                                                    primary: homeItem.likeStatus == 1 ? const Color(0xffFFF0F0) : Colors.transparent,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(4),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),

                                                                              Container(
                                                                                height: 30,
                                                                                child: ElevatedButton.icon(
                                                                                  onPressed: () {
                                                                                    profileCont.replyId = homeItem.noteId;
                                                                                    profileCont.channelId = homeItem.channelsId;
                                                                                    profileCont.userHandel = homeItem.userHandle ?? "";
                                                                                    Get.to(const ReplyingNotes());
                                                                                  },
                                                                                  icon: const Icon(
                                                                                    Icons.comment_outlined,
                                                                                    color: Color(0xff0FA958),
                                                                                  ),
                                                                                  label: Text(
                                                                                    homeItem.totalNoteReply.toString(),
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
                                                                                    backgroundColor: homeItem.noteRepliedStatus == 1 ? const Color(0xffE2F5EB) : Colors.transparent,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(4),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              // GestureDetector(
                                                                              //   onTap: () {
                                                                              //     homeCont.replyId =
                                                                              //         homeItem.noteId ?? "";
                                                                              //     homeCont.channelId =
                                                                              //         homeItem.channelsId ?? "";
                                                                              //     Get.to(const ReplyingNotes());
                                                                              //   },
                                                                              //   child: Row(
                                                                              //     mainAxisSize: MainAxisSize.min,
                                                                              //     children: [
                                                                              //       const Icon(
                                                                              //         Icons.comment_outlined,
                                                                              //         color: Color(0xff0FA958),
                                                                              //       ),
                                                                              //       const SizedBox(width: 8.0),
                                                                              //       CustomText(
                                                                              //         text: homeItem.totalNoteReply,
                                                                              //         fontColor: Color(0xff444444),
                                                                              //         fontSize: 12.sp,
                                                                              //         fontWeight: FontWeight.w400,
                                                                              //         fontFamily: "Poppins",
                                                                              //       ),
                                                                              //     ],
                                                                              //   ),
                                                                              // ),

                                                                              Container(
                                                                                height: 30,
                                                                                child: ElevatedButton.icon(
                                                                                  onPressed: () {
                                                                                    profileCont.renoteId = homeItem.noteId ?? "";
                                                                                    profileCont.channelId = homeItem.channelsId;
                                                                                    profileCont.userHandel = homeItem.userHandle ?? "";
                                                                                    // homeCont.selectedHomePost = homeItem;
                                                                                    Get.to(const Renote());
                                                                                  },
                                                                                  icon: SvgPicture.asset(
                                                                                    "assets/svg/mdi_renote.svg",
                                                                                  ),
                                                                                  label: Text(
                                                                                    homeItem.totalNoteRepost.toString(),
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
                                                                                    backgroundColor: homeItem.noteRenotedStatus == 1 ? const Color(0xffF6EFFF) : Colors.transparent,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(4),
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
                                                                        height:
                                                                            16.h,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                  ],
                                                )
                            ]),
                      ),

                      SizedBox(
                        height: 35.h,
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  void _showSave(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 45.h,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
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
    var userNotes = homeForOtherUser.viewsNotes();
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

  void _showDelete(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
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
                    GestureDetector(
                      onTap: () {
                        _showDeleteOne(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset("assets/icons/Delete.png"),
                          SizedBox(
                            width: 12.w,
                          ),
                          CustomText(
                            text: 'Delete Note',
                            fontColor: const Color(0xffC80000),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  void _showDeleteOne(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
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
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Image.asset("assets/icons/Delete (1).png"),
                    CustomText(
                      text: 'Are you sure you want to delete?',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                    ),
                    SizedBox(
                      height: 16.h,
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
                        Column(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 42.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: const Color(0xFF3C0061),
                                    backgroundColor: Colors.white,
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
                          ],
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 42.h,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(const Profile());
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
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 45.h,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/Following Channel.png"),
                          SizedBox(
                            width: 12.w,
                          ),
                          CustomText(
                            text: 'Follow All Channels',
                            fontColor: const Color(0xff444444),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color(0xfffE7E7E7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/Unfollow Channel.png"),
                          SizedBox(
                            width: 12.w,
                          ),
                          CustomText(
                            text: 'Unfollow All Channels',
                            fontColor: const Color(0xff444444),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color(0xfffE7E7E7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                  "assets/icons/Channel Tag Profil.png"),
                              SizedBox(
                                width: 12.w,
                              ),
                              CustomText(
                                text: 'Auto-Follow New Channels',
                                fontColor: const Color(0xff444444),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                              ),
                            ],
                          ),
                          const Icon(
                            Icons.check,
                            color: Color(0xff444444),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color(0xfffE7E7E7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/Mute.png"),
                          SizedBox(
                            width: 12.w,
                          ),
                          CustomText(
                            text: 'Mute User',
                            fontColor: const Color(0xff444444),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color(0xfffE7E7E7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/Unfollow User.png"),
                          SizedBox(
                            width: 12.w,
                          ),
                          CustomText(
                            text: 'Unfollow User',
                            fontColor: const Color(0xff444444),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color(0xfffE7E7E7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
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
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color(0xfffE7E7E7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/Report.png"),
                          SizedBox(
                            width: 12.w,
                          ),
                          CustomText(
                            text: 'Report User',
                            fontColor: const Color(0xffDA0000),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  void _showCreateChannel(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 45.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/svg/Edit Icon.svg"),
                        SizedBox(
                          width: 12.w,
                        ),
                        CustomText(
                          text: 'Edit Channel',
                          fontColor: const Color(0xff444444),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color(0xfffE7E7E7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                              "assets/icons/Default Channel Tag.svg"),
                          SizedBox(
                            width: 12.w,
                          ),
                          CustomText(
                            text: 'Set Channel as Default',
                            fontColor: const Color(0xff444444),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        color: const Color(0xfffE7E7E7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/svg/Delete.sve"),
                          SizedBox(
                            width: 12.w,
                          ),
                          CustomText(
                            text: 'Delete Note',
                            fontColor: const Color(0xffC80000),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  void _showBottomMenuOfUser(
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
                          bool isHitApi = await profile.saveNote() ?? false;
                          if (isHitApi) {
                            profile.userNotesModel[index].noteSavedStatus == 0
                                ? profile
                                    .userNotesModel[index].noteSavedStatus = 1
                                : profile
                                    .userNotesModel[index].noteSavedStatus = 0;
                            Navigator.pop(context);
                            await profile.userNotes();
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: CustomText(
                              text: profile.userNotesModel[index]
                                          .noteSavedStatus ==
                                      0
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
                          Navigator.pop(context);
                          deleteBottomSheet(context);
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

  void _OtherUserBottomSheet(BuildContext context, int saveNoteStatus,
      bool threadStart, int index, int userFollowStatus) {
    showModalBottomSheet(
      isScrollControlled: true,
      useRootNavigator: true,
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
                          bool isHitApi = await profile.saveNote() ?? false;
                          if (isHitApi) {
                            profile.userNotesModel[index].noteSavedStatus == 0
                                ? profile
                                    .userNotesModel[index].noteSavedStatus = 1
                                : profile
                                    .userNotesModel[index].noteSavedStatus = 0;
                            Navigator.pop(context);
                            await profile.userNotes();
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: CustomText(
                              text: profile.userNotesModel[index]
                                          .noteSavedStatus ==
                                      0
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
                        onTap: () {
                          profile.createUserFollow();
                          Navigator.pop(context);
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
                        onTap: () {
                          homeForOtherUser.userInteractionsMute();
                          Navigator.pop(context);
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
                          homeForOtherUser.userInteractionsBlocked();
                          Navigator.pop(context);
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
                      Row(
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
                              onPressed: () async {
                                await profile.deleteNote();
                                await profile.userNotes();
                                Navigator.pop(context);
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

  void _showBottomMenuOfUserRenote(
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
                          bool isHitApi = await profile.saveNote() ?? false;
                          if (isHitApi) {
                            profile.userRenotesModel[index].noteSavedStatus == 0
                                ? profile
                                    .userRenotesModel[index].noteSavedStatus = 1
                                : profile.userRenotesModel[index]
                                    .noteSavedStatus = 0;
                            Navigator.pop(context);
                            await profile.userReNotes();
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: CustomText(
                              text: profile.userNotesModel[index]
                                          .noteSavedStatus ==
                                      0
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
                          Navigator.pop(context);
                          deleteRenoteBottomSheet(context);
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

  Future<void> deleteRenoteBottomSheet(BuildContext context) async {
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
                              onPressed: () async {
                                await profile.deleteNote();
                                await profile.userReNotes();
                                Navigator.pop(context);
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
}
