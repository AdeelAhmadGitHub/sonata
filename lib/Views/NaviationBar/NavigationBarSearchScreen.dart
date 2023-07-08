// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:sonata/Views/Discover/Discover.dart';
// import 'package:sonata/Views/Home/Home.dart';
// import 'package:sonata/Views/Notification/Notification.dart';
// import '../Create Notes/Create Notes.dart';
// import '../Create Profile/User Agreement.dart';
// import '../Explore Navigation/Explore Navigation.dart';
// import '../Search/Search.dart';
//
// class NavigationbarSearchScreen extends StatefulWidget {
//   const NavigationbarSearchScreen({Key? key}) : super(key: key);
//
//   @override
//   State<NavigationbarSearchScreen> createState() =>
//       _NavigationbarSearchScreenState();
// }
//
// class _NavigationbarSearchScreenState extends State<NavigationbarSearchScreen> {
//   @override
//   Widget build(BuildContext context) {
//     int _selectedIndex = 1;
//     final screen = [
//       const Home(),
//       const UserAgreement(),
//       const ExploreNavigation(),
//       const NotificationScreen(),
//     ];
//
//     void _onItemTapped(int index) {
//       setState(() {
//         _selectedIndex = index;
//       });
//     }
//
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       body: Center(
//         child: screen.elementAt(_selectedIndex),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: InkWell(
//         onTap: () {
//           Get.to(const CreateNotes());
//         },
//         child: Padding(
//           padding: EdgeInsets.only(top: 30.0.h),
//           child: SvgPicture.asset(
//             "assets/svg/Create Note.svg",
//           ),
//         ),
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             SizedBox(
//               height: 70.h,
//               child: BottomNavigationBar(
//                 elevation: 0,
//                 backgroundColor: Colors.white,
//                 unselectedItemColor: const Color(0xff3C0061),
//                 selectedItemColor: const Color(0xff3C0061),
//                 selectedFontSize: 0,
//                 unselectedFontSize: 0,
//                 items: <BottomNavigationBarItem>[
//                   BottomNavigationBarItem(
//                     icon: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset("assets/svg/Home.svg"),
//                         if (_selectedIndex == 0)
//                           Container(
//                             width: 35,
//                             height: 3.0,
//                             decoration: BoxDecoration(
//                               color: const Color(0xffFC5201),
//                               borderRadius: BorderRadius.circular(2.0),
//                             ),
//                           ),
//                       ],
//                     ),
//                     label: '',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Padding(
//                       padding: const EdgeInsets.only(right: 60.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset("assets/svg/Search Note.svg"),
//                           if (_selectedIndex == 1)
//                             Container(
//                               width: 35,
//                               height: 3.0,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xffFC5201),
//                                 borderRadius: BorderRadius.circular(2.0),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     label: '',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Padding(
//                       padding: const EdgeInsets.only(left: 60.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           SvgPicture.asset("assets/svg/Explore.svg"),
//                           if (_selectedIndex == 2)
//                             Container(
//                               width: 35,
//                               height: 3.0,
//                               decoration: BoxDecoration(
//                                 color: const Color(0xffFC5201),
//                                 borderRadius: BorderRadius.circular(2.0),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     label: '',
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         SvgPicture.asset("assets/svg/Notifications.svg"),
//                         if (_selectedIndex == 3)
//                           Container(
//                             width: 35,
//                             height: 3.0,
//                             decoration: BoxDecoration(
//                               color: const Color(0xffFC5201),
//                               borderRadius: BorderRadius.circular(2.0),
//                             ),
//                           ),
//                       ],
//                     ),
//                     label: '',
//                   ),
//                 ],
//                 type: BottomNavigationBarType.fixed,
//                 currentIndex: _selectedIndex,
//                 onTap: _onItemTapped,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
