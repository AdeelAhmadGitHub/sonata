import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sonata/Views/SideBar/SideBar.dart';
import 'package:sonata/Views/Widgets/CommentIcon.dart';
import 'package:sonata/Views/Widgets/FavoriteIcon.dart';
import 'package:sonata/Views/Widgets/Retweet.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/SavedNoteController/SaveNoteController.dart';
import '../../Controllers/auth_controller.dart';
import '../Create Note (Replying)/Replying Notes.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../Renote/Renote.dart';
import '../Widgets/customeline/DashedBorderPainter.dart';
import 'SaveRenote.dart';

class SaveNotes extends StatefulWidget {
  const SaveNotes({Key? key}) : super(key: key);

  @override
  State<SaveNotes> createState() => _SaveNotesState();
}

class _SaveNotesState extends State<SaveNotes> {
  var auth = Get.find<AuthController>();
  var saveCont = Get.put(SavedNotesController());

  @override
  initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      saveCont.savedNotes();
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    saveCont.isRefresh = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SavedNotesController(),
        builder: (saveCont) {
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
                saveCont.isRefresh = false;
                await saveCont.savedNotes();
              },
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset("assets/icons/Save Note (2).png"),
                          SizedBox(
                            width: 10.w,
                          ),
                          CustomText(
                            text: 'Saved Notes',
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
                      saveCont.save.isEmpty
                          ? Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 40,
                                  ),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: const Color(0xffC6BEE3),
                                      ),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/svg/Save Note.svg",
                                      ),
                                      CustomText(
                                        text: 'No Saved Notes',
                                        fontColor: const Color(0xff666666),
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins",
                                      ),
                                      CustomText(
                                        text:
                                            'Any notes you save will show up here',
                                        fontColor: const Color(0xff767676),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "Poppins",
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.h),
                              ],
                            )
                          : ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: saveCont.save.length,
                              itemBuilder: (BuildContext context, int index) {
                                var saveItem = saveCont.save[index];
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                color: Color.fromRGBO(
                                                    60, 0, 97, 0.06),
                                                offset: Offset(0, 2),
                                                blurRadius: 6,
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  saveCont.otherHandle =
                                                      saveItem.userHandle;
                                                  otherUserHandel =
                                                      saveItem.userHandle ?? "";
                                                  auth.otherUserHandel =
                                                      saveItem.userHandle ?? "";
                                                  if (saveItem.userHandle ==
                                                      auth.user?.userHandle) {
                                                    auth.userProfile();
                                                  } else {
                                                    saveCont.otherHandle =
                                                        saveItem.userHandle;
                                                    otherUserHandel =
                                                        saveItem.userHandle ??
                                                            "";
                                                    auth.otherUserserProfile();
                                                  }
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
                                                                .circular(5.0),
                                                        child: saveItem
                                                                    .profileImage !=
                                                                null
                                                            ? Image.network(
                                                                String.fromCharCodes(
                                                                    base64Decode(
                                                                        saveItem.profileImage ??
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
                                                          constraints:
                                                              const BoxConstraints(
                                                            minWidth: 150,
                                                            maxWidth: 200,
                                                          ),
                                                          child: LayoutBuilder(
                                                            builder: (context,
                                                                constraints) {
                                                              return CustomText(
                                                                text: saveItem
                                                                        .userName ??
                                                                    "",
                                                                fontColor:
                                                                    const Color(
                                                                        0xff160323),
                                                                fontSize: 16.sp,
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
                                                              return CustomText(
                                                                text:
                                                                    "@${saveItem.userHandle ?? ""}",
                                                                fontColor:
                                                                    const Color(
                                                                        0xff3C0061),
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300,
                                                                fontFamily:
                                                                    "Poppins",
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
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CustomText(
                                                      text:
                                                          saveItem.noteTimeAgo,
                                                      fontColor: const Color(
                                                          0xff767676),
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontFamily: "Poppins",
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        saveCont.noteId =
                                                            saveItem.noteId;
                                                        saveCont.otherHandle =
                                                            saveItem.userHandle;
                                                        if (saveItem
                                                                .userHandle ==
                                                            auth.user
                                                                ?.userHandle) {
                                                          _showBottomMenuOfUserSave(
                                                            context,
                                                            saveItem.noteSavedStatus ??
                                                                0,
                                                            saveItem.threadStart ??
                                                                false,
                                                            index,
                                                          );
                                                        } else {
                                                          _showBottomMenuSave(
                                                              context,
                                                              saveItem.noteSavedStatus ??
                                                                  0,
                                                              saveItem.threadStart ??
                                                                  false,
                                                              saveItem.userFollowStatus ??
                                                                  0,
                                                              index);
                                                        }
                                                      },
                                                      child: Row(
                                                        children: const [
                                                          Icon(
                                                            Icons.more_vert,
                                                            color: Color(
                                                                0xfff444444),
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

                                        // Visibility(
                                        //   visible:  homeItem.noteSavedStatus != 0,
                                        //   child: SizedBox(
                                        //     height: 16.h,
                                        //   ),
                                        // ),
                                        // Visibility(
                                        //   visible: homeItem.renotedId == null,
                                        //   child: SizedBox(
                                        //     height: 16.h,
                                        //   ),
                                        // ),
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
                                                    saveItem.renoteId == null,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  constraints: BoxConstraints(
                                                    maxHeight: 32.h,
                                                    maxWidth: 250.w,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 2,
                                                        color: const Color(
                                                            0xffC6BEE3)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/svg/Channel Tag.svg',
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Flexible(
                                                        child: CustomText(
                                                          text: saveItem
                                                                  .channelsName ??
                                                              "",
                                                          fontColor:
                                                              const Color(
                                                                  0xff444444),
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Chillax",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                  visible: saveItem
                                                          .noteSavedStatus !=
                                                      0,
                                                  child: SvgPicture.asset(
                                                      "assets/svg/Save Notees.svg")),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: saveItem.noteBody != null &&
                                              saveItem.noteBody!.isNotEmpty,
                                          child: SizedBox(
                                            height: 16.h,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            saveCont.noteId = saveItem.noteId;
                                            saveCont.viewNotes();
                                          },
                                          child: Visibility(
                                            visible: saveItem.noteBody !=
                                                    null &&
                                                saveItem.noteBody!.isNotEmpty,
                                            child: Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.only(
                                                  left: 16, right: 16),
                                              child: saveItem.noteBody !=
                                                          null &&
                                                      saveItem.noteBody!
                                                          .startsWith('http')
                                                  ? InkWell(
                                                      onTap: () {
                                                        if (saveItem.noteBody !=
                                                            null) {
                                                          launch(saveItem
                                                                  .noteBody ??
                                                              '');
                                                        }
                                                      },
                                                      child: CustomText(
                                                        text: saveItem != null
                                                            ? Uri.parse(saveItem
                                                                    .noteBody!)
                                                                .host
                                                            : '',
                                                        fontColor: const Color(
                                                            0xff444444),
                                                        fontSize: 16.sp,
                                                        height: 1.5,
                                                        fontFamily: 'Poppins',
                                                      ),
                                                    )
                                                  : CustomText(
                                                      text: saveItem.noteBody ??
                                                          "",
                                                      fontColor: const Color(
                                                          0xff444444),
                                                      fontSize: 16.sp,
                                                      height: 1.5,
                                                      fontFamily: "Poppins",
                                                    ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: saveItem.noteImage != null,
                                          child: SizedBox(
                                            height: 8.h,
                                          ),
                                        ),
                                        Visibility(
                                          visible: saveItem.noteImage != null,
                                          child: GestureDetector(
                                            onTap: () {
                                              saveCont.noteId = saveItem.noteId;
                                              saveCont.viewNotes();
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
                                                    BorderRadius.circular(6.0),
                                                child: saveItem.noteImage !=
                                                        null
                                                    ? Image.network(
                                                        String.fromCharCodes(
                                                            base64Decode(saveItem
                                                                    .noteImage ??
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
                                          visible:
                                              saveItem.threadStart ?? false,
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
                                                    radius:
                                                        const Radius.circular(
                                                            20),
                                                    color:
                                                        const Color(0xff3C0061),
                                                    dashPattern: [6, 3],
                                                    strokeWidth: 1,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  30)),
                                                      child: InkWell(
                                                        onTap: () {
                                                          saveCont.threadNoteId =
                                                              saveItem.noteId;
                                                          saveCont.viewThread();
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
                                                                      " (+${saveItem.threadLength.toString()})",
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
                                        Visibility(
                                          visible: saveItem.renoteId != null,
                                          child: SizedBox(
                                            height: 16.h,
                                          ),
                                        ),
                                        Visibility(
                                          visible: saveItem.renoteId != null,
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
                                                                      .circular(
                                                                          6.0),
                                                              child: saveItem
                                                                          .renotedProfileImage !=
                                                                      null
                                                                  ? Image
                                                                      .network(
                                                                      String.fromCharCodes(base64Decode(
                                                                          saveItem.renotedProfileImage ??
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
                                                              width: 10),
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
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return CustomText(
                                                                      text: saveItem
                                                                          .renoteUserName,
                                                                      fontColor:
                                                                          const Color(
                                                                              0xff160323),
                                                                      fontSize:
                                                                          14.sp,
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
                                                                child:
                                                                    LayoutBuilder(
                                                                  builder: (context,
                                                                      constraints) {
                                                                    return Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.4, // adjust the width as needed
                                                                      child:
                                                                          LayoutBuilder(
                                                                        builder:
                                                                            (context,
                                                                                constraints) {
                                                                          return Text(
                                                                            "@${saveItem.renoteUserHandle}",
                                                                            style:
                                                                                const TextStyle(
                                                                              color: Color(0xff3C0061),
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w400,
                                                                              fontFamily: 'Chillax',
                                                                              overflow: TextOverflow.ellipsis,
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 8.h,
                                                              ),
                                                              Visibility(
                                                                visible: saveItem
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
                                                                              onTap: () {
                                                                                saveCont.threadNoteId = saveItem.noteId;
                                                                                saveCont.viewThread();
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
                                                                                        text: " (+${saveItem.threadLength.toString()})",
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
                                                                height: 8.h,
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
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 4,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2,
                                                          color: const Color(
                                                              0xffC6BEE3)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Image.asset(
                                                            'assets/images/Channel Tag.jpg'),
                                                        const SizedBox(
                                                            width: 4),
                                                        Flexible(
                                                          child: CustomText(
                                                            text: saveItem
                                                                    .renoteChannelName ??
                                                                "",
                                                            fontColor:
                                                                const Color(
                                                                    0xff444444),
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                "Chillax",
                                                            overflow:
                                                                TextOverflow
                                                                    .fade,
                                                            maxLines: 1,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8.h,
                                                  ),
                                                  saveItem.renoteBody != null &&
                                                          saveItem.renoteBody!
                                                              .startsWith(
                                                                  'https')
                                                      ? InkWell(
                                                          onTap: () {
                                                            if (saveItem
                                                                    .renoteBody !=
                                                                null) {
                                                              launch(saveItem
                                                                      .renoteBody ??
                                                                  '');
                                                            }
                                                          },
                                                          child: CustomText(
                                                            text: saveItem !=
                                                                    null
                                                                ? Uri.parse(saveItem
                                                                        .renoteBody!)
                                                                    .host
                                                                : '',
                                                            fontColor:
                                                                const Color(
                                                                    0xff444444),
                                                            fontSize: 16.sp,
                                                            height: 1.5,
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        )
                                                      : CustomText(
                                                          text: saveItem
                                                                  .renoteBody ??
                                                              "",
                                                          fontColor:
                                                              const Color(
                                                                  0xff444444),
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
                                                    visible:
                                                        saveItem.renotedImage !=
                                                            null,
                                                    child: Container(
                                                      width: double.infinity,
                                                      // height: 400,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                      ),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      6.0),
                                                          child:
                                                              saveItem.renotedImage !=
                                                                      null
                                                                  ? Image
                                                                      .network(
                                                                      String.fromCharCodes(base64Decode(
                                                                          saveItem.renotedImage ??
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
                                                                        return Container(
                                                                          height:
                                                                              178,
                                                                          decoration:
                                                                              const BoxDecoration(
                                                                            color:
                                                                                Color(0xffF7F7F7),
                                                                          ),
                                                                          child:
                                                                              SvgPicture.asset("assets/svg/Image.svg"),
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            width: double.infinity,
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
                                                    onPressed: () {
                                                      saveCont.noteId =
                                                          saveItem.noteId;
                                                      saveCont.createNoteLike();
                                                      saveCont.savedNotes();
                                                    },
                                                    icon: const Icon(
                                                      Icons.favorite_border,
                                                      color: Color(0xffCE1616),
                                                    ),
                                                    label: Text(
                                                      saveItem.totalNoteLikes
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xff444444),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      primary: saveItem
                                                                  .likeStatus ==
                                                              1
                                                          ? const Color(
                                                              0xffFFF0F0)
                                                          : Colors.transparent,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Container(
                                                  height: 30,
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      replyId = saveItem.noteId;
                                                      channelId =
                                                          saveItem.channelsId;
                                                      userHandel =
                                                          saveItem.userHandle ??
                                                              "";
                                                      Get.to(
                                                          const ReplyingNotes());
                                                    },
                                                    icon: const Icon(
                                                      Icons.comment_outlined,
                                                      color: Color(0xff0FA958),
                                                    ),
                                                    label: Text(
                                                      saveItem.totalNoteReply
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xff444444),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shadowColor:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                      backgroundColor: saveItem
                                                                  .noteRepliedStatus ==
                                                              1
                                                          ? const Color(
                                                              0xffE2F5EB)
                                                          : Colors.transparent,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Container(
                                                  height: 30,
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {
                                                      saveCont.renoteId =
                                                          saveItem.noteId;
                                                      channelSaveId =
                                                          saveItem.channelsId;
                                                      userHandel =
                                                          saveItem.userHandle ??
                                                              "";
                                                      selectedSavePost =
                                                          saveItem;
                                                      print(
                                                          ">>>>>>>>>>>>>>>>>>>>>>>>>>>${selectedSavePost?.userHandle}");
                                                      Get.to(
                                                          const SaveRenote());
                                                    },
                                                    icon: SvgPicture.asset(
                                                      "assets/svg/mdi_renote.svg",
                                                    ),
                                                    label: Text(
                                                      saveItem.totalNoteRepost
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xff444444),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      shadowColor:
                                                          Colors.transparent,
                                                      elevation: 0,
                                                      backgroundColor: saveItem
                                                                  .noteRenotedStatus ==
                                                              1
                                                          ? const Color(
                                                              0xffF6EFFF)
                                                          : Colors.transparent,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // const RetweetButton(),
                                                InkWell(
                                                  onTap: () {
                                                    saveCont.noteId =
                                                        saveItem.noteId;
                                                    _showLink(
                                                      context,
                                                      saveItem.noteId ?? 0,
                                                    );
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
                      SizedBox(
                        height: 35.h,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showBottomMenuSave(
    BuildContext context,
    int saveNoteStatus,
    bool threadStart,
    int index,
    int userFollowStatus,
  ) {
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
                          bool isHitApi = await saveCont.saveNote() ?? false;
                          if (isHitApi) {
                            saveCont.save[index].noteSavedStatus == 0
                                ? saveCont.save[index].noteSavedStatus = 1
                                : saveCont.save[index].noteSavedStatus = 0;
                            Navigator.pop(context);
                            saveCont.savedNotes();
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: CustomText(
                              text: saveCont.save[index].noteSavedStatus == 0
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
                          saveCont.createUserFollow();
                          Navigator.pop(context);
                          saveCont.savedNotes();
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
                          saveCont.userInteractionsMute();
                          Navigator.pop(context);
                          saveCont.savedNotes();
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
                          saveCont.userInteractionsBlocked();
                          Navigator.pop(context);
                          saveCont.savedNotes();
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

  void _showBottomMenuOfUserSave(
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
                          bool isHitApi = await saveCont.saveNote() ?? false;
                          if (isHitApi) {
                            saveCont.save[index].noteSavedStatus == 0
                                ? saveCont.save[index].noteSavedStatus = 1
                                : saveCont.save[index].noteSavedStatus = 0;
                            Navigator.pop(context);
                            saveCont.savedNotes();
                          } else {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: CustomText(
                              text: saveCont.save[index].noteSavedStatus == 0
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
                              onPressed: () async {
                                await saveCont.deleteNote();
                                Navigator.pop(context);
                                saveCont.deleteNote();
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
    var userNotes = saveCont.viewNotes();
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
}
