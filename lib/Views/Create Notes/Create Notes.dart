import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';
import 'dart:math' as math;
import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/PieChartController/PieChartController.dart';
import '../../Controllers/auth_controller.dart';
import '../../Models/AddImage/AddImage.dart';
import '../Create Notes DropDown/Create Notes Dropdown.dart';
import '../Create Thread/Create Thread.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../SideBar/SideBar.dart';
import 'dart:convert';

class CreateNotes extends StatefulWidget {
  const CreateNotes({Key? key}) : super(key: key);

  @override
  State<CreateNotes> createState() => _CreateNotesState();
}

class _CreateNotesState extends State<CreateNotes> {
  File? _createNoteImage;
  bool isTextFieldEmpty = true;
  bool isExpanded = false;

  //File? imageFile;
  String? imageName;
  var timestamp;
  List<TextEditingController> threadTexts = [];
  var crNotes = Get.put(HomeController());

  @override
  void initState() {
    crNotes.hitApi = false;
    super.initState();
    crNotes.getChannels();
  }

  var auth = Get.find<AuthController>();
  final PieChartController controller = Get.put(PieChartController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomeController(),
        builder: (homeCont) {
          homeCont.hitApi = false;
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: IgnorePointer(
              ignoring:
                  crNotes.isTextFieldEmpty.value && _createNoteImage == null,
              child: InkWell(
                onTap: () {
                  homeCont.getChannelMode?.channelId;
                  crNotes.createNoteImage = _createNoteImage;
                  crNotes.createNote(context);
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 30.0.h),
                  child: Obx(() {
                    return crNotes.isTextFieldEmpty.value &&
                            _createNoteImage == null
                        ? SvgPicture.asset("assets/svg/Create Renote.svg")
                        : SvgPicture.asset("assets/svg/Create Not.svg");
                  }),
                ),
              ),
            ),
            // resizeToAvoidBottomInset: false,
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
                                            controller.progressValue
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
                                width: 1,
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
                              Padding(
                                padding: EdgeInsets.only(right: 60.0.w),
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
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(const CreateThread(),
                                          arguments: crNotes.createNotes.text);
                                      String text = crNotes.createNotes.text;
                                    },
                                    child: const Icon(
                                      Icons.add,
                                      size: 20,
                                      color: Color(0xfff3C0061),
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
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xfff3C0061), width: 4),
                        ),
                        //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6.0),
                                      child: auth.user?.profileImage != null
                                          ? Image.network(
                                              String.fromCharCodes(base64Decode(
                                                  auth.user?.profileImage ??
                                                      "")),
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (BuildContext context,
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
                                  SizedBox(
                                    height: 40.h,
                                    width: 150.w,
                                    child: const CreateNotesDropdown(),
                                  ),
                                ],
                              ),
                              // SizedBox(
                              //   height: 24.h,
                              // ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TextFormField(
                                  autofocus: true,
                                  cursorColor: const Color(0xff3C0061),
                                  controller: crNotes.createNotes,
                                  onChanged: (text) {
                                    if (text.length <= 440) {
                                      crNotes.checkTextFieldEmpty(text);
                                      controller.updateProgressValue(text);
                                    }
                                  },
                                  maxLength: 440,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  decoration: InputDecoration(
                                    hintText: 'type something …',
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
                                visible: _createNoteImage != null,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height: 400,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: _createNoteImage == null
                                          ? Image.asset(
                                              "assets/icons/Add Photo.png")
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.file(
                                                File(_createNoteImage!.path),
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
                                            borderRadius:
                                                BorderRadius.circular(4.0),
                                          ),
                                          child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _createNoteImage = null;
                                                });
                                              },
                                              child: const Icon(
                                                  Icons.clear_rounded,
                                                  color: const Color(
                                                      0xfffFFFFFF))),
                                        )
                                        // IconButton(
                                        //   icon: const Icon(Icons.cancel),
                                        //   onPressed: () {
                                        //     setState(() {
                                        //       _createNoteImage = null;
                                        //     });
                                        //   },
                                        // ),
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
                      height: 35.h,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (mounted && pickedFile != null) {
      setState(() {
        final imageFile = File(pickedFile.path);
        final imageName =
            '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}';
        crNotes.uploadImage(imageFile, imageName);
        _createNoteImage = imageFile;
      });
    }
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (mounted && pickedFile != null) {
      setState(() {
        final imageFile = File(pickedFile.path);
        final imageName =
            '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}';
        crNotes.uploadImage(imageFile, imageName);
        _createNoteImage = imageFile;
      });
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

  Future<void> _showPostNotes(BuildContext context) async {
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
