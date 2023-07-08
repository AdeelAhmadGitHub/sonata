import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sonata/Models/View%20Thread%20Model/ViewThreadModel.dart';
import 'package:sonata/Views/Widgets/customeline/DashedBorderPainter.dart';

import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/auth_controller.dart';
import '../SideBar/SideBar.dart';
import '../Widgets/custom_text.dart';

class ThreadView extends StatefulWidget {
  final ViewThreadModel? viewCont;

  const ThreadView({Key? key, this.viewCont}) : super(key: key);

  @override
  State<ThreadView> createState() => _ThreadViewState();
}

class _ThreadViewState extends State<ThreadView> {
  final ScrollController _scrollController = ScrollController();

  //final List<ExModel> list = ExModel.dummyData;

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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              SvgPicture.asset(
                "assets/svg/Sonata_Logo_Main_RGB.svg",
              ),
              Container(
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
                          errorBuilder: (BuildContext context, Object exception,
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
            ],
          ),
        ),
        elevation: 0.0,
        backgroundColor: const Color(0xff3C0061),
        toolbarHeight: 78.h,
      ),
      body: GetBuilder(
        init: HomeController(),
        builder: (viewContn) {
          print("viewCont.viewThreadModel?.value.userHandle");
          print(widget.viewCont?.noteTimeAgo);
          return Stack(
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
                          const SizedBox(
                            width: 18,
                          ),
                          CustomText(
                            text: 'Thread',
                            fontColor: const Color(0xff160323),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Chillax",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                                        child: widget.viewCont?.profileImage != null
                                            ? Image.network(
                                                String.fromCharCodes(
                                                  base64Decode(widget
                                                          .viewCont?.profileImage ??
                                                      ""),
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
                                          text: widget.viewCont?.userName ?? "",
                                          fontColor: const Color(0xff160323),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Chillax",
                                        ),
                                        CustomText(
                                          text:
                                              "@${widget.viewCont?.userHandle ?? ""}",
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
                                        text: widget.viewCont?.noteTimeAgo,
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
                                          _showMenuThred(context);
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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.0.w),
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
                                    text: widget.viewCont?.channelsName,
                                    fontColor: const Color(0xff444444),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Chillax",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount:
                                  widget.viewCont?.jsonThreadArray?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                var viewThreadItem =
                                    widget.viewCont?.jsonThreadArray![index];
                                final isFirstItem = index == 0;
                                final isLastItem = index == widget.viewCont!.jsonThreadArray!.length - 1;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        viewContn.noteId = viewThreadItem?.noteId;
                                        viewContn.viewNotes();
                                      },
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              width: 2,
                                              color: isFirstItem
                                                  ? Color(0xff3C0061)
                                                  : const Color(0xfffF3EEF9),
                                            )),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CustomText(
                                              text: viewThreadItem?.noteBody,
                                              fontColor: Color(0xff444444),
                                              fontSize: 16.sp,
                                              height: 1.5,
                                              fontFamily: "Poppins",
                                            ),
                                            SizedBox(
                                              height: 16.h,
                                            ),
                                            Visibility(
                                              visible:
                                                  viewThreadItem?.noteImage != null,
                                              child: GestureDetector(
                                                onTap: () {
                                                  viewContn.noteId =
                                                      viewThreadItem?.noteId;
                                                  viewContn.viewNotes();
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: null,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(6.0),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(6.0),
                                                    child: viewThreadItem
                                                                ?.noteImage !=
                                                            null
                                                        ? Image.network(
                                                            String.fromCharCodes(
                                                                base64Decode(
                                                                    viewThreadItem
                                                                            ?.noteImage ??
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
                                              height: 16.h,
                                            ),
                                            Container(
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
                                                        viewContn.noteId =
                                                            viewThreadItem?.noteId;
                                                        viewContn.viewNotes();
                                                      },
                                                      icon: const Icon(
                                                        Icons.favorite_border,
                                                        color: Color(0xffCE1616),
                                                      ),
                                                      label: Text(
                                                        viewThreadItem
                                                                ?.totalNoteLikes
                                                                .toString() ??
                                                            "",
                                                        style: const TextStyle(
                                                          color: Color(0xff444444),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                        elevation: 0,
                                                        primary: viewThreadItem
                                                                    ?.likeStatus ==
                                                                1
                                                            ? const Color(
                                                                0xffFFF0F0)
                                                            : Colors.transparent,
                                                        shape:
                                                            RoundedRectangleBorder(
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
                                                      onPressed: () {
                                                        viewContn.noteId =
                                                            viewThreadItem?.noteId;
                                                        viewContn.viewNotes();
                                                      },
                                                      icon: const Icon(
                                                        Icons.comment_outlined,
                                                        color: Color(0xff0FA958),
                                                      ),
                                                      label: Text(
                                                        viewThreadItem
                                                                ?.totalNoteReply
                                                                .toString() ??
                                                            "",
                                                        style: const TextStyle(
                                                          color: Color(0xff444444),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                        shadowColor:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape:
                                                            RoundedRectangleBorder(
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
                                                      onPressed: () {
                                                        viewContn.noteId =
                                                            viewThreadItem?.noteId;
                                                        viewContn.viewNotes();
                                                      },
                                                      icon: SvgPicture.asset(
                                                        "assets/svg/mdi_renote.svg",
                                                      ),
                                                      label: Text(
                                                        viewThreadItem
                                                                ?.totalNoteRepost
                                                                .toString() ??
                                                            "",
                                                        style: const TextStyle(
                                                          color: Color(0xff444444),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: "Poppins",
                                                        ),
                                                      ),
                                                      style:
                                                          ElevatedButton.styleFrom(
                                                        shadowColor:
                                                            Colors.transparent,
                                                        elevation: 0,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  4),
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
                                            const SizedBox(
                                              height: 9,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SvgPicture.asset(
                                                  "assets/svg/Interactions.svg",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (!isLastItem) // Show the dashed border only if it's not the last item
                                      Center(
                                        child: Container(
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
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          )
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Container(
                    //         padding: EdgeInsets.all(5),
                    //         height: 44.h,
                    //         child: ElevatedButton(
                    //           onPressed: () {
                    //             Get.back();
                    //           },
                    //           style: ElevatedButton.styleFrom(
                    //             primary: Colors.white,
                    //             elevation: 0,
                    //             onPrimary: const Color(0xFF3C0061),
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(8),
                    //               side: const BorderSide(
                    //                 width: 1.5,
                    //                 color: Color(0xFF3C0061),
                    //               ),
                    //             ),
                    //           ),
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               const Icon(
                    //                 Icons.close,
                    //                 color: Color(0xFF3C0061),
                    //                 size: 20,
                    //               ),
                    //               const SizedBox(width: 10.0),
                    //               CustomText(
                    //                 text: 'Close Thread',
                    //                 fontColor: const Color(0xff3C0061),
                    //                 fontSize: 14.sp,
                    //                 fontWeight: FontWeight.w600,
                    //                 fontFamily: "Chillax",
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       Container(
                    //         padding: EdgeInsets.all(5),
                    //         height: 44.h,
                    //         child: ElevatedButton(
                    //           onPressed: () {
                    //             _scrollController.animateTo(
                    //               0,
                    //               duration: Duration(milliseconds: 500),
                    //               curve: Curves.easeInOut,
                    //             );
                    //           },
                    //           style: ElevatedButton.styleFrom(
                    //             primary: Colors.white,
                    //             elevation: 0,
                    //             onPrimary: const Color(0xFF3C0061),
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(8),
                    //               side: const BorderSide(
                    //                 width: 1.5,
                    //                 color: Color(0xFF3C0061),
                    //               ),
                    //             ),
                    //           ),
                    //           child: Row(
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: [
                    //               const Icon(
                    //                 Icons.arrow_upward,
                    //                 color: Color(0xFF3C0061),
                    //                 size: 20,
                    //               ),
                    //               const SizedBox(width: 10.0),
                    //               CustomText(
                    //                 text: 'Go to top Note',
                    //                 fontColor: const Color(0xff3C0061),
                    //                 fontSize: 14.sp,
                    //                 fontWeight: FontWeight.w600,
                    //                 fontFamily: "Chillax",
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 35.h,
                    ),
                  ],
                ),
              ),),
                Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Visibility(
                    visible: _isRowVisible,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child:Row(
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
                                    text: 'Thread',
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
            ]
          );
        },
      ),
    );
  }

  void _showMenuThred(BuildContext context) {
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
