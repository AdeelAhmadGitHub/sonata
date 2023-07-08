import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../Controllers/HomeController/HomeController.dart';
import '../../Controllers/Search Controller/SearchController.dart';
import '../../Controllers/userUsingSonataController/userUsingSonataControlloer.dart';
import '../Widgets/custom_text.dart';

class FollowButton extends StatefulWidget {
  FollowButton({Key? key}) : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowing = false;
  var folow = Get.put(userUsingSonataController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: userUsingSonataController(),
        builder: (homeCont) {
          return GestureDetector(
            onTap: () async {
              setState(() {
                isFollowing = !isFollowing;
              });
              folow.followHandle = homeCont.jsonSideArray?.userHandle;
              folow.createUserFollow();
            },
            child: Container(
              decoration: BoxDecoration(
                color: isFollowing ? Colors.white : Color(0xff330320),
                border: Border.all(color: Color(0xff330320)),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: CustomText(
                text: isFollowing ? "Following" : "Follow",
                fontColor: isFollowing ? Color(0xff330320) : Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontFamily: "Chillax",
              ),
            ),
          );
        });
  }
}
