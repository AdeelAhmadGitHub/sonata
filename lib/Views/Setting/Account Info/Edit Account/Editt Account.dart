import 'dart:async';
import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sonata/Views/DoB/Date%20Of%20Birth.dart';

import '../../../../../Controllers/auth_controller.dart';
import '../../../../Controllers/Upload Image.dart';
import '../../../NaviationBar/NavigationBarScreen.dart';
import '../../../SideBar/SideBar.dart';
import '../../../Widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
class EditAccount extends StatefulWidget {
  const EditAccount({Key? key}) : super(key: key);

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  static const CameraPosition initialCameraPosition =
  CameraPosition(target: LatLng(31.4626664,74.2701121), zoom: 14.0);
  Set<Marker> markersList = {};
  GoogleMapController? googleMapController;
  var edit = Get.put(UploadProfileController());
  int? selectedMonthInt;
  String? _selectedMonth;
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  int datetime = DateTime.now().month;
  int? selectedDay;
  int? selectedYear;
  final List<int> years = List<int>.generate(123, (i) => 1901 + i);

  List<int> days = [
    01,
    02,
    03,
    04,
    05,
    06,
    07,
    08,
    09,
    10,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31
  ];
  String? selectedValue;
  void searchAddress( String address) async {
    if (address.isNotEmpty) {
      List locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        // Retrieve the latitude and longitude coordinates
        double latitude = locations[0].lat;
        double longitude = locations[0].lng;
        setState(() {});
        googleMapController != null?
        googleMapController?.animateCamera(CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 14.0)):null;


        // Perform further operations with the coordinates
        // For example, display the location on a map
      } else {
        // Handle the case when no locations are found for the entered address
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Address Not Found'),
            content: Text('The entered address could not be found.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void updateDaysList(int month) {
    if (month == 2) {
      days = List<int>.generate(28, (index) => index + 1);
    } else if (month == 4 || month == 6 || month == 9 || month == 11) {
      days = List<int>.generate(30, (index) => index + 1);
    } else {
      days = List<int>.generate(31, (index) => index + 1);
    }
  }

  TextEditingController nameCont = TextEditingController(text: "");
  TextEditingController emailCont = TextEditingController(text: "");
  TextEditingController confirmPassCont = TextEditingController(text: "");
  TextEditingController userHandle = TextEditingController(text: '');
  TextEditingController locationCont = TextEditingController(text: "");

  var auth = Get.find<AuthController>();
  @override
  void initState() {
    super.initState();
    edit.editNameCont.text = auth.profileModel?.userName ?? "";
    userHandle.text = auth.profileModel?.userHandle ?? "";
    locationCont.text = auth.profileModel?.profileLocation ?? "";
    datetime = DateTime.now().month;

    if (auth.profileModel != null && auth.profileModel?.dateOfBirth != null) {
      final DateFormat dateFormat = DateFormat("MMMM d, yyyy");
      DateTime dob = dateFormat.parse(auth.profileModel!.dateOfBirth!);
      selectedMonthInt = dob.month;
      _selectedMonth = _months[selectedMonthInt! - 1];
      selectedDay = dob.day;
      selectedYear = dob.year;
    } else {
      selectedMonthInt = datetime;
      _selectedMonth = 'Month';
    }

    updateDaysList(datetime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      backgroundColor: const Color(0xffE3E3E3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(right: 12.0, left: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Get.to(const NavigationBarScreen());
                },
                child: SvgPicture.asset(
                  "assets/svg/Sonata_Logo_Main_RGB.svg",
                ),
              ),
              Builder(
                builder: (BuildContext context) => InkWell(
                  onTap: () {
                    Scaffold.of(context).openDrawer();
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: auth.user?.profileImage != null
                          ? Image.network(
                              String.fromCharCodes(
                                  base64Decode(auth.user?.profileImage ?? "")),
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                print('Error loading image: $exception');
                                return SvgPicture.asset(
                                  "assets/svg/UserProfile.svg",
                                );
                              },
                            )
                          : SvgPicture.asset(
                              "assets/svg/UserProfile.svg",
                              height: 50,
                              width: 50,
                            ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Icons.arrow_back)),
                  SizedBox(
                    width: 20.w,
                  ),
                  CustomText(
                    text: 'Back to Your Account',
                    fontColor: const Color(0xff160323),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                ],
              ),
              SizedBox(
                height: 16.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(width: 1, color: const Color(0xffF3EEF9))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.pencil,
                          color: Color(0xfffFD5201),
                          size: 25,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        CustomText(
                          text: 'Edit Account Information',
                          fontColor: const Color(0xff160323),
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffF6F5FB)),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      text: 'Handle',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Chillax",
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      height: 44.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffFBFBFB),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            text: '@${auth.profileModel?.userHandle}',
                            fontColor: const Color(0xff868686),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      text: 'Name',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Chillax",
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFD),
                        border: Border.all(
                            width: 1, color: const Color(0xffC6BEE3)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: edit.editNameCont,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintStyle: TextStyle(
                              color: const Color(0xff8E8694),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      text: 'Date of Birth',
                      fontColor: const Color(0xff444444),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Chillax",
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    // DropdownButtonHideUnderline(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       DropdownButton2<String>(
                    //         hint: CustomText(
                    //           text: selectedMonthInt != null
                    //               ? selectedMonthInt.toString()
                    //               : "Month",
                    //           fontColor: const Color(0xff767676),
                    //           fontSize: 16.sp,
                    //           fontWeight: FontWeight.w400,
                    //           fontFamily: "Poppins",
                    //         ),
                    //         value: _selectedMonth,
                    //         items: _months.map((String month) {
                    //           return DropdownMenuItem<String>(
                    //             value: month,
                    //             child: CustomText(
                    //               text: month,
                    //               fontColor: const Color(0xff767676),
                    //               fontSize: 15.sp,
                    //               fontWeight: FontWeight.w400,
                    //               fontFamily: "Poppins",
                    //             ),
                    //           );
                    //         }).toList(),
                    //         onChanged: (String? month) {
                    //           setState(() {
                    //             _selectedMonth = month;
                    //             if (_selectedMonth != null &&
                    //                 _selectedMonth != "Month") {
                    //               if (_selectedMonth == "January") {
                    //                 selectedMonthInt = 1;
                    //               } else if (_selectedMonth == "February") {
                    //                 selectedMonthInt = 2;
                    //               } else if (_selectedMonth == "March") {
                    //                 selectedMonthInt = 3;
                    //               } else if (_selectedMonth == "April") {
                    //                 selectedMonthInt = 4;
                    //               } else if (_selectedMonth == "May") {
                    //                 selectedMonthInt = 5;
                    //               } else if (_selectedMonth == "June") {
                    //                 selectedMonthInt = 6;
                    //               } else if (_selectedMonth == "July") {
                    //                 selectedMonthInt = 7;
                    //               }
                    //             } else if (_selectedMonth == "August") {
                    //               selectedMonthInt = 8;
                    //             } else if (_selectedMonth == "September") {
                    //               selectedMonthInt = 9;
                    //             } else if (_selectedMonth == "October") {
                    //               selectedMonthInt = 10;
                    //             } else if (_selectedMonth == "November") {
                    //               selectedMonthInt = 11;
                    //             } else if (_selectedMonth == "December") {
                    //               selectedMonthInt = 12;
                    //             }
                    //             if (_selectedMonth != null &&
                    //                 _selectedMonth != "Month") {
                    //               selectedMonthInt =
                    //                   _months.indexOf(_selectedMonth!) + 1;
                    //               updateDaysList(selectedMonthInt!);
                    //             }
                    //           });
                    //         },
                    //         buttonStyleData: ButtonStyleData(
                    //           height: 44.h,
                    //           //// width: 125.w,
                    //           padding: const EdgeInsets.only(left: 9, right: 9),
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             border: Border.all(
                    //               width: 2,
                    //               color: const Color(0xfffF7F3FF),
                    //             ),
                    //             color: Colors.transparent,
                    //           ),
                    //           elevation: 0,
                    //         ),
                    //         iconStyleData: const IconStyleData(
                    //           icon: ImageIcon(
                    //             AssetImage(
                    //                 "assets/icons/tabler_chevron-down.png"),
                    //           ),
                    //           iconSize: 20,
                    //           iconEnabledColor: Color(0xfff444444),
                    //           iconDisabledColor: Colors.red,
                    //         ),
                    //         dropdownStyleData: DropdownStyleData(
                    //           maxHeight: 156.h,
                    //           width: 125.w,
                    //           padding: null,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             border: Border.all(
                    //               width: 2,
                    //               color: const Color(0xfffF7F3FF),
                    //             ),
                    //             color: Colors.white,
                    //           ),
                    //           elevation: 0,
                    //           offset: const Offset(0, -10),
                    //           scrollbarTheme: ScrollbarThemeData(
                    //             radius: const Radius.circular(8),
                    //             thickness: MaterialStateProperty.all<double>(4),
                    //             thumbVisibility:
                    //                 MaterialStateProperty.all<bool>(true),
                    //           ),
                    //         ),
                    //         menuItemStyleData: const MenuItemStyleData(
                    //           height: 40,
                    //           //padding: EdgeInsets.only(left: 14, right: 14),
                    //         ),
                    //       ),
                    //       DropdownButton2<int>(
                    //         hint: CustomText(
                    //           text: selectedDay != null
                    //               ? selectedDay.toString()
                    //               : "Days",
                    //           fontColor: const Color(0xff767676),
                    //           fontSize: 16.sp,
                    //           fontWeight: FontWeight.w400,
                    //           fontFamily: "Poppins",
                    //         ),
                    //         value: selectedDay,
                    //         items: days.map((day) {
                    //           return DropdownMenuItem<int>(
                    //             value: day,
                    //             child: CustomText(
                    //               text: day.toString(),
                    //               fontColor: const Color(0xff767676),
                    //               fontSize: 16.sp,
                    //               fontWeight: FontWeight.w400,
                    //               fontFamily: "Poppins",
                    //             ),
                    //           );
                    //         }).toList(),
                    //         onChanged: (day) {
                    //           setState(() {
                    //             selectedDay = day;
                    //             if (selectedYear != null &&
                    //                 selectedMonthInt != null &&
                    //                 selectedDay != null) {
                    //               edit.dob = DateFormat("yyyy-MM-dd").format(
                    //                   DateTime(selectedYear!, selectedMonthInt!,
                    //                       selectedDay!));
                    //             }
                    //           });
                    //         },
                    //         buttonStyleData: ButtonStyleData(
                    //           height: 44.h,
                    //           //width: 88.w,
                    //           padding: const EdgeInsets.only(left: 9, right: 9),
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             border: Border.all(
                    //               width: 2,
                    //               color: const Color(0xfffF7F3FF),
                    //             ),
                    //             color: Colors.transparent,
                    //           ),
                    //           elevation: 0,
                    //         ),
                    //         iconStyleData: const IconStyleData(
                    //           icon: ImageIcon(
                    //             AssetImage(
                    //                 "assets/icons/tabler_chevron-down.png"),
                    //           ),
                    //           iconSize: 20,
                    //           iconEnabledColor: Color(0xfff444444),
                    //           iconDisabledColor: Colors.red,
                    //         ),
                    //         dropdownStyleData: DropdownStyleData(
                    //           maxHeight: 156.h,
                    //           width: 88.w,
                    //           padding: null,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             border: Border.all(
                    //               width: 2,
                    //               color: const Color(0xfffF7F3FF),
                    //             ),
                    //             color: Colors.white,
                    //           ),
                    //           elevation: 0,
                    //           offset: const Offset(0, -10),
                    //           scrollbarTheme: ScrollbarThemeData(
                    //             radius: const Radius.circular(8),
                    //             thickness: MaterialStateProperty.all<double>(4),
                    //             thumbVisibility:
                    //                 MaterialStateProperty.all<bool>(true),
                    //           ),
                    //         ),
                    //         menuItemStyleData: const MenuItemStyleData(
                    //           height: 40,
                    //           //padding: EdgeInsets.only(left: 14, right: 14),
                    //         ),
                    //       ),
                    //       DropdownButton2<int>(
                    //         hint: CustomText(
                    //           text: selectedYear != null
                    //               ? selectedYear.toString()
                    //               : "Year",
                    //           fontColor: const Color(0xff767676),
                    //           fontSize: 16.sp,
                    //           fontWeight: FontWeight.w400,
                    //           fontFamily: "Poppins",
                    //         ),
                    //         underline: Container(
                    //           height: 0,
                    //         ),
                    //         value: selectedYear,
                    //         items: years.map((year) {
                    //           return DropdownMenuItem<int>(
                    //             value: year,
                    //             child: CustomText(
                    //               text: year.toString(),
                    //               fontColor: const Color(0xff767676),
                    //               fontSize: 16.sp,
                    //               fontWeight: FontWeight.w400,
                    //               fontFamily: "Poppins",
                    //             ),
                    //           );
                    //         }).toList(),
                    //         onChanged: (year) {
                    //           setState(() {
                    //             selectedYear = year;
                    //
                    //             if (selectedYear != null &&
                    //                 selectedMonthInt != null &&
                    //                 selectedDay != null) {
                    //               edit.dob = DateFormat("yyyy-MM-dd").format(
                    //                   DateTime(selectedYear!, selectedMonthInt!,
                    //                       selectedDay!));
                    //             }
                    //           });
                    //         },
                    //         buttonStyleData: ButtonStyleData(
                    //           height: 44.h,
                    //           // width: 80.w,
                    //           padding: const EdgeInsets.only(left: 9, right: 9),
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             border: Border.all(
                    //               width: 2,
                    //               color: const Color(
                    //                 0xfffF7F3FF,
                    //               ),
                    //             ),
                    //             color: Colors.transparent,
                    //           ),
                    //           elevation: 0,
                    //         ),
                    //         iconStyleData: const IconStyleData(
                    //           icon: ImageIcon(
                    //             AssetImage(
                    //                 "assets/icons/tabler_chevron-down.png"),
                    //           ),
                    //           iconSize: 20,
                    //           iconEnabledColor: Color(0xfff444444),
                    //           iconDisabledColor: Colors.red,
                    //         ),
                    //         dropdownStyleData: DropdownStyleData(
                    //           maxHeight: 156.h,
                    //           width: 80.w,
                    //           padding: null,
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(8),
                    //             border: Border.all(
                    //               width: 2,
                    //               color: const Color(0xfffF7F3FF),
                    //             ),
                    //             color: Colors.white,
                    //           ),
                    //           elevation: 0,
                    //           offset: const Offset(0, -10),
                    //           scrollbarTheme: ScrollbarThemeData(
                    //             radius: const Radius.circular(8),
                    //             thickness: MaterialStateProperty.all<double>(4),
                    //             thumbVisibility:
                    //                 MaterialStateProperty.all<bool>(true),
                    //           ),
                    //         ),
                    //         menuItemStyleData: const MenuItemStyleData(
                    //           height: 40,
                    //           //padding: EdgeInsets.only(left: 14, right: 14),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(
                      height: 20.h,
                    ),
                    // CustomText(
                    //   text: 'Location',
                    //   fontColor: const Color(0xff444444),
                    //   fontSize: 16.sp,
                    //   fontWeight: FontWeight.w600,
                    //   fontFamily: "Chillax",
                    // ),
                    // SizedBox(
                    //   height: 6.h,
                    // ),
                    Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFD),
                        border: Border.all(
                            width: 1, color: const Color(0xffC6BEE3)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: locationCont,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintText: 'null',
                          hintStyle: TextStyle(
                              color: const Color(0xff8E8694),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100.h,
                    ),
                    Container(
                        height: 1.h,
                        width: double.infinity.w,
                        color: const Color(0xffF6F5FB)),
                    SizedBox(
                      height: 16.h,
                    ),
                    Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: const Color(0xffFAFAFD),
                        border: Border.all(
                            width: 1, color: const Color(0xffC6BEE3)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextFormField(
                        controller: edit.editLocation,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          contentPadding:
                          const EdgeInsets.fromLTRB(16, 10, 16, 10),
                          hintStyle: TextStyle(
                              color: const Color(0xff8E8694),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              fontStyle: FontStyle.italic),
                          border: InputBorder.none,
                        ),
                        onChanged: (value){
                          searchAddress(value);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    SizedBox(
                      height: 200.h,
               width: double.infinity,
                      child: GoogleMap(
                        mapToolbarEnabled: true,
                        initialCameraPosition: initialCameraPosition,
                        markers: markersList,
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller) {
                          googleMapController=controller;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44.h,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF3C0061),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: 'Cancel',
                                    fontColor: const Color(0xff3C0061),
                                    fontSize: 14.sp,
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
                                edit.editAccountInfo();
                                _showSavesChanges(context);
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xFF3C0061),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 10.0, 12.0, 10.0),
                              ),
                              child: CustomText(
                                text: 'Save Changes',
                                fontColor: const Color(0xffFFFFFF),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSavesChanges(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/ic-save.png"),
                  CustomText(
                    text: 'Changes have been saved ',
                    fontColor: const Color(0xff3C0061),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ));
      },
    );
  }
}
