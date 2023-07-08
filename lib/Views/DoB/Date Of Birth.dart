import 'dart:ffi';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Controllers/auth_controller.dart';
import '../Widgets/custom_text.dart';

class DateOfBirth extends StatefulWidget {
  const DateOfBirth({Key? key}) : super(key: key);

  @override
  State<DateOfBirth> createState() => _DateOfBirthState();
}

class _DateOfBirthState extends State<DateOfBirth> {
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
  final auth = Get.put(AuthController());
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
  @override
  void initState() {
    datetime = DateTime.now().month;
    selectedMonthInt = null; // Set the selected month to null initially

    updateDaysList(datetime);

    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DropdownButtonHideUnderline(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton2<String>(
              hint: CustomText(
                text: selectedMonthInt != null
                    ? selectedMonthInt.toString()
                    : "Month",
                fontColor: const Color(0xff767676),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
              ),
              value: _selectedMonth,
              items: _months.map((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: CustomText(
                    text: month,
                    fontColor: const Color(0xff767676),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                  ),
                );
              }).toList(),
              onChanged: (String? month) {
                setState(() {
                  _selectedMonth = month;
                  if (_selectedMonth != null && _selectedMonth != "Month") {
                    if (_selectedMonth == "January") {
                      selectedMonthInt = 1;
                    } else if (_selectedMonth == "February") {
                      selectedMonthInt = 2;
                    } else if (_selectedMonth == "March") {
                      selectedMonthInt = 3;
                    } else if (_selectedMonth == "April") {
                      selectedMonthInt = 4;
                    } else if (_selectedMonth == "May") {
                      selectedMonthInt = 5;
                    } else if (_selectedMonth == "June") {
                      selectedMonthInt = 6;
                    } else if (_selectedMonth == "July") {
                      selectedMonthInt = 7;
                    }
                  } else if (_selectedMonth == "August") {
                    selectedMonthInt = 8;
                  } else if (_selectedMonth == "September") {
                    selectedMonthInt = 9;
                  } else if (_selectedMonth == "October") {
                    selectedMonthInt = 10;
                  } else if (_selectedMonth == "November") {
                    selectedMonthInt = 11;
                  } else if (_selectedMonth == "December") {
                    selectedMonthInt = 12;
                  }
                  if (_selectedMonth != null && _selectedMonth != "Month") {
                    selectedMonthInt = _months.indexOf(_selectedMonth!) + 1;
                    updateDaysList(selectedMonthInt!);
                  }
                });
              },
              buttonStyleData: ButtonStyleData(
                height: 44.h,
                //// width: 125.w,
                padding: const EdgeInsets.only(left: 9, right: 9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 2,
                    color: const Color(0xfffF7F3FF),
                  ),
                  color: Colors.transparent,
                ),
                elevation: 0,
              ),
              iconStyleData: const IconStyleData(
                icon: ImageIcon(
                  AssetImage("assets/icons/tabler_chevron-down.png"),
                ),
                iconSize: 20,
                iconEnabledColor: Color(0xfff444444),
                iconDisabledColor: Colors.red,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 156.h,
                width: 125.w,
                padding: null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 2,
                    color: const Color(0xfffF7F3FF),
                  ),
                  color: Colors.white,
                ),
                elevation: 0,
                offset: const Offset(0, -10),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(8),
                  thickness: MaterialStateProperty.all<double>(4),
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                //padding: EdgeInsets.only(left: 14, right: 14),
              ),
            ),
            DropdownButton2<int>(
              hint: CustomText(
                text: selectedDay != null ? selectedDay.toString() : "Days",
                fontColor: const Color(0xff767676),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
              ),
              value: selectedDay,
              items: days.map((day) {
                return DropdownMenuItem<int>(
                  value: day,
                  child: CustomText(
                    text: day.toString(),
                    fontColor: const Color(0xff767676),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                  ),
                );
              }).toList(),
              onChanged: (day) {
                setState(() {
                  selectedDay = day;
                  if (selectedYear != null &&
                      selectedMonthInt != null &&
                      selectedDay != null) {
                    auth.dob = DateFormat("yyyy-MM-dd").format(DateTime(
                        selectedYear!, selectedMonthInt!, selectedDay!));
                  }
                });
              },
              buttonStyleData: ButtonStyleData(
                height: 44.h,
                //width: 88.w,
                padding: const EdgeInsets.only(left: 9, right: 9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 2,
                    color: const Color(0xfffF7F3FF),
                  ),
                  color: Colors.transparent,
                ),
                elevation: 0,
              ),
              iconStyleData: const IconStyleData(
                icon: ImageIcon(
                  AssetImage("assets/icons/tabler_chevron-down.png"),
                ),
                iconSize: 20,
                iconEnabledColor: Color(0xfff444444),
                iconDisabledColor: Colors.red,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 156.h,
                width: 88.w,
                padding: null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 2,
                    color: const Color(0xfffF7F3FF),
                  ),
                  color: Colors.white,
                ),
                elevation: 0,
                offset: const Offset(0, -10),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(8),
                  thickness: MaterialStateProperty.all<double>(4),
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                //padding: EdgeInsets.only(left: 14, right: 14),
              ),
            ),
            DropdownButton2<int>(
              hint: CustomText(
                text: selectedYear != null ? selectedYear.toString() : "Year",
                fontColor: const Color(0xff767676),
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                fontFamily: "Poppins",
              ),
              underline: Container(
                height: 0,
              ),
              value: selectedYear,
              items: years.map((year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: CustomText(
                    text: year.toString(),
                    fontColor: const Color(0xff767676),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                  ),
                );
              }).toList(),
              onChanged: (year) {
                setState(() {
                  selectedYear = year;

                  if (selectedYear != null &&
                      selectedMonthInt != null &&
                      selectedDay != null) {
                    auth.dob = DateFormat("yyyy-MM-dd").format(DateTime(
                        selectedYear!, selectedMonthInt!, selectedDay!));
                  }
                });
              },
              buttonStyleData: ButtonStyleData(
                height: 44.h,
                // width: 80.w,
                padding: const EdgeInsets.only(left: 9, right: 9),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 2,
                    color: const Color(
                      0xfffF7F3FF,
                    ),
                  ),
                  color: Colors.transparent,
                ),
                elevation: 0,
              ),
              iconStyleData: const IconStyleData(
                icon: ImageIcon(
                  AssetImage("assets/icons/tabler_chevron-down.png"),
                ),
                iconSize: 20,
                iconEnabledColor: Color(0xfff444444),
                iconDisabledColor: Colors.red,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 156.h,
                width: 80.w,
                padding: null,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 2,
                    color: const Color(0xfffF7F3FF),
                  ),
                  color: Colors.white,
                ),
                elevation: 0,
                offset: const Offset(0, -10),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(8),
                  thickness: MaterialStateProperty.all<double>(4),
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                //padding: EdgeInsets.only(left: 14, right: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
