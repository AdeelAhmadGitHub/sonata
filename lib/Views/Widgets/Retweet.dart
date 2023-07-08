import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../Renote/Renote.dart';

class RetweetButton extends StatefulWidget {
  const RetweetButton({super.key});

  @override
  _RetweetButtonState createState() => _RetweetButtonState();
}

class _RetweetButtonState extends State<RetweetButton> {
  bool _retweeted = false;
  int _retweetCount = 0;

  void _toggleRetweeted() {
    setState(() {
      _retweeted = !_retweeted;
      if (_retweeted) {
        _retweetCount++;
      } else {
        _retweetCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleRetweeted,
      child: InkWell(
        onTap: () {
          Get.to(Renote());
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              _retweeted
                  ? 'assets/icons/retweet.png'
                  : 'assets/icons/retweet.png',
              height: 20.w,
              width: 20.w,
            ),
            const SizedBox(width: 8.0),
            Text(
              _retweetCount.toString(),
              style: const TextStyle(
                color: Color(0xff444444),
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
