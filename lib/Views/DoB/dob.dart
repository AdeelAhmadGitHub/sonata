import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';

import '../../Controllers/auth_controller.dart';

class DateOfBirthDropdown extends StatefulWidget {
  const DateOfBirthDropdown({Key? key}) : super(key: key);

  @override
  _DateOfBirthDropdownState createState() => _DateOfBirthDropdownState();
}

class _DateOfBirthDropdownState extends State<DateOfBirthDropdown> {
  String _selectedMonth = 'Month';
  int selectedMonthInt = 1;
  int? selectedDay;
  int? _selectedYear;
  final auth = Get.put(AuthController());
  final List<String> _months = [
    'Month',
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
  final List<int> _days = [
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
  // final List<String> _days = [
  //   'Day',
  //   '1',
  //   '2',
  //   '3',
  //   '4',
  //   '5',
  //   '6',
  //   '7',
  //   '8',
  //   '9',
  //   '10',
  //   '11',
  //   '12',
  //   '13',
  //   '14',
  //   '15',
  //   '16',
  //   '17',
  //   '18',
  //   '19',
  //   '20',
  //   '21',
  //   '22',
  //   '23',
  //   '24',
  //   '25',
  //   '26',
  //   '27',
  //   '28',
  //   '29',
  //   '30',
  //   '31'
  // ];

  final List<int> _years = [2001, 2002, 2003];

  // final List<String> _years = [
  //   'Year',
  //   '2023',
  //   '2022',
  //   '2021',
  //   '2020',
  //   '2019',
  //   '2018',
  //   '2017',
  //   '2016',
  //   '2015',
  //   '2014',
  //   '2013',
  //   '2012',
  //   '2011',
  //   '2010',
  //   '2009',
  //   '2008',
  //   '2007',
  //   '2006',
  //   '2005',
  //   '2004',
  //   '2003',
  //   '2002',
  //   '2001',
  //   '2000'
  // ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFF7F3FF), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<int>(
            hint: CustomText(
              text: _selectedYear != null ? _selectedYear.toString() : "Year",
              fontColor: const Color(0xff767676),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
            ),
            elevation: 0,
            underline: Container(
              height: 0,
            ),
            menuMaxHeight: 150.h,
            dropdownColor: Colors.white,
            icon: const ImageIcon(
              AssetImage(
                "assets/icons/tabler_chevron-down.png",
              ),
            ),
            borderRadius: BorderRadius.circular(8),
            value: _selectedYear,
            items: _years.map((year) {
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
                _selectedYear = year;

                if (_selectedYear != null &&
                    selectedMonthInt != null &&
                    selectedDay != null) {
                  auth.dob = DateFormat("yyyy-MM-dd").format(
                      DateTime(_selectedYear!, selectedMonthInt, selectedDay!));
                }
              });
            },
          ),
        ),
        Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFF7F3FF), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            elevation: 0,
            underline: Container(
              height: 0,
            ),
            menuMaxHeight: 150.h,
            dropdownColor: Colors.white,
            icon: const ImageIcon(
              AssetImage(
                "assets/icons/tabler_chevron-down.png",
              ),
            ),
            borderRadius: BorderRadius.circular(8),
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
                _selectedMonth = month!;
                if (_selectedMonth != "Month") {
                  if (_selectedMonth == "January") {
                    selectedMonthInt = 1;
                  } else if (_selectedMonth == "February") {
                    selectedMonthInt = 2;
                  } else if (_selectedMonth == "February") {
                    selectedMonthInt = 2;
                  }
                }
              });
            },
          ),
        ),
        Container(
          height: 44.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFF7F3FF), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<int>(
            elevation: 0,
            hint: CustomText(
              text: "Day",
              fontColor: const Color(0xff767676),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              fontFamily: "Poppins",
            ),
            underline: Container(
              height: 0,
            ),
            menuMaxHeight: 150.h,
            dropdownColor: Colors.white,
            icon: const ImageIcon(
              AssetImage(
                "assets/icons/tabler_chevron-down.png",
              ),
            ),
            borderRadius: BorderRadius.circular(8),
            value: selectedDay,
            items: _days.map((day) {
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
                selectedDay = day!;
                auth.dob = DateFormat("yyyy-MM-dd").format(
                    DateTime(_selectedYear!, selectedMonthInt, selectedDay!));
              });
            },
          ),
        ),
      ],
    );
  }
}
