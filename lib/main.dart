import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sonata/Views/Create%20Profile/Create%20Profile.dart';
import 'Controllers/auth_controller.dart';
import 'Views/Explore(Without Login)/Explore.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final authCont = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
          // home: const CreateProfile(),
            home: FutureBuilder(
              future: authCont.checkUserLoggedIn(),
              builder: (context, AsyncSnapshot snapshot) {
                return snapshot.data;
              },
              initialData: const Explore(),
            ),
          );
        });
  }
}
