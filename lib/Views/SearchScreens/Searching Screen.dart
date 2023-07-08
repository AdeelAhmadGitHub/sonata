// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sonata/Views/Widgets/custom_text.dart';
//
// import '../SideBar/SideBar.dart';
// class SearchingScreen extends StatefulWidget {
//   const SearchingScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SearchingScreen> createState() => _SearchingScreenState();
// }
//
// class _SearchingScreenState extends State<SearchingScreen> {
//   int visibleCount = 3;
//
//   void _showMoreItems() {
//     setState(() {
//       visibleCount += 3;
//     });
//   }
//
//   final TextEditingController search = TextEditingController();
//   bool _showClearIcon = false;
//
//   @override
//   void initState() {
//     super.initState();
//     search.addListener(_onTextChanged);
//   }
//
//   void _onTextChanged() {
//     setState(() {
//       _showClearIcon = search.text.isNotEmpty;
//     });
//   }
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
//               Container(
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(width: 1, color: const Color(0xffC6BEE3)),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.search, color: Color(0xff727272)),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: TextField(
//                         controller: search,
//                         decoration: const InputDecoration(
//                           hintText: 'Search for users',
//                           hintStyle: TextStyle(
//                             color: Color(0xff727272),
//                             fontWeight: FontWeight.w500,
//                             fontFamily: 'Poppins',
//                           ),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     if (_showClearIcon)
//                       IconButton(
//                         icon: const Icon(Icons.clear, color: Color(0xff727272)),
//                         onPressed: () {
//                           setState(() {
//                             search.clear();
//                             _showClearIcon = false;
//                           });
//                         },
//                       ),
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
//                                               //  _showBottomMenu(context);
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
//                                               //_showBottomMenu(context);
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
//
//   @override
//   void dispose() {
//     search.dispose();
//     super.dispose();
//   }
// }
