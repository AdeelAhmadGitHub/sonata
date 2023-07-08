// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../SideBar/SideBar.dart';
// import '../Widgets/custom_text.dart';
// import 'Searching Screen.dart';
//
// class Search extends StatefulWidget {
//   const Search({Key? key}) : super(key: key);
//
//   @override
//   State<Search> createState() => _SearchState();
// }
//
// class _SearchState extends State<Search> {
//   int visibleCount = 3;
//
//   void _showMoreItems() {
//     setState(() {
//       visibleCount += 3;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: const SideBar(),
//       backgroundColor: const Color(0xffE3E3E3),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Padding(
//           padding: const EdgeInsets.only(right: 12.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Image.asset(
//                 'assets/icons/Sonata_Logo.png',
//                 height: 34.h,
//                 width: 174.w,
//               ),
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   image: const DecorationImage(
//                     image: AssetImage("assets/images/homeProfile.png"),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         elevation: 0.0,
//         backgroundColor: const Color(0xff3C0061),
//         toolbarHeight: 78.h,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.0.w),
//           child: Column(
//             children: [
//               SizedBox(height: 20.h),
//               InkWell(
//                 onTap: () {
//                   Get.to(const SearchingScreen());
//                 },
//                 child: Container(
//                   height: 48.h,
//                   //margin: const EdgeInsets.only(left: 81.9),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                     border:
//                         Border.all(width: 1, color: const Color(0xffC6BEE3)),
//                   ),
//                   child: const TextField(
//                     decoration: InputDecoration(
//                       contentPadding: EdgeInsets.only(top: 2),
//                       hintText: 'Search for users',
//                       hintStyle: TextStyle(
//                           color: Color(0xff727272),
//                           fontWeight: FontWeight.w500,
//                           fontFamily: 'Poppins'),
//                       border: InputBorder.none,
//                       prefixIcon: Icon(Icons.search, color: Color(0xff727272)),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Container(
//                 padding: const EdgeInsets.only(top: 16.0),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: const Color(0xfffFAF8F5),
//                   border: Border.all(color: const Color(0xffEAE4D9), width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 12.h),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             "assets/icons/mdi_latest.png",
//                             height: 24.h,
//                             width: 24.w,
//                           ),
//                           SizedBox(
//                             width: 10.w,
//                           ),
//                           CustomText(
//                             text: 'Latest Notes',
//                             fontColor: const Color(0xff160323),
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: "Chillax",
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//                     ListView.builder(
//                       physics: const ScrollPhysics(),
//                       shrinkWrap: true,
//                       scrollDirection: Axis.vertical,
//                       itemCount: visibleCount,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(
//                               left: 16.0, right: 16.0, bottom: 16),
//                           child: Container(
//                             padding: const EdgeInsets.all(12.0),
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(
//                                   color: const Color(0xffEAE4D9), width: 1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           width: 50.h,
//                                           height: 50.w,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                             image: DecorationImage(
//                                               image: AssetImage(
//                                                 ExModel
//                                                     .dummyData[index].profile,
//                                               ),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 10,
//                                         ),
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             CustomText(
//                                               text:
//                                                   ExModel.dummyData[index].name,
//                                               fontColor:
//                                                   const Color(0xff160323),
//                                               fontSize: 16.sp,
//                                               fontWeight: FontWeight.w600,
//                                               fontFamily: "Chillax",
//                                             ),
//                                             CustomText(
//                                               text: ExModel
//                                                   .dummyData[index].gmail,
//                                               fontColor:
//                                                   const Color(0xff3C0061),
//                                               fontSize: 14.sp,
//                                               fontWeight: FontWeight.w300,
//                                               fontFamily: "Poppins",
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 12.0),
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           GestureDetector(
//                                             onTap: () {
//                                               _showBottomMenu(context);
//                                             },
//                                             child: Row(
//                                               children: const [
//                                                 Icon(
//                                                   Icons.more_vert,
//                                                   color: Color(0xfff444444),
//                                                 ),
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   height: 16.h,
//                                 ),
//                                 Container(
//                                   width: double.infinity,
//                                   height: 21,
//                                   alignment: Alignment.centerLeft,
//                                   child: CustomText(
//                                     text:
//                                         "Lorem ipsum dolor sit amet conse.........",
//                                     fontColor: const Color(0xff444444),
//                                     fontSize: 16.sp,
//                                     height: 1.5,
//                                     fontFamily: "Poppins",
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     if (visibleCount < ExModel.dummyData.length)
//                       GestureDetector(
//                         onTap: _showMoreItems,
//                         child: CustomText(
//                           text: 'Show More',
//                           fontColor: const Color(0xff330320),
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: "Chillax",
//                         ),
//                       ),
//                     SizedBox(
//                       height: 16.h,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 20.h),
//               Container(
//                 padding: const EdgeInsets.only(top: 16.0),
//                 width: double.infinity,
//                 decoration: BoxDecoration(
//                   color: const Color(0xfffFAF8F5),
//                   border: Border.all(color: const Color(0xffEAE4D9), width: 1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 12.h),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                       child: Row(
//                         children: [
//                           Image.asset(
//                             "assets/icons/Discover.png",
//                             height: 24.h,
//                             width: 24.w,
//                           ),
//                           SizedBox(
//                             width: 10.w,
//                           ),
//                           CustomText(
//                             text: 'Discover',
//                             fontColor: const Color(0xff160323),
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w600,
//                             fontFamily: "Chillax",
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 12.h),
//                     ListView.builder(
//                       physics: const ScrollPhysics(),
//                       shrinkWrap: true,
//                       scrollDirection: Axis.vertical,
//                       itemCount: visibleCount,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Padding(
//                           padding: const EdgeInsets.only(
//                               left: 16.0, right: 16.0, bottom: 16),
//                           child: Container(
//                             padding: const EdgeInsets.all(12.0),
//                             width: double.infinity,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               border: Border.all(
//                                   color: const Color(0xffEAE4D9), width: 1),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             //  padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           width: 50.h,
//                                           height: 50.w,
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(8),
//                                             image: DecorationImage(
//                                               image: AssetImage(
//                                                 ExModel
//                                                     .dummyData[index].profile,
//                                               ),
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(
//                                           width: 10,
//                                         ),
//                                         Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             CustomText(
//                                               text:
//                                                   ExModel.dummyData[index].name,
//                                               fontColor:
//                                                   const Color(0xff160323),
//                                               fontSize: 16.sp,
//                                               fontWeight: FontWeight.w600,
//                                               fontFamily: "Chillax",
//                                             ),
//                                             CustomText(
//                                               text: ExModel
//                                                   .dummyData[index].gmail,
//                                               fontColor:
//                                                   const Color(0xff3C0061),
//                                               fontSize: 14.sp,
//                                               fontWeight: FontWeight.w300,
//                                               fontFamily: "Poppins",
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 12.0),
//                                       child: Row(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.center,
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           GestureDetector(
//                                             onTap: () {
//                                               _showBottomMenu(context);
//                                             },
//                                             child: Row(
//                                               children: const [
//                                                 Icon(
//                                                   Icons.more_vert,
//                                                   color: Color(0xfff444444),
//                                                 ),
//                                               ],
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     if (visibleCount < ExModel.dummyData.length)
//                       GestureDetector(
//                         onTap: _showMoreItems,
//                         child: CustomText(
//                           text: 'Show More',
//                           fontColor: const Color(0xff330320),
//                           fontSize: 18.sp,
//                           fontWeight: FontWeight.w600,
//                           fontFamily: "Chillax",
//                         ),
//                       ),
//                     SizedBox(
//                       height: 16.h,
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 35.h,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// void _showBottomMenu(BuildContext context) {
//   showModalBottomSheet(
//     isScrollControlled: true,
//     context: context,
//     backgroundColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return IntrinsicHeight(
//         child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(8),
//                 topRight: Radius.circular(8),
//               ),
//             ),
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Container(
//                           width: 48.w,
//                           height: 4.h,
//                           decoration:
//                               const BoxDecoration(color: Color(0xffD9D9D9)),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 40.h,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.asset("assets/icons/Hide Note.png"),
//                         SizedBox(
//                           width: 12.w,
//                         ),
//                         CustomText(
//                           text: 'Hide Note',
//                           fontColor: const Color(0xff444444),
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: "Poppins",
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 18.h,
//                     ),
//                     Container(
//                       height: 1.h,
//                       width: double.infinity.w,
//                       color: const Color(0xffE7E7E7),
//                     ),
//                     SizedBox(
//                       height: 18.h,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.asset("assets/icons/Save Note.png"),
//                         SizedBox(
//                           width: 12.w,
//                         ),
//                         CustomText(
//                           text: 'Save Note',
//                           fontColor: const Color(0xff444444),
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: "Poppins",
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 18.h,
//                     ),
//                     Container(
//                       height: 1.h,
//                       width: double.infinity.w,
//                       color: const Color(0xffE7E7E7),
//                     ),
//                     SizedBox(
//                       height: 18.h,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.asset("assets/icons/Follow.png"),
//                         SizedBox(
//                           width: 12.w,
//                         ),
//                         CustomText(
//                           text: 'Follow User',
//                           fontColor: const Color(0xff444444),
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: "Poppins",
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 18.h,
//                     ),
//                     Container(
//                       height: 1.h,
//                       width: double.infinity.w,
//                       color: const Color(0xffE7E7E7),
//                     ),
//                     SizedBox(
//                       height: 18.h,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.asset("assets/icons/Block.png"),
//                         SizedBox(
//                           width: 12.w,
//                         ),
//                         CustomText(
//                           text: 'Block User',
//                           fontColor: const Color(0xff444444),
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: "Poppins",
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 18.h,
//                     ),
//                     Container(
//                       height: 1.h,
//                       width: double.infinity.w,
//                       color: const Color(0xffE7E7E7),
//                     ),
//                     SizedBox(
//                       height: 18.h,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Image.asset("assets/icons/Report.png"),
//                         SizedBox(
//                           width: 12.w,
//                         ),
//                         CustomText(
//                           text: 'Report User',
//                           fontColor: const Color(0xffC80000),
//                           fontSize: 14.sp,
//                           fontWeight: FontWeight.w400,
//                           fontFamily: "Poppins",
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             )),
//       );
//     },
//   );
// }
