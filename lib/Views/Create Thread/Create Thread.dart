import 'dart:convert';
import 'dart:io';

import 'package:dotted_line/dotted_line.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';

import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/PieChartController/PieChartController.dart';
import '../../Controllers/auth_controller.dart';
import '../../Models/ThreadModel.dart';
import '../Create Notes DropDown/Create Notes Dropdown.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../SideBar/SideBar.dart';
import 'dart:math' as math;

import '../Widgets/customeline/DashedBorderPainter.dart';

class CreateThread extends StatefulWidget {
  const CreateThread({Key? key}) : super(key: key);

  @override
  State<CreateThread> createState() => _CreateThreadState();
}

class _CreateThreadState extends State<CreateThread> {
  late final String selectedValue;
  int currentTextFieldIndex = 0;
  bool isExpanded = false;
  final FocusNode _focusNode = FocusNode();
  bool showTextField = false;
  List<Widget> containers = [];
  List<TextEditingController> threadList = [];
  int listLength = 1;
  List<File?> _imageFiles = List.generate(10, (_) => null);

  final String createNotes = Get.arguments;
  var auth = Get.find<AuthController>();

  var crThread = Get.put(HomeController());

  List<FocusNode> focusNodes = [];
  final PieChartController controller = Get.put(PieChartController());

  bool shouldShowDropdown(int index) {
    return index == 0;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomeController(),
        builder: (homeCont) {
          //   if (crThread.getChannel.value) {
          //     return SvgPicture.asset(
          //       'assets/svg/sonata-loader-spin-1.svg',
          //     );
          //   } else {
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: IgnorePointer(
              ignoring:
                  crThread.isTextFieldEmptyThread.value && _imageFiles == null,
              child: InkWell(
                onTap: () async {
                  try {
                    crThread.createThreadImage = _imageFiles;
                    crThread.threads.clear();
                    bool isEmpty = true;
                    for (int i = 0; i < threadList.length; i++) {
                      if (threadList[i].text.trim().isNotEmpty) {
                        isEmpty = false;
                        crThread.threads.add(threadList[i].text.trim());
                      }
                    }
                    print("Threads: ${crThread.threads}");
                    if (!isEmpty) {
                      _showThreadPostBeing(context);
                      await crThread.createThread(context);
                      Navigator.pop(context);
                      _showThreadPost(context);
                      Navigator.pop(context);
                       crThread.homeUser();
                    } else {
                      // Add your logic for the else condition here
                    }
                  } catch (e) {
                    // Handle the exception here
                    print("An error occurred: $e");
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 30.0.h),
                  child: Obx(() {
                    return crThread.isTextFieldEmptyThread.value &&
                            _imageFiles == null
                        ? SvgPicture.asset("assets/svg/Create Renote.svg")
                        : SvgPicture.asset("assets/svg/Create Not.svg");
                  }),
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Stack(
                children: [
                  Container(
                    height: 72.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    _showChoiceDialog(context);
                                  },
                                  child: SvgPicture.asset(
                                      "assets/svg/gallery.svg")),
                              SizedBox(
                                width: 25.w,
                              ),
                            ],
                          ),
                          Row(
                            children: [
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
                                            controller.progressValueThread
                                                .clamp(0.0, 1.0)
                                                .toDouble(),
                                        backgroundColor:
                                            const Color(0xff3C0061),
                                        strokeWidth: 10,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
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
                                    left: BorderSide(
                                        width: 1.0, color: Color(0xfffC6BEE3)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (listLength < 10) {
                                    setState(() {
                                      listLength++;
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(right: 60.0.w),
                                  child: listLength < 10
                                      ? Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                              color: const Color(0xff3C0061),
                                              width: 2,
                                            ),
                                          ),
                                          child: listLength < 10
                                              ? const Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: Color(0xfff3C0061),
                                                )
                                              : Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: Color(0xff3C0061)
                                                      .withOpacity(0.5),
                                                ),
                                        )
                                      : Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            border: Border.all(
                                              color: Color(0xff3C0061)
                                                  .withOpacity(0.5),
                                              width: 2,
                                            ),
                                          ),
                                          child: listLength < 10
                                              ? const Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: Color(0xfff3C0061),
                                                )
                                              : Icon(
                                                  Icons.add,
                                                  size: 20,
                                                  color: Color(0xff3C0061)
                                                      .withOpacity(0.5),
                                                ),
                                        ),
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                  children: [
                    InkWell(
                      onTap: () {
                        Get.to(const NavigationBarScreen());
                      },
                      child: SvgPicture.asset(
                        "assets/svg/Sonata_Logo_Main_RGB.svg",
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(const NavigationBarScreen());
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
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListView.builder(
                              physics: const ScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: listLength,
                              itemBuilder: (context, index) {
                                threadList.add(TextEditingController());
                                focusNodes.add(FocusNode());
                                return Column(
                                  children: [
                                    Visibility(
                                      visible: index == 0 ? false : true,
                                      child: Center(
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
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: const Color(0xfff3C0061),
                                              width: 4),
                                        ),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
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
                                                    children: [
                                                      Container(
                                                        width: 64,
                                                        height: 64,
                                                        decoration:
                                                            const BoxDecoration(),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: auth.user
                                                                      ?.profileImage !=
                                                                  null
                                                              ? Image.network(
                                                                  String.fromCharCodes(
                                                                      base64Decode(auth
                                                                              .user
                                                                              ?.profileImage ??
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
                                                      if (shouldShowDropdown(
                                                          index))
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 30.0),
                                                          child: SizedBox(
                                                            height: 40.h,
                                                            width: 150.w,
                                                            child:
                                                                const CreateNotesDropdown(),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                    child: TextFormField(
                                                      autofocus: true,
                                                      cursorColor: const Color(
                                                          0xff3C0061),
                                                      controller:
                                                          threadList[index],
                                                      focusNode:
                                                          focusNodes[index],
                                                      onChanged: (text) {
                                                        if (text.length <=
                                                            440) {
                                                          controller
                                                              .checkTextFieldEmpty(
                                                                  text);
                                                          controller
                                                              .updateProgressValueThread(
                                                                  text);
                                                        }
                                                      },
                                                      maxLength: 440,
                                                      maxLines: null,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      textInputAction:
                                                          TextInputAction
                                                              .newline,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            'Add another note',
                                                        hintStyle: TextStyle(
                                                          color: const Color(
                                                              0xff767676),
                                                          fontSize: 18.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: 'Poppins',
                                                        ),
                                                        border:
                                                            InputBorder.none,
                                                        counterText: '',
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 16.h,
                                                  ),
                                                  Visibility(
                                                    visible:
                                                        _imageFiles[index] !=
                                                            null,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          height: 400,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4.0),
                                                            image: _imageFiles[
                                                                        index] !=
                                                                    null
                                                                ? DecorationImage(
                                                                    image: FileImage(
                                                                        _imageFiles[
                                                                            index]!),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  )
                                                                : null,
                                                          ),
                                                        ),
                                                        Positioned(
                                                            top: 14,
                                                            left: 14,
                                                            child: Container(
                                                              height: 27,
                                                              width: 27,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: const Color(
                                                                    0xfff444444),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4.0),
                                                              ),
                                                              child: InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _imageFiles[
                                                                              index] =
                                                                          null;
                                                                    });
                                                                  },
                                                                  child: const Icon(
                                                                      Icons
                                                                          .clear_rounded,
                                                                      color: const Color(
                                                                          0xfffFFFFFF))),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              top: 5,
                                              right: 10,
                                              child: IconButton(
                                                icon: const Icon(Icons.close),
                                                onPressed: () {
                                                  setState(() {
                                                    if (threadList.isNotEmpty &&
                                                        index <
                                                            threadList.length) {
                                                      threadList
                                                          .removeAt(index);
                                                      listLength--;
                                                      if (listLength == 0) {
                                                        Get.back();
                                                      }
                                                    }
                                                    //showTextField = true;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      final index = _imageFiles.indexOf(null);
      final imageFile = File(pickedFile.path);
      final imageName =
          '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}';
      await crThread.uploadImage(imageFile, imageName);
      if (index != -1) {
        setState(() {
          _imageFiles[index] = imageFile;
        });
        if (index < threadList.length) {
          crThread.createThreadImage[index] = imageFile;
        }
      }
    }
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      final index = _imageFiles.indexOf(null);
      final imageFile = File(pickedFile.path);
      final imageName =
          '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}';
      crThread.uploadImage(imageFile, imageName);
      if (index != -1) {
        setState(() {
          _imageFiles[index] = imageFile;
        });
      }
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) {
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
                      _openGallery(context);
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
                      _openCamera(context);
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

  void _showThreadPostBeing(BuildContext context) {
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
                  SvgPicture.asset("assets/svg/Being Post.svg"),
                  CustomText(
                    text: 'Your thread is being posted',
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

  void _showThreadPost(BuildContext context) {
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
                  SvgPicture.asset("assets/svg/Post Thread.svg"),
                  CustomText(
                    text: 'Your thread has been posted',
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
