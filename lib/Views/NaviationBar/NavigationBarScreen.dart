import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sonata/Views/Home/Home.dart';
import 'package:sonata/Views/Notification/Notification.dart';
import '../Create Notes/Create Notes.dart';
import '../Explore Navigation/Explore Navigation.dart';
import '../Search/Search.dart';
import '../SideBar/SideBar.dart';
bool navigateHome=false;
class NavigationBarScreen extends StatefulWidget {
  const NavigationBarScreen({Key? key}) : super(key: key);

  @override
  State<NavigationBarScreen> createState() => _NavigationBarScreenState();
}

class _NavigationBarScreenState extends State<NavigationBarScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: InkWell(
        onTap: () {
          Get.to(const CreateNotes());
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 22.0),
          child: SvgPicture.asset(
            "assets/svg/Create Note.svg",
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: MediaQuery.of(context)
                .size
                .height, // Adjust the height as desired
            child: CupertinoTabScaffold(
              resizeToAvoidBottomInset: false,
              tabBar: CupertinoTabBar(
                onTap: _onItemTapped,
                height: 70,
                backgroundColor: Colors.white,
                border: Border.all(width: 0, color: Colors.white),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 19.0),
                          child: SvgPicture.asset("assets/svg/Home.svg"),
                        ),
                        if (_selectedIndex == 0)
                          Container(
                            width: 35,
                            height: 3.0,
                            decoration: BoxDecoration(
                              color: const Color(0xffFC5201),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                      ],
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 60.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 19.0),
                            child:
                                SvgPicture.asset("assets/svg/Search Note.svg"),
                          ),
                          if (_selectedIndex == 1)
                            Container(
                              width: 35,
                              height: 3.0,
                              decoration: BoxDecoration(
                                color: const Color(0xffFC5201),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                            ),
                        ],
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 60.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 19.0),
                            child: SvgPicture.asset("assets/svg/Explore.svg"),
                          ),
                          if (_selectedIndex == 2)
                            Container(
                              width: 35,
                              height: 3.0,
                              decoration: BoxDecoration(
                                color: const Color(0xffFC5201),
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                            ),
                        ],
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 19.0),
                          child:
                              SvgPicture.asset("assets/svg/Notifications.svg"),
                        ),
                        if (_selectedIndex == 3)
                          Container(
                            width: 35,
                            height: 3.0,
                            decoration: BoxDecoration(
                              color: const Color(0xffFC5201),
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                      ],
                    ),
                    label: '',
                  ),
                ],
              ),
              tabBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return CupertinoTabView(
                      builder: (context) {
                        print("????????????????????????????????${navigateHome}");
                        return const CupertinoPageScaffold(child: Home());
                      },
                    );
                  case 1:
                    return CupertinoTabView(
                      builder: (context) {
                        return const CupertinoPageScaffold(child: Search());
                      },
                    );
                  case 2:
                    return CupertinoTabView(
                      builder: (context) {
                        return const CupertinoPageScaffold(
                            child: ExploreNavigation());
                      },
                    );
                  case 3:
                    return CupertinoTabView(
                      builder: (context) {
                        return const CupertinoPageScaffold(
                            child: NotificationScreen());
                      },
                    );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}
