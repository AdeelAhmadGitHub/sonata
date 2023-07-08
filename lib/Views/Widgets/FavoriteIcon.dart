import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';

class LikeButton extends StatefulWidget {
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  int _likeCount = 0;
  bool _liked = false;

  void _toggleLike() {
    setState(() {
      if (_liked) {
        _likeCount--;
      } else {
        _likeCount++;
      }
      _liked = !_liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            _liked ? Icons.favorite : Icons.favorite_border,
            color: const Color(0xffCE1616),
          ),
          onPressed: _toggleLike,
        ),
        CustomText(
          text: _likeCount.toString(),
          fontColor: const Color(0xff444444),
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          fontFamily: "Poppins",
        ),
      ],
    );
  }
}
