import 'dart:convert';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sonata/Controllers/ProfileController/ProfileController.dart';
import 'package:sonata/Views/SideBar/SideBar.dart';
import 'dart:math' as math;
import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/PieChartController/PieChartController.dart';
import '../../Controllers/auth_controller.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../Widgets/custom_text.dart';
import '../Widgets/customeline/DashedBorderPainter.dart';

class RenoteUser extends StatefulWidget {
  const RenoteUser({Key? key}) : super(key: key);

  @override
  State<RenoteUser> createState() => _RenoteUserState();
}

class _RenoteUserState extends State<RenoteUser> {
  File? _reNoteImage;
  String selectedValue = 'value1';
  bool isExpanded = false;
  final FocusNode _focusNode = FocusNode();
  final reNote = Get.put(HomeController());
  final profileReonte = Get.put(ProfileController());
  var auth = Get.find<AuthController>();
  var piechart = Get.put(PieChartController());

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>${selectedUserPost?.userHandle}");
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: InkWell(
        onTap: () {
          _showPostNotes(context);
          reNote.renoteImage = _reNoteImage;
          profileReonte.createRenote();
        },
        child: Padding(
          padding: EdgeInsets.only(top: 30.0.h),
          child: Obx(() {
            return reNote.isTextFieldEmpty.value
                ? SvgPicture.asset("assets/svg/Create Renote.svg")
                : SvgPicture.asset("assets/svg/Create Not.svg");
          }),
        ),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: Container(
          height: 72.h,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          _showAddReplyinImage(context);
                        },
                        child: SvgPicture.asset("assets/svg/gallery.svg")),
                    SizedBox(
                      width: 25.w,
                    ),
                    SizedBox(
                      width: 40.w,
                    ),
                    Obx(() => Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xff3C0061),
                          width: 7,
                        ),
                      ),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(math.pi),
                        child: CircularProgressIndicator(
                          value: 1.0 -
                              piechart.progressValue
                                  .clamp(0.0, 1.0)
                                  .toDouble(),
                          backgroundColor: const Color(0xff3C0061),
                          strokeWidth: 10,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                    )),
                    SizedBox(
                      width: 20.w,
                    ),
                    Container(
                      height: 23.h,
                      width: 1, // width of the vertical line
                      decoration: const BoxDecoration(
                        border: Border(
                          left:
                          BorderSide(width: 1.0, color: Color(0xfffC6BEE3)),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Get.to(const CreateThread(),
                        //     arguments: createNotes.text);
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: const Color(0xff3C0061),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 20,
                          color: Color(0xfff3C0061),
                        ),
                      ),
                    ),
                    // Image.asset("assets/icons/Add.png"),
                    SizedBox(
                      width: 20.w,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: const SideBar(),
      backgroundColor: const Color(0xffE3E3E3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
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
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Color(0xfff160323),
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border:
                    Border.all(color: const Color(0xfff3C0061), width: 4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
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
                        SizedBox(
                          height: 12.h,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            controller: profileReonte.noteRenote,
                            focusNode: _focusNode,
                            cursorColor: Color(0xff3C0061),
                            onChanged: (text) {
                              if (text.length <= 440) {
                                reNote.checkTextFieldEmpty(text);
                                piechart.updateProgressValue(text);
                              }
                            },
                            maxLength: 440,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.newline,
                            decoration: InputDecoration(
                              hintText: 'Type something....',
                              hintStyle: TextStyle(
                                color: const Color(0xff767676),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                              border: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Visibility(
                          visible: _reNoteImage != null,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 400,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: _reNoteImage == null
                                    ? Image.asset("assets/icons/Add Photo.png")
                                    : ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.file(
                                    File(_reNoteImage!.path),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: 14,
                                  left: 14,
                                  child: Container(
                                    height: 27,
                                    width: 27,
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff444444),
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _reNoteImage = null;
                                          });
                                        },
                                        child: const Icon(Icons.clear_rounded,
                                            color: const Color(0xfffFFFFFF))),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Container(
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
                                        decoration: BoxDecoration(),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(6.0),
                                          child: selectedUserReNotePost
                                              ?.profileImage !=
                                              null
                                              ? Image.network(
                                            String.fromCharCodes(
                                                base64Decode(selectedUserReNotePost
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
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            text: selectedUserReNotePost?.userName,
                                            fontColor: const Color(0xff160323),
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Chillax",
                                          ),
                                          CustomText(
                                            text:
                                            '@${selectedUserReNotePost?.userHandle}',
                                            fontColor: const Color(0xff3C0061),
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
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
                                padding: const EdgeInsets.all(5.0),
                                constraints: BoxConstraints(
                                  maxHeight: 40.h,
                                  maxWidth: 250.w,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2, color: const Color(0xffC6BEE3)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/Channel Tag.svg',
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: CustomText(
                                        text: selectedUserReNotePost?.channelsName,
                                        fontColor: const Color(0xff444444),
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Chillax",
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              CustomText(
                                text: selectedUserReNotePost?.noteBody,
                                fontColor: const Color(0xff444444),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                              ),
                              Visibility(
                                visible: selectedUserReNotePost?.noteImage != null,
                                child: SizedBox(
                                  height: 16.h,
                                ),
                              ),
                              Visibility(
                                visible: selectedUserReNotePost?.noteImage != null,
                                child: Container(
                                  width: double.infinity,
                                  height: null,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: selectedUserReNotePost?.noteImage != null
                                        ? Image.network(
                                      String.fromCharCodes(base64Decode(
                                          selectedUserReNotePost?.noteImage ??
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
                              Visibility(
                                visible: selectedUserReNotePost?.threadStart ?? false,
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
                                                reNote.threadNoteId =
                                                    selectedUserReNotePost?.noteId;
                                                reNote.viewThread();
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
                                                        fontColor: const Color(
                                                            0xff3C0061),
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                        fontFamily: "Chillax",
                                                      ),
                                                      CustomText(
                                                        text:
                                                        " (+${selectedUserReNotePost?.threadLength.toString()})",
                                                        fontColor: const Color(
                                                            0xff868686),
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                        FontWeight.w300,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              SizedBox(
                height: 35.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCameraProfile(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (mounted && pickedFile != null) {
      setState(() {
        final imageFile = File(pickedFile.path);
        final imageName =
            '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}';
        reNote.uploadImage(imageFile, imageName);
        _reNoteImage = imageFile;
      });
    }
  }

  void _openGalleryProfile(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (mounted && pickedFile != null) {
      setState(() {
        final imageFile = File(pickedFile.path);
        final imageName =
            '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}';
        reNote.uploadImage(imageFile, imageName);
        _reNoteImage = imageFile;
      });
    }
  }

  Future<void> _showAddReplyinImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Color(0xff96CCD5)),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1.h,
                    color: const Color(0xff96CCD5),
                  ),
                  ListTile(
                    onTap: () {
                      _openGalleryProfile(context);
                      Navigator.pop(context);
                    },
                    title: const Text("Gallery"),
                    leading: const Icon(
                      Icons.account_box,
                      color: Color(0xff8C8FA5),
                    ),
                  ),
                  Divider(
                    height: 1.h,
                    color: const Color(0xff96CCD5),
                  ),
                  ListTile(
                    onTap: () {
                      _openCameraProfile(context);
                      Navigator.pop(context);
                    },
                    title: const Text("Camera"),
                    leading: const Icon(
                      Icons.camera,
                      color: Color(0xff8C8FA5),
                    ),
                  ),
                  // Divider(
                  //   height: 1.h,
                  //   color: const Color(0xff96CCD5),
                  // ),
                  // ListTile(
                  //   onTap: () {
                  //     pickedFile();
                  //     Navigator.pop(context);
                  //   },
                  //   title: const Text("File"),
                  //   leading: const Icon(
                  //     Icons.file_copy,
                  //     color: Color(0xff8C8FA5),
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        });
  }

  void _showPostNotes(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/images/Post Note.png"),
                  CustomText(
                    text: 'Your note has been posted',
                    fontColor: const Color(0xff5D4180),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ));
      },
    );
  }
}
