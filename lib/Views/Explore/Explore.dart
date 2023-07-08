import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sonata/Controllers/Explore%20Controller/Explore_controller.dart';
import 'package:sonata/Views/Create%20Profile/Create%20Profile.dart';
import 'package:sonata/Views/Sign%20In/SignIn.dart';
import 'package:sonata/Views/Widgets/CommentIcon.dart';
import 'package:sonata/Views/Widgets/FavoriteIcon.dart';
import 'package:sonata/Views/Widgets/Retweet.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final exploreCont = Get.put(ExploreController());
  bool _isSearchVisible = false;
  @override
  void initState() {
    exploreCont.apiHit = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE3E3E3),
      appBar: AppBar(
        leadingWidth: _isSearchVisible
            ? 0
            : 170.w, // Set leadingWidth to 0 when search is visible
        leading: _isSearchVisible
            ? null
            : Padding(
                padding: EdgeInsets.only(left: 24.0.w),
                child: Image.asset(
                  'assets/icons/Sonata_Logo.png',
                  height: 34.h,
                  width: 174.w,
                ),
              ),
        actions: <Widget>[
          Visibility(
            visible: !_isSearchVisible,
            child: Padding(
              padding: EdgeInsets.only(
                right: 10.0.w,
              ),
              child: IconButton(
                icon: Image.asset(
                  "assets/icons/Search Note.png",
                  height: 32.h,
                  width: 32,
                ),
                onPressed: () {
                  setState(() {
                    _isSearchVisible = true;
                  });
                },
              ),
            ),
          ),
          Visibility(
            visible: _isSearchVisible,
            child: Expanded(
                child: Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 24.0.w),
                      child: Image.asset(
                        'assets/icons/sonata.png',
                      ),
                    ),
                    SizedBox(
                      width: 24.w,
                    ),
                    Expanded(
                      child: Container(
                        height: 48.h,
                        //margin: const EdgeInsets.only(left: 81.9),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              width: 1, color: const Color(0xffC6BEE3)),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: 'Search for users',
                            hintStyle: TextStyle(
                                color: Color(0xff727272),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins'),
                            border: InputBorder.none,
                            prefixIcon:
                                Icon(Icons.search, color: Color(0xff727272)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ),
        ],
        elevation: 0.0,
        backgroundColor: const Color(0xff3C0061),
        toolbarHeight: 78.h,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  Image.asset(
                    "assets/icons/Explore.png",
                    height: 32.h,
                    width: 32.w,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  CustomText(
                    text: 'Explore',
                    fontColor: const Color(0xff160323),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Chillax",
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                height: 1.h,
                width: double.infinity.w,
                color: Colors.grey,
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                children: [
                  Image.asset(
                    "assets/icons/mdi_latest.png",
                    height: 24.h,
                    width: 24.w,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  CustomText(
                    text: 'Latest Notes',
                    fontColor: const Color(0xff160323),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Chillax",
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              ListView.builder(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: exploreCont.explore.length,
                itemBuilder: (BuildContext context, int index) {
                  var exploreItem = exploreCont.explore[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 16.0.h),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 72.h,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(60, 0, 97, 0.06),
                                  offset: Offset(0, 2),
                                  blurRadius: 6,
                                )
                              ],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 50.h,
                                      height: 50.w,
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            exploreItem.profileImage ?? "",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: exploreItem.userName,
                                          fontColor: const Color(0xff160323),
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Chillax",
                                        ),
                                        CustomText(
                                          text: exploreItem.userHandle,
                                          fontColor: const Color(0xff3C0061),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: "Poppins",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text: exploreItem.noteTimeAgo,
                                        fontColor: const Color(0xff767676),
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w300,
                                        fontFamily: "Poppins",
                                      ),
                                      // SizedBox(
                                      //   width: 16.w,
                                      // ),
                                      // Row(
                                      //   children: [
                                      //     Image.asset('assets/images/menu.png'),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                            child: Container(
                              width: 100.w,
                              height: 32.h,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 2, color: const Color(0xffC6BEE3)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset('assets/images/Channel Tag.jpg'),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    text: exploreItem.channelsName,
                                    fontColor: const Color(0xff444444),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Chillax",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            child: CustomText(
                              text: exploreItem.noteBody,
                              fontColor: const Color(0xff444444),
                              fontSize: 16.sp,
                              height: 1.5,
                              fontFamily: "Poppins",
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Visibility(
                            visible: exploreItem.noteImage != null,
                            child: Container(
                              width: double.infinity,
                              height: null,
                              margin: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: exploreItem.noteImage != null
                                    ? Image.network(
                                        exploreItem.noteImage ?? "",
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Container(
                              // padding: EdgeInsets.symmetric(vertical: 10.h),
                              width: double.infinity,
                              // height: 50.h,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFF6F5FB),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  LikeButton(),
                                  CommentButton(),
                                  const RetweetButton(),
                                  const Icon(
                                    Icons.share,
                                    color: Color(0xff699BF7),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 92.h,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SizedBox(
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(const CreateProfile());
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      elevation: 0,
                      onPrimary: const Color(0xFF3C0061),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(
                          width: 2,
                          color: Color(0xFF3C0061),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'Register',
                          fontColor: const Color(0xff3C0061),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: SizedBox(
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(const SignIn());
                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF3C0061),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding:
                          const EdgeInsets.fromLTRB(16.0, 10.0, 12.0, 10.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icons/Sign In Icon.png",
                          height: 22.h,
                          width: 21.w,
                        ),
                        const SizedBox(width: 10.0),
                        CustomText(
                          text: 'Sign In',
                          fontColor: const Color(0xffFFFFFF),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
