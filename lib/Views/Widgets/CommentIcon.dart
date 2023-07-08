import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Create Note (Replying)/Replying Notes.dart';

class CommentButton extends StatefulWidget {
  @override
  _CommentButtonState createState() => _CommentButtonState();
}

class _CommentButtonState extends State<CommentButton> {
  int _commentCount = 0;

  void _addComment() {
    // Handle adding comment logic here
    setState(() {
      _commentCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _addComment();
        // Open comment dialog here
      },
      child: InkWell(
        onTap: () {
          Get.to(ReplyingNotes());
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.comment_outlined,
              color: Color(0xff0FA958),
            ),
            const SizedBox(width: 8.0),
            Text(
              _commentCount.toString(),
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
