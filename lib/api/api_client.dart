import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'api_checker.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';

String? tokenMain;
 String baseUrl = "http://sonata.seromatic.com:9501/";
//String baseUrl = "http://192.168.18.89:9501/";

class ApiClient extends GetxService {
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

  ApiClient({
    required this.appBaseUrl,
  }) {
    if (tokenMain != null) {
      updateHeader(
        tokenMain!,
      );
    }
  }
  void updateHeader(
    String token,
  ) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Access-Control-Allow-Origin': "*",
      'Authorization': 'Bearer $token'
    };
  }

  ApiChecker apichecker = ApiChecker();
  Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      final url = Uri.parse(appBaseUrl + uri);
      final newURI = url.replace(queryParameters: query);
      print("Url:  $newURI");
      http.Response _response = await http
          .get(
            newURI,
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return apichecker.checkApi(
        respons: _response,
      );
    } catch (e) {
      print("eroor : $e");
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String>? headers, bool showdialog = true}) async {
    if (showdialog) {
      popDialog();
    }
    try {
      print(token);
      print(Uri.parse(appBaseUrl + uri));
      print("body : ${jsonEncode(body)}");
      print("headers : ${jsonEncode(_mainHeaders)}");
      http.Response _response = await http
          .post(
            Uri.parse(appBaseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds))
          .catchError((_) {
        if (showdialog) {
          Get.back();
        }
      });
      if (showdialog) {
        Get.back();
      }
      print(_response.body);
      return apichecker.checkApi(respons: _response);
    } catch (e) {
      if (showdialog) {
        Get.back();
      }
      print("error" + e.toString());
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postWithForm(String uri, Map<String, dynamic> body,
      {Map<String, String>? headers}) async {
    popDialog();
    try {
      Map<String, String> stringQueryParameters =
          body.map((key, value) => MapEntry(key, value.toString()));
      var headers = _mainHeaders;
      var request = http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      request.fields
          .addAll(body.map((key, value) => MapEntry(key, value.toString())));

      request.headers.addAll(headers);

      http.StreamedResponse streamedResponse = await request.send();
      Get.back();
      var response = await http.Response.fromStream(streamedResponse);

      return apichecker.checkApi(respons: response);
    } catch (e) {
      Get.back();
      print("error" + e.toString());
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      http.Response _response = await http
          .put(
            Uri.parse(appBaseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return apichecker.checkApi(respons: _response);
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri,
      {Map<String, dynamic>? query,
      Map<String, String>? headers,
      Map<String, dynamic>? body}) async {
    try {
      final url = Uri.parse(appBaseUrl + uri);
      final newURI = url.replace(queryParameters: query);
      print("Url:  $newURI");
      print("body:  $body");
      http.Response _response = await http
          .delete(
            url,
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return apichecker.checkApi(
        respons: _response,
      );
    } catch (e) {
      return const Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  popDialog() {
    // showDialog(
    //   barrierDismissible: false,
    //   context: Get.context!,
    //   builder: (BuildContext context) {
    //     return WillPopScope(
    //         onWillPop: () => Future.value(false),
    //         child:AlertDialog(
    //           title:  Text("Please Complete profile details"),
    //           content:  SingleChildScrollView(
    //             child: Container(),),
    //           actions: <Widget>[
    //             TextButton(
    //               child:  const Text("Go to profile"),
    //               onPressed: () {
    //                 Get.to(const Accounts());
    //               },
    //             ),
    //           ],
    //         )
    //     );
    //   },
    // );

    // Get.defaultDialog(
    //   backgroundColor: Colors.white,
    //   buttonColor: Colors.white,
    //   title: "",
    //   content: WillPopScope(
    //       onWillPop: () => Future.value(false),
    //       child: const SpinKitSpinningLines(
    //         color: Color(0xff3C0061),
    //       )),
    // );

    Get.dialog(Dialog(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        child: AnimatedCircleAnimation()));
    // Get.defaultDialog(
    //   backgroundColor: Colors.transparent,
    //   title: "",
    //   content: SizedBox(
    //       height: 50.h,
    //       child: AnimatedCircleAnimation()),
    // );
  }

  // Response handleResponse(http.Response response, String uri) {
  //   dynamic _body;
  //   try {
  //     _body = jsonDecode(response.body);
  //   } catch (e) {}
  //   Response _response = Response(
  //     body: _body != null ? _body : response.body,
  //     bodyString: response.body.toString(),
  //     request: Request(
  //         headers: response.request!.headers,
  //         method: response.request!.method,
  //         url: response.request!.url),
  //     headers: response.headers,
  //     statusCode: response.statusCode,
  //     statusText: response.reasonPhrase,
  //   );
  //
  //   if (_response.statusCode != 200 && _response.body == null) {
  //     _response = const Response(statusCode: 0, statusText: noInternetMessage);
  //   }
  //   print(
  //       '====> API Response: [${_response.statusCode}] $uri\n${_response.body}');
  //   return _response;
  // }
}

class AnimatedCircleAnimation extends StatefulWidget {
  @override
  _AnimatedCircleAnimationState createState() =>
      _AnimatedCircleAnimationState();
}

class _AnimatedCircleAnimationState extends State<AnimatedCircleAnimation>
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
            // Convert degrees to radians
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
