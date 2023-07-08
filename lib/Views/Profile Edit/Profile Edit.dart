import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sonata/Controllers/Upload%20Image.dart';
import 'dart:math' as math;
import '../../Controllers/PieChartController/PieChartController.dart';
import '../../Controllers/auth_controller.dart';
import '../NaviationBar/NavigationBarScreen.dart';
import '../SideBar/SideBar.dart';
import '../Widgets/custom_text.dart';

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final PieChartController controller = Get.put(PieChartController());
  var edit = Get.put(UploadProfileController());
  var auth = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    edit.editNameCont.text = auth.profileModel?.userName ?? "";
    edit.editTagLine.text = auth.profileModel?.profileTagline ?? "";
    edit.editDescriptionCont.text =
        auth.profileModel?.userProfileDescription ?? "";
    edit.editLocationCont.text = auth.profileModel?.profileLocation ?? "";
    edit.editWorkCont.text = auth.profileModel?.profileWork ?? "";
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
                      child: auth.profileModel?.profileImage != null
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset("assets/icons/ProfilePage .png"),
                        SizedBox(
                          width: 20.w,
                        ),
                        CustomText(
                          text: 'Profile',
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
                    SizedBox(height: 18.h),
                    SizedBox(
                      height: 280,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 190,
                            decoration: BoxDecoration(
                              color: Color(0xfff3C0061),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Stack(
                              children: [
                                edit.editCoverImage == null
                                    ? Container(
                                        width: double.infinity,
                                        height: 190,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(9.0),
                                          child: auth.profileModel
                                                      ?.coverImage !=
                                                  null
                                              ? Image.network(
                                                  String.fromCharCodes(
                                                      base64Decode(auth
                                                              .profileModel
                                                              ?.coverImage ??
                                                          "")),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (BuildContext
                                                          context,
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
                                                ),
                                        ),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        height: 190,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Image.file(
                                            File(edit.editCoverImage!.path),
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                Positioned(
                                  child: InkWell(
                                    onTap: () {
                                      _showAddBackground(context);
                                    },
                                    child: Center(
                                      child: Positioned(
                                        child: Image.asset(
                                          "assets/icons/Add Cover Photo.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 16.0,
                            top: 150,
                            child: Container(
                              width: 112.w,
                              height: 112.h,
                              child: Stack(
                                children: [
                                  edit.editProfileImage == null
                                      ? Container(
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
                                                  ),
                                          ),
                                        )
                                      : Container(
                                          width: 112,
                                          height: 112,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            child: Image.file(
                                              File(edit.editProfileImage!.path),
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                  Positioned(
                                    child: InkWell(
                                      onTap: () {
                                        _showAddProfile(context);
                                      },
                                      child: Center(
                                        child: Image.asset(
                                          "assets/icons/Add Photos.png",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.0.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.privacy_tip_outlined,
                          color: Color(0xff3C0061),
                          size: 20,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          text: 'View Privacy Info',
                          fontColor: const Color(0xff3C0061),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0.h),
                    CustomText(
                      text: 'Name',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Chillax",
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFD),
                        border: Border.all(
                            width: 1, color: const Color(0xffC6BEE3)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: edit.editNameCont,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintText: 'You Name',
                          hintStyle: TextStyle(
                              color: const Color(0xff8E8694),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      text: '@handle',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Chillax",
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      height: 44.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffFBFBFB),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: auth.user?.userHandle,
                            fontColor: const Color(0xff868686),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      text: 'Date of Birth',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Chillax",
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      height: 44.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffFBFBFB),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: auth.profileModel?.dateOfBirth,
                            fontColor: const Color(0xff868686),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'Tagline',
                          fontColor: const Color(0xff444444),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                        Row(
                          children: [
                            Obx(() => Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xff3C0061),
                                      width: 6,
                                    ),
                                  ),
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: CircularProgressIndicator(
                                      value: controller.progressValueTagline
                                          .clamp(0.0, 1.0)
                                          .toDouble(),
                                      backgroundColor: Colors.white,
                                      strokeWidth: 10,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        const Color(0xff3C0061),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      height: null,
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFD),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xffC6BEE3),
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: edit.editTagLine,
                        onChanged: (text) {
                          if (text.length <= 100) {
                            controller.updateProgressTagline(text);
                          }
                        },
                        maxLines: null,
                        minLines: 1,
                        maxLength: 100,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintText: 'Write your tagline',
                          hintStyle: TextStyle(
                            color: const Color(0xff8E8694),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: 'Description',
                          fontColor: const Color(0xff444444),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                        Row(
                          children: [
                            Obx(() => Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xff3C0061),
                                      width: 6,
                                    ),
                                  ),
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(math.pi),
                                    child: CircularProgressIndicator(
                                      value: controller.progressValueDes
                                          .clamp(0.0, 1.0)
                                          .toDouble(),
                                      backgroundColor: Colors.white,
                                      strokeWidth: 10,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        const Color(0xff3C0061),
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      height: 82.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFD),
                        border: Border.all(
                            width: 1, color: const Color(0xffC6BEE3)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: edit.editDescriptionCont,
                        onChanged: (text) {
                          if (text.length <= 200) {
                            controller.updateProgressDesp(text);
                          }
                        },
                        maxLines: null,
                        minLines: 1,
                        maxLength: 200,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintText: 'Write about yourself',
                          hintStyle: TextStyle(
                              color: const Color(0xff8E8694),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic),
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: 'Location',
                              fontColor: const Color(0xff444444),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Image.asset(
                              "assets/icons/Location.png",
                              height: 24.h,
                              width: 24.w,
                              color: const Color(0xff444444),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFD),
                        border: Border.all(
                            width: 1, color: const Color(0xffC6BEE3)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: edit.editLocationCont,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintText: 'Where do you live?',
                          hintStyle: TextStyle(
                              color: Color(0xff8E8694),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: 'Work',
                              fontColor: const Color(0xff444444),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            Image.asset(
                              "assets/icons/Work.png",
                              height: 24.h,
                              width: 24.w,
                              color: const Color(0xff444444),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFD),
                        border: Border.all(
                            width: 1, color: const Color(0xffC6BEE3)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: edit.editWorkCont,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintText: 'Where do you work?',
                          hintStyle: TextStyle(
                              color: Color(0xff8E8694),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Container(
                      height: 1.h,
                      width: double.infinity.w,
                      color: const Color(0xffF6F5FB),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 44.h,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.back();
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
                        SizedBox(
                          width: 20.w,
                        ),
                        SizedBox(
                          height: 44.h,
                          child: ElevatedButton(
                            onPressed: () async {
                              edit.editProfileUser();
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
                              text: 'Save Changes',
                              fontColor: const Color(0xffFFFFFF),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCameraBackground(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (mounted && pickedFile != null) {
      setState(() {
        final imageFile = File(pickedFile.path);
        final coverImageName =
            '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}';
        edit.coverImageUpload(imageFile, coverImageName);
        edit.editCoverImage = imageFile;
      });
    }
  }

  void _openGalleryBackground(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (mounted && pickedFile != null) {
      setState(() {
        final imageFile = File(pickedFile.path);
        final coverImageName =
            '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}';
        edit.coverImageUpload(imageFile, coverImageName);
        edit.editCoverImage = imageFile;
      });
    }
  }

  Future<void> _showAddBackground(BuildContext context) {
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
                      _openGalleryBackground(context);
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
                      _openCameraBackground(context);
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

  void _openEditProfileCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );

    if (mounted && pickedFile != null) {
      setState(() {
        final imageFile = File(pickedFile.path);
        final imageName =
            '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}';
        edit.editProfileImages(imageFile, imageName);
        edit.editProfileImage = imageFile;
      });
    }
  }

  void _openEditProfileGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (mounted && pickedFile != null) {
      setState(() {
        final imageFile = File(pickedFile.path);
        final imageName =
            '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}';
        edit.editProfileImages(imageFile, imageName);
        edit.editProfileImage = imageFile;
      });
    }
  }

  Future<void> _showAddProfile(BuildContext context) {
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
                      _openEditProfileGallery(context);
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
                      _openEditProfileCamera(context);
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
}
