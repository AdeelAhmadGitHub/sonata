import 'package:dropdown_button2/src/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';

import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/auth_controller.dart';
import '../../Models/getChannel Model.dart';

class CreateNotesDropdown extends StatefulWidget {
  const CreateNotesDropdown({Key? key}) : super(key: key);

  @override
  State<CreateNotesDropdown> createState() => _CreateNotesDropdownState();
}

class _CreateNotesDropdownState extends State<CreateNotesDropdown> {
  GetChannelMode? selectedValue;

  var auth = Get.find<AuthController>();
  var getchannel = Get.find<HomeController>();

  String getFirstChannelName() {
    if (getchannel.channels.isNotEmpty) {
      GetChannelMode firstChannel = getchannel.channels.first;
      int? channelId = firstChannel.channelId;
      getchannel.channelIdCreatePost = channelId;
      String channelName = firstChannel.chanelName ?? 'Select a channel';
      if (channelId != null) {
        return channelName;
      } else {
        return channelName;
      }
    } else {
      return 'Select a channel';
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    getchannel.hitApi = false;
  }

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>1>>>>>>>>>>${getchannel.channelIdCreatePost}<<<<<<<<<");
    return GetBuilder(
        init: HomeController(),
        builder: (homeCont) {
          homeCont.hitApi = false;
          return Scaffold(
            backgroundColor: Colors.transparent,
            body: DropdownButtonHideUnderline(
              child: DropdownButton2<GetChannelMode>(
                isExpanded: true,
                hint: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/svg/Channel Tag.svg",
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      child: CustomText(
                        text: selectedValue != null
                            ? selectedValue?.chanelName ?? 'Select a channel'
                            : getFirstChannelName(),
                        fontColor: Color(0xff444444),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Chillax",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Add this line
                      ),
                    ),
                  ],
                ),
                items: getchannel.channels.map((item) {
                  return DropdownMenuItem<GetChannelMode>(
                    value: item,
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/Channel Tag.svg",
                        ),
                        SizedBox(
                          width: 9.w,
                        ),
                        Flexible(
                          child: CustomText(
                            text: item.chanelName,
                            fontColor: const Color(0xff444444),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Chillax",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                value: selectedValue,
                onChanged: (value) {
                  print(">>>>>>>>>>>>>>>>>${value?.channelId}<<<<<<<<<");
                  setState(() {
                    selectedValue = value;
                    homeCont.channelIdCreatePost = value?.channelId;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 50.h,
                  width: 150.w,
                  padding: const EdgeInsets.only(left: 9, right: 9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xfffC6BEE3),
                    ),
                    color: Colors.transparent,
                  ),
                  elevation: 0,
                ),
                iconStyleData: const IconStyleData(
                  icon: ImageIcon(
                    AssetImage("assets/icons/tabler_chevron-down.png"),
                  ),
                  iconSize: 20,
                  iconEnabledColor: Color(0xfff444444),
                  iconDisabledColor: Colors.red,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 204.h,
                  width: 150.w,
                  padding: null,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xfffC6BEE3),
                    ),
                    color: Colors.white,
                  ),
                  elevation: 0,
                  offset: const Offset(0, -5),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(8),
                    thickness: MaterialStateProperty.all<double>(4),
                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
            ),
          );
        });
  }
}
