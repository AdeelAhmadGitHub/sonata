import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sonata/api/ws_api_checker.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart' as ws;

import 'dart:io';
String? tokenMain;
final ws.WebSocketChannel _webSocketChannel =
ws.WebSocketChannel.connect(Uri.parse('ws://sonata.seromatic.com:9501'));
class ApiClientWs extends GetxService {
  final String appBaseUrl;
  static const String noInternetMessage =
      'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 600;
  String? token;
  Map<String, String> _mainHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': "*",
  };
  ws.WebSocketChannel? channel;

  ApiClientWs({
    required this.appBaseUrl,
  }) {
    channel = _webSocketChannel;
  }

  void updateHeader(String token) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': "*",
      'Authorization': 'Bearer $token'
    };
  }

  ApiCheckerWs apichecker = ApiCheckerWs();

  Future<Response> getData(String uri, {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse(appBaseUrl + uri);
      final newURI = url.replace(queryParameters: query);
      print("Url: $newURI");

      channel = ws.WebSocketChannel.connect(newURI);
      final response = await channel!.stream.first;

      return apichecker.checkApi(response: response);
    } catch (e) {
      print("error: $e");
      return Response(statusCode: 1, body: null);
    }
  }

  Future<dynamic> postData(dynamic body, {Map<String, String>? headers, bool showdialog = true}) async {
    Completer<dynamic>? completer;
    if (showdialog) {
      completer = Completer<dynamic>();
      popDialog();
    }
    try {
      print(token);
      print(Uri.parse(appBaseUrl));
      print("body : ${jsonEncode(body)}");
      print("headers : ${jsonEncode(_mainHeaders)}");

      channel!.sink.add(jsonEncode(body));

      // Listen to the stream only once and store the response
      final response = await channel!.stream.firstWhere(
            (response) => !response.startsWith('This is server'),
        orElse: () => 'No response received', // Add a default value if no response is received
      );

      if (completer != null) {
        Get.back();
        final parsedResponse = apichecker.checkApi(response: response);
        completer.complete(parsedResponse);
      }
      print(response);

      if (response is String) {
        return completer?.future ?? apichecker.checkApi(response: response);
      } else {
        return completer?.future ?? Response(statusCode: 1, body: null); // Handle other response types accordingly
      }
    } catch (e) {
      if (completer != null) {
        Get.back();
        completer.complete(Response(statusCode: 200, body: null)); // Corrected the arguments for Response constructor
      }
      print("error: $e");
      return completer?.future ?? Response(statusCode: 1, body: null); // Corrected the arguments for Response constructor
    } finally {
      // Close the WebSocket channel after completing the request
      // channel?.sink.close();
    }
  }


  popDialog() {
    Get.dialog(
      Dialog(
        elevation: 0,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: AnimatedCircleAnimations(),
      ),
    );
  }
}

class ApiCheckerWs {
  Future<Response> checkApi({
    required dynamic response,
    bool showUserError = true,
    bool showSystemError = true,
  }) async {
    try {
      final decodedResponse = response is String ? jsonDecode(response) : response;
      final data = decodedResponse['data'];
      final statusCode = decodedResponse['status'];

      if (statusCode == 200) {
        return Response(
          statusCode: statusCode,
          body: data,
        );
      } else if (statusCode == 401 || statusCode == 403) {
        if (showUserError) {
          // Handle user error case, e.g., logout user and navigate to a login screen
        }
      } else if (statusCode >= 500) {
        if (showSystemError) {
          // Handle system error case, e.g., display a server error message
        }
      } else if (statusCode >= 400) {
        if (showUserError) {
          // Handle user error case, e.g., display an error message from the response body
        }
      }
    } catch (e) {
      print('Error parsing response: $e');
    }

    return Response(
      statusCode: 1, // Set a default status code in case of error
      body: null, // Set the data to null in case of error
    );
  }

}








class AnimatedCircleAnimations extends StatefulWidget {
  @override
  _AnimatedCircleAnimationsState createState() =>
      _AnimatedCircleAnimationsState();
}

class _AnimatedCircleAnimationsState extends State<AnimatedCircleAnimations>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _circleAnimation;
  late Animation<double> _circleBlAnimation;
  late Animation<double> _circleTrAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });

    _circleAnimation = Tween<double>(begin: 0.0, end: 360.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.linear),
      ),
    );

    _circleBlAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _circleTrAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Transform.rotate(
            angle: _circleAnimation.value * 0.0174533,
            child: SvgPicture.asset(
              'assets/svg/Hash.svg',
              width: 60.h,
              height: 60.h,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Transform.rotate(
              angle: _circleBlAnimation.value * pi,
              child: Transform.translate(
                offset: const Offset(-25, 25),
                child: SvgPicture.asset(
                  'assets/svg/Circle_1.svg',
                  width: 40.h,
                  height: 40.h,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Transform.rotate(
              angle: _circleTrAnimation.value * pi,
              child: Transform.translate(
                offset: const Offset(25, -25),
                child: SvgPicture.asset(
                  'assets/svg/Circle_2.svg',
                  width: 40.h,
                  height: 40.h,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
