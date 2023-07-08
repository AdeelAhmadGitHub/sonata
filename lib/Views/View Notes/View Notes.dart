import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sonata/Controllers/auth_controller.dart';
import 'package:sonata/Views/SideBar/SideBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/HomeController/HomeController.dart';
import '../../Models/ViewNotesModel/ViewNotesModel.dart';
import '../Create Note (Replying)/Replying Notes.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../Renote/Renote.dart';
import '../Widgets/custom_text.dart';

class ViewNotes extends StatefulWidget {
  final ViewNotesModel? viewNotesModel;
  const ViewNotes({Key? key, this.viewNotesModel}) : super(key: key);

  @override
  State<ViewNotes> createState() => _ViewNotesState();
}

class _ViewNotesState extends State<ViewNotes> {
  final ScrollController _scrollController = ScrollController();

  var viewCont = Get.put(HomeController());
  var auth = Get.find<AuthController>();
  bool _isRowVisible = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_toggleRowVisibility);
  }

  void _toggleRowVisibility() {
    setState(() {
      _isRowVisible = _scrollController.position.pixels > 0;
    });
  }
  @override
  Widget build(BuildContext context) {
    print(
        "irfaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaar${viewCont.viewNotesModel?.userName}");
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
                            auth.profileModel?.profileImage ??
                                "")),
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
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                _toggleRowVisibility();
              }
              return false;
            },

            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xfff160323),
                            size: 30,
                          ),
                        ),
                        SizedBox(
                          width: 18,
                        ),
                        CustomText(
                          text: 'Note',
                          fontColor: const Color(0xff160323),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16.0.h),
                    child: GestureDetector(
                      onTap: () {},
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
                                    color: Color.fromRGBO(60, 0, 97, 0.06),
                                    offset: Offset(0, 2),
                                    blurRadius: 6,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 50.h,
                                        height: 50.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(6.0),
                                          child: widget
                                              .viewNotesModel?.profileImage !=
                                              null
                                              ? Image.network(
                                            String.fromCharCodes(base64Decode(
                                                widget.viewNotesModel
                                                    ?.profileImage ??
                                                    "")),
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
                                            text: widget.viewNotesModel?.userName,
                                            fontColor: const Color(0xff160323),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Chillax",
                                          ),
                                          CustomText(
                                            text:
                                            "@${widget.viewNotesModel?.userHandle ?? ""}",
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
                                          text: widget.viewNotesModel?.noteTimeAgo ??
                                              "",
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
                                            _showMenuViewNotes(context);
                                          },
                                          child: Row(
                                            children: [
                                              Image.asset('assets/images/menu.png'),
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
                            Visibility(
                              visible: widget.viewNotesModel?.jsonRenoteArray == null,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: const Color(0xffC6BEE3)),
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
                                        text:
                                        widget.viewNotesModel?.channelName ?? "",
                                        fontColor: const Color(0xff444444),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Chillax",
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Visibility(
                              visible: widget.viewNotesModel?.noteBody!= null &&
                                  widget.viewNotesModel!.noteBody!.isNotEmpty,
                              child: Container(
                                width: double.infinity,
                                margin: const EdgeInsets.only(
                                    left: 16, right: 16),
                                child: widget.viewNotesModel?.noteBody != null &&
                                    widget.viewNotesModel!.noteBody
                                       ! .startsWith('http')
                                    ? InkWell(
                                  onTap: () {
                                    if (widget.viewNotesModel?.noteBody !=
                                        null) {
                                      launch(widget.viewNotesModel?.noteBody??
                                          '');
                                    }
                                  },
                                  child: CustomText(
                                    text: widget.viewNotesModel != null
                                        ? Uri.parse(widget.viewNotesModel
                                        !.noteBody!)
                                        .host
                                        : '',
                                    fontColor:
                                    const Color(0xff444444),
                                    fontSize: 16.sp,
                                    height: 1.5,
                                    fontFamily: 'Poppins',
                                  ),
                                )
                                    : CustomText(
                                  text: widget.viewNotesModel?.noteBody ?? "",
                                  fontColor:
                                  const Color(0xff444444),
                                  fontSize: 16.sp,
                                  height: 1.5,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                            // Container(
                            //   width: double.infinity,
                            //   margin: const EdgeInsets.only(left: 16, right: 16),
                            //   child: CustomText(
                            //     text: widget.viewNotesModel?.noteBody ?? "",
                            //     fontColor: const Color(0xff444444),
                            //     fontSize: 16.sp,
                            //     height: 1.5,
                            //     fontFamily: "Poppins",
                            //   ),
                            // ),
                            Visibility(
                              visible: widget.viewNotesModel?.noteImage != null,
                              child: SizedBox(
                                height: 16.h,
                              ),
                            ),
                            Visibility(
                              visible: widget.viewNotesModel?.noteImage != null,
                              child: Container(
                                width: double.infinity,
                                height: null,
                                margin:
                                const EdgeInsets.only(left: 16.0, right: 16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: widget.viewNotesModel?.noteImage != null
                                      ? Image.network(
                                    String.fromCharCodes(base64Decode(
                                        widget.viewNotesModel?.noteImage ??
                                            "")),
                                    fit: BoxFit.cover,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      print('Error loading image: $exception');
                                      return Padding(
                                        padding: const EdgeInsets.all(0.0),
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
                              height: 16.h,
                            ),
                            Visibility(
                              visible: widget.viewNotesModel?.renoteId != null,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 10, bottom: 16),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      left: BorderSide(
                                          width: 6, color: Color(0xff3C0061)),
                                      bottom: BorderSide(
                                          width: 6, color: Color(0xff3C0061)),
                                    ),
                                    // borderRadius: BorderRadius.only(
                                    //   bottomRight: Radius.circular(12),
                                    // ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  borderRadius:
                                                  BorderRadius.circular(6.0),
                                                  child: widget
                                                      .viewNotesModel
                                                      ?.jsonRenoteArray
                                                      ?.renotedProfileImage !=
                                                      null
                                                      ? Image.network(
                                                    String.fromCharCodes(
                                                        base64Decode(widget
                                                            .viewNotesModel
                                                            ?.jsonRenoteArray
                                                            ?.renotedProfileImage ??
                                                            "")),
                                                    fit: BoxFit.cover,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                        Object exception,
                                                        StackTrace?
                                                        stackTrace) {
                                                      print(
                                                          'Error loading image: $exception');
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
                                              const SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    text: widget
                                                        .viewNotesModel
                                                        ?.jsonRenoteArray
                                                        ?.renotedUserName,
                                                    fontColor:
                                                    const Color(0xff160323),
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Chillax",
                                                  ),
                                                  Text(
                                                    "@${widget.viewNotesModel?.jsonRenoteArray?.renotedUserHandle}",
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: const Color(0xffC6BEE3)),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Image.asset(
                                                'assets/images/Channel Tag.jpg'),
                                            const SizedBox(width: 4),
                                            CustomText(
                                              text: widget
                                                  .viewNotesModel
                                                  ?.jsonRenoteArray
                                                  ?.renotedChannelName,
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
                                      widget.viewNotesModel?.jsonRenoteArray
                                          ?.renotedBody !=
                                          null &&
                                          widget.viewNotesModel!.jsonRenoteArray!
                                              .renotedBody!
                                              .startsWith('https')
                                          ? InkWell(
                                        onTap: () {
                                          if (widget
                                              .viewNotesModel
                                              ?.jsonRenoteArray
                                              ?.renotedBody !=
                                              null) {
                                            launch(widget
                                                .viewNotesModel
                                                ?.jsonRenoteArray
                                                ?.renotedBody ??
                                                '');
                                          }
                                        },
                                        child: CustomText(
                                          text: widget.viewNotesModel
                                              ?.jsonRenoteArray !=
                                              null
                                              ? Uri.parse(widget
                                              .viewNotesModel!
                                              .jsonRenoteArray!
                                              .renotedBody!)
                                              .host
                                              : '',
                                          fontColor: const Color(0xff444444),
                                          fontSize: 16.sp,
                                          height: 1.5,
                                          fontFamily: 'Poppins',
                                        ),
                                      )
                                          : CustomText(
                                        text: widget
                                            .viewNotesModel
                                            ?.jsonRenoteArray
                                            ?.renotedBody ??
                                            "",
                                        fontColor: const Color(0xff444444),
                                        fontSize: 16.sp,
                                        height: 1.5,
                                        fontFamily: "Poppins",
                                      ),
                                      // CustomText(
                                      //   text: homeItem.renotedBody,
                                      //   fontColor:
                                      //       const Color(0xff444444),
                                      //   fontSize: 16.sp,
                                      //   fontWeight: FontWeight.w400,
                                      //   fontFamily: "Poppins",
                                      // ),
                                      SizedBox(
                                        height: 16.h,
                                      ),
                                      Visibility(
                                        visible: widget.viewNotesModel
                                            ?.jsonRenoteArray?.renotedImage !=
                                            null,
                                        child: Container(
                                          width: double.infinity,
                                          // height: 400,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(4.0),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(6.0),
                                              child: widget
                                                  .viewNotesModel
                                                  ?.jsonRenoteArray
                                                  ?.renotedImage !=
                                                  null
                                                  ? Image.network(
                                                String.fromCharCodes(
                                                    base64Decode(widget
                                                        .viewNotesModel
                                                        ?.jsonRenoteArray
                                                        ?.renotedImage ??
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
                                                      color: Color(0xffF7F7F7),
                                                    ),
                                                    child: SvgPicture.asset(
                                                        "assets/svg/Image.svg"),
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
                              height: 16.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                width: double.infinity,
                                // height: 50.h,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFF6F5FB),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: 30,
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          viewCont.noteId = viewCont.noteId;
                                          viewCont.createNoteLike();
                                        },
                                        icon: const Icon(
                                          Icons.favorite_border,
                                          color: Color(0xffCE1616),
                                        ),
                                        label: Text(
                                          widget.viewNotesModel?.totalNoteLikes
                                              .toString() ??
                                              "",
                                          style: const TextStyle(
                                            color: Color(0xff444444),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: Colors.transparent,
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
                                          replyId = widget.viewNotesModel?.noteId;
                                          channelId =
                                              widget.viewNotesModel?.channelId;
                                          userHandel =
                                              widget.viewNotesModel?.userHandle ?? "";
                                          Get.to(const ReplyingNotes());
                                        },
                                        icon: const Icon(
                                          Icons.comment_outlined,
                                          color: Color(0xff0FA958),
                                        ),
                                        label: Text(
                                          widget.viewNotesModel?.totalNoteReply
                                              .toString() ??
                                              "",
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
                                          backgroundColor: Colors.transparent,
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
                                          viewCont.renoteId =
                                              widget.viewNotesModel?.renoteId;
                                          channelId =
                                              widget.viewNotesModel?.channelId;
                                          Get.to(const Renote());
                                        },
                                        icon: SvgPicture.asset(
                                          "assets/svg/mdi_renote.svg",
                                        ),
                                        label: Text(
                                          widget.viewNotesModel?.totalNoteRepost
                                              .toString() ??
                                              "",
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
                                          backgroundColor: Colors.transparent,
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
                              height: 20.h,
                            ),
                            ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount:
                              widget.viewNotesModel?.jsonReplyArray?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                var viewItem =
                                widget.viewNotesModel?.jsonReplyArray?[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.0.h),
                                  child: GestureDetector(
                                    onTap: () {},
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
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 24),
                                              width: double.infinity,
                                              // height: 136,
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  left: BorderSide(
                                                    width: 6,
                                                    color: Color(0xFF0FA958),
                                                  ),
                                                ),
                                                // borderRadius: BorderRadius.circular(0),
                                              ),
                                              // padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                                              // clipBehavior: Clip.none,
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
                                                      Row(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            width: 36.h,
                                                            height: 36.w,
                                                            decoration: BoxDecoration(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(6.0),
                                                              child: viewItem
                                                                  ?.respondentProfileImage !=
                                                                  null
                                                                  ? Image.network(
                                                                String.fromCharCodes(
                                                                    base64Decode(
                                                                        viewItem?.respondentProfileImage ??
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
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 12.w,
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
                                                                text: viewItem
                                                                    ?.respondentName ??
                                                                    "",
                                                                fontColor:
                                                                const Color(
                                                                    0xff160323),
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                FontWeight.w600,
                                                                fontFamily: "Chillax",
                                                              ),
                                                              CustomText(
                                                                text:
                                                                "@${viewItem?.respondentHandle ?? ""}",
                                                                fontColor:
                                                                const Color(
                                                                    0xff3C0061),
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                FontWeight.w500,
                                                                fontFamily: "Chillax",
                                                              ),
                                                              SizedBox(
                                                                height: 20.h,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                        child: CustomText(
                                                          text: viewItem
                                                              ?.respondentNoteTimeAgo ??
                                                              "",
                                                          fontColor:
                                                          const Color(0xff767676),
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w300,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 15.h,
                                                  ),
                                                  Row(
                                                    children: [
                                                      CustomText(
                                                        text: "Replying to ",
                                                        fontColor:
                                                        const Color(0xff7676761),
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: "Chillax",
                                                      ),
                                                      CustomText(
                                                        text:
                                                        "@${viewItem?.replyingTo}",
                                                        fontColor:
                                                        const Color(0xff3C0061),
                                                        fontSize: 14.sp,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: "Chillax",
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Visibility(
                                                    visible: viewItem
                                                        ?.respondentNoteBody !=
                                                        null,
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: CustomText(
                                                        text: viewItem
                                                            ?.respondentNoteBody ??
                                                            "",
                                                        fontColor:
                                                        const Color(0xff444444),
                                                        fontSize: 16.sp,
                                                        height: 1.5,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 12.h,
                                                  ),
                                                  Visibility(
                                                    visible: viewItem
                                                        ?.respondentNoteImage !=
                                                        null,
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: null,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            6.0),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                        child: viewItem
                                                            ?.respondentNoteImage !=
                                                            null
                                                            ? Image.network(
                                                          String.fromCharCodes(
                                                              base64Decode(viewItem
                                                                  ?.respondentNoteImage ??
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
                                                            return Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(0.0),
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
                                          SizedBox(
                                            height: 16.h,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.h),
                                              width: double.infinity,
                                              // height: 50.h,
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                borderRadius:
                                                BorderRadius.circular(8),
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
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.favorite_border,
                                                        color: Color(0xffCE1616),
                                                      ),
                                                      label: Text(
                                                        viewItem!
                                                            .respondentTotalNoteLikes
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
                                                        primary: Colors.transparent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    height: 30,
                                                    child: ElevatedButton.icon(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.comment_outlined,
                                                        color: Color(0xff0FA958),
                                                      ),
                                                      label: Text(
                                                        viewItem
                                                            .respondentTotalNoteReply
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Color(0xff444444),
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        shadowColor:
                                                        Colors.transparent,
                                                        elevation: 0,
                                                        backgroundColor:
                                                        Colors.transparent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Container(
                                                    height: 30,
                                                    child: ElevatedButton.icon(
                                                      onPressed: () {},
                                                      icon: SvgPicture.asset(
                                                        "assets/svg/mdi_renote.svg",
                                                      ),
                                                      label: Text(
                                                        viewItem
                                                            .respondentTotalNoteRepost
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Color(0xff444444),
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.w400,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                      style: ElevatedButton.styleFrom(
                                                        shadowColor:
                                                        Colors.transparent,
                                                        elevation: 0,
                                                        backgroundColor:
                                                        Colors.transparent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  //  const RetweetButton(),
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
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 44.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            "assets/svg/Close.svg",
                          ),
                          const SizedBox(width: 10.0),
                          CustomText(
                            text: 'Close Note',
                            fontColor: const Color(0xff3C0061),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Chillax",
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 35.h,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Visibility(
              visible: _isRowVisible,
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0,right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        height: 44.h,
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: BoxDecoration(
                          color:const Color(0xffE3E3E3),
                          boxShadow:  [
                            BoxShadow(
                              color: const Color(0xFF3C0061).withOpacity(0.08),
                              offset: Offset(0, 2),
                              blurRadius: 6,
                            )
                          ],
                          borderRadius:
                          BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              "assets/svg/-symbols_arrow-back.svg",
                            ),
                            const SizedBox(width: 10.0),
                            CustomText(
                              text: 'Note',
                              fontColor: const Color(0xff160323),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _scrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child:Container(
                        height: 44.h,
                        width: 72.w,
                        padding: EdgeInsets.only(left: 8.0,right: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow:  [
                            BoxShadow(
                              color: const Color(0xFF3C0061).withOpacity(0.08),
                            offset: Offset(0, 2),
                              blurRadius: 6,
                            )
                          ],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                          children: [
                            SvgPicture.asset("assets/svg/arrow upword.svg"),
                            CustomText(
                              text: 'Top',
                              fontColor: const Color(0xff3C0061),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )

    );
  }

  void _showMenuViewNotes(BuildContext context) {
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
                            color: Color(0xFFD9D9D9),
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
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      decoration: BoxDecoration(
                        color: Color(0xfffE7E7E7),
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
                          Image.asset("assets/icons/Follow.png"),
                          SizedBox(
                            width: 12.w,
                          ),
                          CustomText(
                            text: 'Follow User',
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
                        color: Color(0xfffE7E7E7),
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
                        color: Color(0xfffE7E7E7),
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
                        color: Color(0xfffE7E7E7),
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
}
