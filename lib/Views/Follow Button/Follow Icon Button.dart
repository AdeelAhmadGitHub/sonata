import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Widgets/custom_text.dart';

class FollowButtonIcon extends StatefulWidget {
  @override
  _FollowButtonIconState createState() => _FollowButtonIconState();
}

class _FollowButtonIconState extends State<FollowButtonIcon> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFollowing = !isFollowing;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isFollowing ? Colors.white : const Color(0xff3C0061),
          border: Border.all(color: const Color(0xff3C0061)),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/icons/Follow (1).png",
              // color: isFollowing ? Colors.red : Colors.white,
            ),
            const SizedBox(width: 8),
            CustomText(
              text: isFollowing ? "Following" : "Follow",
              fontColor: isFollowing ? const Color(0xff3C0061) : Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              fontFamily: "Chillax",
            ),
          ],
        ),
      ),
    );
  }
}
