import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

class MyImageWidget extends StatelessWidget {
  final String? base64String;
  final String placeholderImageUrl;

  MyImageWidget(
      {required this.base64String, required this.placeholderImageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: _getImageUrl(),
      placeholder: (context, url) => Image.asset(
        placeholderImageUrl,
        fit: BoxFit.cover,
      ),
      errorWidget: (context, url, error) => SvgPicture.asset(
        placeholderImageUrl,
        height: 50,
        width: 50,
      ),
      fit: BoxFit.cover,
    );
  }

  String _getImageUrl() {
    if (base64String == null) {
      return placeholderImageUrl;
    }
    return 'data:image/png;base64,$base64String';
  }
}
