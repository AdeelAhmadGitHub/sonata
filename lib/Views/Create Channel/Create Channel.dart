import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Controllers/CreateChannelController/CreateChannelController.dart';
import '../Widgets/custom_text.dart';

class CreateChannelDialog extends StatefulWidget {
  const CreateChannelDialog({super.key});

  @override
  _CreateChannelDialogState createState() => _CreateChannelDialogState();
}

class _CreateChannelDialogState extends State<CreateChannelDialog> {
  File? _channelUploadImage;
  var createChannels = Get.put(CreateChannelController());
  FocusNode channelFocusNode = FocusNode();

  void initState() {
    super.initState();
    channelFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    channelFocusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xffD9D9D9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    height: 50,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/Add Channel Tag.svg",
                              color: const Color(0xffFD5201),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            CustomText(
                              text: 'Create Channel',
                              fontColor: const Color(0xff160323),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 94,
                        height: 94,
                        decoration: BoxDecoration(
                          color: const Color(0xffFAFAFD),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color(0xffC6BEE3),
                            width: 1,
                          ),
                        ),
                        child: _channelUploadImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(
                                  File(_channelUploadImage!.path),
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(31.0),
                                child: SvgPicture.asset(
                                  "assets/svg/upload.svg",
                                ),
                              ),
                      ),
                      const SizedBox(width: 25),
                      ElevatedButton(
                        onPressed: () {
                          _showChoiceDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                              color: Color(0xff3C0061),
                              width: 1,
                            ),
                          ),
                        ),
                        child: CustomText(
                          text: 'Choose Image',
                          fontColor: const Color(0xff3C0061),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25.h,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Channel Name',
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
                          color: channelFocusNode.hasFocus
                              ? Colors.white
                              : const Color(0xffFAFAFD),
                          border: Border.all(
                              width: 1,
                              color: (channelFocusNode.hasFocus
                                  ? const Color(0xff3C0061)
                                  : const Color(0xffC6BEE3))),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: TextFormField(
                          focusNode: channelFocusNode,
                          cursorColor: Color(0xff3C0061),

                          controller: createChannels.channelName,
                          decoration:  InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                            hintText: 'Enter text here',
                            hintStyle: TextStyle(
                                color: (channelFocusNode.hasFocus
                                    ? const Color(0xffBBBBBB)
                                    : const Color(0xff727272)),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontStyle: FontStyle.italic),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 44.h,
                      ),
                      Container(
                          height: 1.h,
                          width: double.infinity.w,
                          color: const Color(0xffF6F5FB)),
                      SizedBox(
                        height: 16.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
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
                                  fontColor: const Color(0xff444444),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Poppins",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              createChannels.createChannelImage =
                                  _channelUploadImage;
                              createChannels.createChannel();
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFF3C0061),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                  16.0, 10.0, 16.0, 10.0),
                            ),
                            child: CustomText(
                              text: 'Create Channel',
                              fontColor: const Color(0xffFFFFFF),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (mounted && pickedFile != null) {
      setState(() {
        final imageFile = File(pickedFile.path);
        final imageName =
            '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}';
        createChannels.uploadChannelImage(imageFile, imageName);
        _channelUploadImage = imageFile;
      });
    }
  }

  Future<void> _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (mounted && pickedFile != null) {
      setState(() {
        final imageFile = File(pickedFile.path);
        final imageName =
            '${DateTime.now().millisecondsSinceEpoch}_${pickedFile.path.split('/').last}';
        createChannels.uploadChannelImage(imageFile, imageName);
        _channelUploadImage = imageFile;
      });
    }
  }

  Future<void> _showChoiceDialog(BuildContext context) async {
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
                ],
              ),
            ),
          );
        });
  }
}
