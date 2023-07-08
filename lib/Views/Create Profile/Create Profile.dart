import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:sonata/Controllers/auth_controller.dart';
import 'package:sonata/Views/User%20Agreement/User%20Agreement.dart';
import 'package:sonata/Views/DoB/dob.dart';
import 'package:sonata/Views/Widgets/CustomButton.dart';
import 'package:sonata/Views/Widgets/custom_text.dart';
import 'package:flutter/services.dart';
import '../DoB/Date Of Birth.dart';
import '../Explore(Without Login)/Explore.dart';

class CreateProfile extends StatefulWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final auth = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  FocusNode _nameFocusNode = FocusNode();
  FocusNode _handleFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  bool _showNameValidationError = false;
  bool _showHandleValidationError = false;
  bool _showEmailValidationError = false;
  bool _showNameAlphabetsValidationError = false;
  bool _nameLengthValidationError = false;
  bool _handleLengthValidationError = false;
  bool _showHandleError = false;
  bool _showErrorHandle = false;
  bool _showErrorEmail = false;
  bool _showFormatErrorEmail = false;
  bool _showMonthError = false;
  bool _showDayError = false;
  bool _showYearError = false;

  // @override
  // void dispose() {
  //   auth.nameCont.dispose();
  //   super.dispose();
  // }
  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_onFocusChange);
    _handleFocusNode.addListener(_onFocusChange);
    _emailFocusNode.addListener(_onFocusChange);
    datetime = DateTime.now().month;
    selectedMonthInt = null; // Set the selected month to null initially

    updateDaysList(datetime);

    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.removeListener(_onFocusChange);
    _handleFocusNode.removeListener(_onFocusChange);
    _emailFocusNode.removeListener(_onFocusChange);

    super.dispose();
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _validate() {
    setState(() {
      _showNameValidationError = auth.nameCont.text.isEmpty;
      _showHandleValidationError = auth.userHandle.text.isEmpty;
      _showEmailValidationError = auth.emailCont.text.isEmpty;
      _nameLengthValidationError = auth.nameCont.text.length < 4;
      _showHandleError = !_hasAlphabetHadle(auth.userHandle.text);
      _showNameAlphabetsValidationError = !_hasAlphabets(auth.nameCont.text);
      _handleLengthValidationError = auth.userHandle.text.length < 4;
      _showFormatErrorEmail = !_hasGmailHandle(auth.emailCont.text);
      _showMonthError = _selectedMonth == null || _selectedMonth == "Month";
      _showDayError = selectedDay == null || selectedDay == 0;
      _showYearError = selectedYear == null;
    });
  }

  bool _hasAlphabets(String text) {
    RegExp regex = RegExp(r'^[a-zA-Z ]+$');
    return regex.hasMatch(text);
  }

  bool _hasAlphabetHadle(String text) {
    RegExp regex = RegExp(r'^[a-z0-9_]+$');
    return regex.hasMatch(text);
  }

  bool _hasGmailHandle(String text) {
    RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@gmail.com$');
    return regex.hasMatch(text);
  }

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
  // final auth = Get.put(AuthController());
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
  // void initState() {
  //   datetime = DateTime.now().month;
  //   selectedMonthInt = null; // Set the selected month to null initially
  //
  //   updateDaysList(datetime);
  //
  //   super.initState();
  // }

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 34.h,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(const Explore());
                  },
                  child: Center(
                    child: SvgPicture.asset("assets/svg/Sonata_Logo_Main_.svg"),
                  ),
                ),
                SizedBox(
                  height: 24.h,
                ),
                CustomText(
                  text: 'Lets get you started',
                  fontColor: const Color(0xff3C0061),
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Chillax",
                ),
                SizedBox(
                  height: 40.h,
                ),
                Center(
                    child:
                        Image.asset("assets/images/create profile image.png")),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Container(
                    width: double.infinity.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(60, 0, 97, 0.08),
                          blurRadius: 12,
                          offset: Offset(0, 0),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 44,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFF6F5FB),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                    "assets/svg/Create Profile.svg"),
                                const SizedBox(
                                  width: 9,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 2.0.h),
                                  child: CustomText(
                                    text: 'Create Profile',
                                    fontColor: const Color(0xff160323),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Chillax",
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: 'Name',
                                fontColor: const Color(0xff444444),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheetName(context);
                                },
                                child: const Icon(
                                  Icons.privacy_tip_outlined,
                                  color: Color(0xff3C0061),
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Container(
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: _nameFocusNode.hasFocus
                                  ? Colors.white
                                  : const Color(0xffFAFAFD),
                              border: Border.all(
                                width: 1,
                                color: (_nameFocusNode.hasFocus
                                    ? const Color(0xff3C0061)
                                    : const Color(0xffC6BEE3)),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextFormField(
                              focusNode: _nameFocusNode,
                              controller: auth.nameCont,
                              cursorColor: const Color(0xff3C0061),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                hintText: 'Enter your name',
                                hintStyle: TextStyle(
                                    color: (_nameFocusNode.hasFocus
                                        ? const Color(0xffBBBBBB)
                                        : const Color(0xff727272)),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.italic),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _showNameValidationError = false;
                                  _showNameAlphabetsValidationError = false;
                                  // RegExp regex = RegExp(r'^[a-zA-Z ]+$');
                                  // _showNameAlphabetsValidationError =
                                  //     !regex.hasMatch(value);
                                  _nameLengthValidationError = false;
                                });
                              },
                              validator: (value) {
                                if (_showNameValidationError &&
                                    value!.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          if (_showNameValidationError)
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/error.svg",
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Name is Required',
                                    style: TextStyle(
                                      color: const Color(0xffDA0000),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: '@handle',
                                fontColor: const Color(0xff444444),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheetHandle(context);
                                },
                                child: const Icon(
                                  Icons.privacy_tip_outlined,
                                  color: Color(0xff3C0061),
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Container(
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: _handleFocusNode.hasFocus
                                  ? Colors.white
                                  : const Color(0xffFAFAFD),
                              border: Border.all(
                                width: 1,
                                color: _showHandleValidationError
                                    ? const Color(0xffDA0000)
                                    : (_handleFocusNode.hasFocus
                                        ? const Color(0xff3C0061)
                                        : const Color(0xffC6BEE3)),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextFormField(
                              controller: auth.userHandle,
                              focusNode: _handleFocusNode,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                // Block spaces
                              ],
                              cursorColor: const Color(0xff3C0061),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                hintText: 'Create a handle',
                                hintStyle: TextStyle(
                                    color: (_handleFocusNode.hasFocus
                                        ? const Color(0xffBBBBBB)
                                        : const Color(0xff727272)),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.italic),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _showHandleValidationError = false;
                                  _showHandleError = false;
                                  //   RegExp regex = RegExp(r'^[a-z0-9_]+$');
                                  //   _showHandleMailleValidationError =
                                  //       !regex.hasMatch(value);
                                  _handleLengthValidationError = false;
                                });
                              },
                              validator: (value) {
                                if (_showHandleValidationError &&
                                    value!.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          if (_showHandleValidationError)
                            Row(
                              children: [
                                Image.asset(
                                  "assets/icons/incorrect password.png",
                                  height: 18,
                                  width: 20,
                                ),
                                const SizedBox(width: 8),
                                const Flexible(
                                  child: Text(
                                    'Handle is Required',
                                    style: TextStyle(
                                      color: Color(0xffDA0000),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Visibility(
                              visible: _showErrorHandle,
                              child: Row(
                                children: [
                                  Center(
                                    child: Image.asset(
                                      "assets/icons/incorrect password.png",
                                      height: 18.h,
                                      width: 20.w,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  CustomText(
                                    text: 'handle is not unique',
                                    fontColor: const Color(0xffDA0000),
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Poppins",
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: 'Email',
                                fontColor: const Color(0xff444444),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheetEmail(context);
                                },
                                child: const Icon(
                                  Icons.privacy_tip_outlined,
                                  color: Color(0xff3C0061),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Container(
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: _emailFocusNode.hasFocus
                                  ? Colors.white
                                  : const Color(0xffFAFAFD),
                              border: Border.all(
                                color: (_emailFocusNode.hasFocus
                                    ? const Color(0xff3C0061)
                                    : const Color(0xffC6BEE3)),
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: TextFormField(
                              controller: auth.emailCont,
                              focusNode: _emailFocusNode,
                              cursorColor: const Color(0xff3C0061),
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(16, 10, 16, 10),
                                hintText: 'Enter your email address here',
                                hintStyle: TextStyle(
                                    color: (_emailFocusNode.hasFocus
                                        ? const Color(0xffBBBBBB)
                                        : const Color(0xff727272)),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontStyle: FontStyle.italic),
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _showEmailValidationError = false;
                                  _showFormatErrorEmail = false;
                                });
                              },
                              validator: (value) {
                                if (_showEmailValidationError &&
                                    value!.isEmpty) {
                                  return 'Email is Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          if (_showEmailValidationError)
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/error.svg",
                                ),
                                const SizedBox(width: 8),
                                const Flexible(
                                  child: Text(
                                    'Email is Required',
                                    style: TextStyle(
                                      color: Color(0xffDA0000),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10.h,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child: Visibility(
                          //     visible: _showErrorEmail,
                          //     child: Row(
                          //       children: [
                          //         Center(
                          //           child: Image.asset(
                          //             "assets/icons/incorrect password.png",
                          //             height: 18.h,
                          //             width: 20.w,
                          //           ),
                          //         ),
                          //         SizedBox(width: 8.w),
                          //         CustomText(
                          //           text: 'Email already in use',
                          //           fontColor: const Color(0xffDA0000),
                          //           fontSize: 16.sp,
                          //           fontWeight: FontWeight.w400,
                          //           fontFamily: "Poppins",
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),

                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                text: 'Date of Birth',
                                fontColor: const Color(0xff444444),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Chillax",
                              ),
                              GestureDetector(
                                onTap: () {
                                  _showBottomSheetDateofBirth(context);
                                },
                                child: const Icon(
                                  Icons.privacy_tip_outlined,
                                  color: Color(0xff3C0061),
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          DropdownButtonHideUnderline(
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
                                      if (_selectedMonth != null &&
                                          _selectedMonth != "Month") {
                                        if (_selectedMonth == "January") {
                                          selectedMonthInt = 1;
                                        } else if (_selectedMonth ==
                                            "February") {
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
                                      } else if (_selectedMonth ==
                                          "September") {
                                        selectedMonthInt = 9;
                                      } else if (_selectedMonth == "October") {
                                        selectedMonthInt = 10;
                                      } else if (_selectedMonth == "November") {
                                        selectedMonthInt = 11;
                                      } else if (_selectedMonth == "December") {
                                        selectedMonthInt = 12;
                                      }
                                      if (_selectedMonth != null &&
                                          _selectedMonth != "Month") {
                                        selectedMonthInt =
                                            _months.indexOf(_selectedMonth!) +
                                                1;
                                        updateDaysList(selectedMonthInt!);
                                      }
                                      _showMonthError = false;
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 44.h,
                                    //// width: 125.w,
                                    padding: const EdgeInsets.only(
                                        left: 9, right: 9),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          width: 2,
                                          color: const Color(0xfffF7F3FF)),
                                      color: Colors.transparent,
                                    ),
                                    elevation: 0,
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: ImageIcon(
                                      AssetImage(
                                          "assets/icons/tabler_chevron-down.png"),
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
                                      thickness:
                                          MaterialStateProperty.all<double>(4),
                                      thumbVisibility:
                                          MaterialStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    //padding: EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                                DropdownButton2<int>(
                                  hint: CustomText(
                                    text: selectedDay != null
                                        ? selectedDay.toString()
                                        : "Days",
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
                                      _showDayError == false;
                                      if (selectedYear != null &&
                                          selectedMonthInt != null &&
                                          selectedDay != null) {
                                        auth.dob = DateFormat("yyyy-MM-dd")
                                            .format(DateTime(
                                                selectedYear!,
                                                selectedMonthInt!,
                                                selectedDay!));
                                      }
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 44.h,
                                    //width: 88.w,
                                    padding: const EdgeInsets.only(
                                        left: 9, right: 9),
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
                                      AssetImage(
                                          "assets/icons/tabler_chevron-down.png"),
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
                                      thickness:
                                          MaterialStateProperty.all<double>(4),
                                      thumbVisibility:
                                          MaterialStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 40,
                                    //padding: EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                                DropdownButton2<int>(
                                  hint: CustomText(
                                    text: selectedYear != null
                                        ? selectedYear.toString()
                                        : "Year",
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
                                      _showYearError = false;
                                      selectedYear = year;

                                      if (selectedYear != null &&
                                          selectedMonthInt != null &&
                                          selectedDay != null) {
                                        auth.dob = DateFormat("yyyy-MM-dd")
                                            .format(DateTime(
                                                selectedYear!,
                                                selectedMonthInt!,
                                                selectedDay!));
                                      }
                                    });
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    height: 44.h,
                                    // width: 80.w,
                                    padding: const EdgeInsets.only(
                                        left: 9, right: 9),
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
                                      AssetImage(
                                          "assets/icons/tabler_chevron-down.png"),
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
                                      thickness:
                                          MaterialStateProperty.all<double>(4),
                                      thumbVisibility:
                                          MaterialStateProperty.all<bool>(true),
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
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Visibility(
                              visible: _showHandleError,
                              child: Column(
                                children: [
                                  AnimatedOpacity(
                                    opacity: _showHandleError ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: SizedBox(height: 8),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(200, 0, 0, 0.06),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Center(
                                          child: SvgPicture.asset(
                                            "assets/svg/error.svg",
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: CustomText(
                                            text: 'Handle must consist of only small letters, underscores and numbers',
                                            fontColor: const Color(0xffDA0000),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Visibility(
                              visible: _showNameAlphabetsValidationError,
                              child:Column(
                                children: [
                                  AnimatedOpacity(
                                    opacity: _showNameAlphabetsValidationError ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: SizedBox(height: 8),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(200, 0, 0, 0.06),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child:Row(
                                      children: [
                                        Center(
                                          child: SvgPicture.asset(
                                            "assets/svg/error.svg",
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: CustomText(
                                            text: 'Name can only contain alphabets',
                                            fontColor: const Color(0xffDA0000),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),




                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Visibility(
                              visible: _nameLengthValidationError,
                              child: Column(
                                children: [
                                  AnimatedOpacity(
                                    opacity: _nameLengthValidationError ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: SizedBox(height: 8),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(200, 0, 0, 0.06),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child:  Row(
                                      children: [
                                        Center(
                                          child: SvgPicture.asset(
                                            "assets/svg/error.svg",
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: CustomText(
                                            text:
                                            'Name must be greater than 4 characters',
                                            fontColor: const Color(0xffDA0000),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),



                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Visibility(
                              visible: _handleLengthValidationError,
                              child: Column(
                                children: [
                                  AnimatedOpacity(
                                    opacity: _handleLengthValidationError ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: SizedBox(height: 8),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(200, 0, 0, 0.06),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Center(
                                          child: SvgPicture.asset(
                                            "assets/svg/error.svg",
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: CustomText(
                                            text:
                                            'Handle must be at least 4 characters',
                                            fontColor: const Color(0xffDA0000),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Visibility(
                              visible: _showFormatErrorEmail,
                              child:Column(
                                children: [
                                  AnimatedOpacity(
                                    opacity: _showFormatErrorEmail ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: SizedBox(height: 8),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(200, 0, 0, 0.06),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child:Row(
                                      children: [
                                        Center(
                                          child: SvgPicture.asset(
                                            "assets/svg/error.svg",
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: CustomText(
                                            text: 'Invalid email address',
                                            fontColor: const Color(0xffDA0000),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),



                          Obx(() => Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 5),
                                child: Visibility(
                                  visible: auth.showEmailError.value,
                                  child:Column(
                                    children: [
                                      AnimatedOpacity(
                                        opacity: auth.showEmailError.value ? 1.0 : 0.0,
                                        duration: const Duration(milliseconds: 200),
                                        child: SizedBox(height: 8),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(200, 0, 0, 0.06),
                                          borderRadius: BorderRadius.circular(6.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Center(
                                              child: SvgPicture.asset(
                                                "assets/svg/error.svg",
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: CustomText(
                                                text: 'Email already in use',
                                                fontColor: const Color(0xffDA0000),
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Poppins",
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          Obx(() => Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 5),
                                child: Visibility(
                                  visible: auth.showHandleError.value,
                                  child: Column(
                                    children: [
                                      AnimatedOpacity(
                                        opacity: auth.showHandleError.value ? 1.0 : 0.0,
                                        duration: const Duration(milliseconds: 200),
                                        child: SizedBox(height: 8),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(200, 0, 0, 0.06),
                                          borderRadius: BorderRadius.circular(6.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Center(
                                              child: SvgPicture.asset(
                                                "assets/svg/error.svg",
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: CustomText(
                                                text: "Handle is not unique",
                                                fontColor: const Color(0xffDA0000),
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Poppins",
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),

                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Visibility(
                              visible: _showMonthError,
                              child: Column(
                                children: [
                                  AnimatedOpacity(
                                    opacity: _showMonthError ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: SizedBox(height: 8),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(200, 0, 0, 0.06),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child:Row(
                                      children: [
                                        Center(
                                          child: SvgPicture.asset(
                                            "assets/svg/error.svg",
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: CustomText(
                                            text: 'Month is required',
                                            fontColor: const Color(0xffDA0000),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Visibility(
                              visible: _showDayError,
                              child:Column(
                                children: [
                                  AnimatedOpacity(
                                    opacity: _showDayError ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: SizedBox(height: 8),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(200, 0, 0, 0.06),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Center(
                                          child: SvgPicture.asset(
                                            "assets/svg/error.svg",
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: CustomText(
                                            text: 'Day is required',
                                            fontColor: const Color(0xffDA0000),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 5),
                            child: Visibility(
                              visible: _showYearError,
                              child:Column(
                                children: [
                                  AnimatedOpacity(
                                    opacity: _showYearError ? 1.0 : 0.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: SizedBox(height: 8),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(200, 0, 0, 0.06),
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child:Row(
                                      children: [
                                        Center(
                                          child: SvgPicture.asset(
                                            "assets/svg/error.svg",
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Flexible(
                                          child: CustomText(
                                            text: 'Year is required',
                                            fontColor: const Color(0xffDA0000),
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Poppins",
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Container(
                            height: 1.h,
                            width: double.infinity.w,
                            color: const Color(0xffF6F5FB),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          CustomButton(
                              height: 48.h,
                              borderRadius: 8,
                              buttonColor: const Color(0xff3C0061),
                              width: double.infinity,
                              text: "Continue",
                              textColor: const Color(0xffFFFFFF),
                              textSize: 16.sp,
                              textFontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                              onPressed: () async {
                                _validate();
                                if (_showNameValidationError) {
                                  setState(() {
                                    _showNameValidationError = true;
                                    _nameLengthValidationError = false;
                                    _showNameAlphabetsValidationError = false;
                                    _showHandleError = false;
                                    _showHandleValidationError = false;
                                    _showEmailValidationError = false;
                                    _handleLengthValidationError = false;
                                    _showFormatErrorEmail = false;
                                    _showMonthError = false;
                                    _showDayError = false;
                                    _showYearError = false;
                                  });
                                  return;
                                }
                                if (_nameLengthValidationError) {
                                  setState(() {
                                    _showNameValidationError = false;
                                    _showNameAlphabetsValidationError = false;
                                    _nameLengthValidationError = true;
                                    _showHandleValidationError = false;
                                    _showHandleError = false;
                                    _showEmailValidationError = false;
                                    _handleLengthValidationError = false;
                                    _showFormatErrorEmail = false;
                                    _showMonthError = false;
                                    _showDayError = false;
                                    _showYearError = false;
                                  });
                                  return;
                                }
                                if (_showNameAlphabetsValidationError) {
                                  setState(() {
                                    _showNameAlphabetsValidationError = true;
                                    _showNameValidationError = false;
                                    _nameLengthValidationError = false;
                                    _showHandleValidationError = false;
                                    _showHandleError = false;
                                    _showEmailValidationError = false;
                                    _handleLengthValidationError = false;
                                    _showFormatErrorEmail = false;
                                    _showMonthError = false;
                                    _showDayError = false;
                                    _showYearError = false;
                                  });
                                  return;
                                }

                                if (_showHandleValidationError) {
                                  setState(() {
                                    _showNameValidationError = false;
                                    _nameLengthValidationError = false;
                                    _showNameAlphabetsValidationError = false;
                                    _showHandleValidationError = true;
                                    _showHandleError = false;
                                    _showEmailValidationError = false;
                                    _handleLengthValidationError = false;
                                    _showFormatErrorEmail = false;
                                    _showMonthError = false;
                                    _showDayError = false;
                                    _showYearError = false;
                                  });
                                  return;
                                }
                                if (_showHandleError) {
                                  setState(() {
                                    _showNameValidationError = false;
                                    _nameLengthValidationError = false;
                                    _showNameAlphabetsValidationError = false;
                                    _showHandleValidationError = false;
                                    _showHandleError = true;
                                    _showEmailValidationError = false;
                                    _handleLengthValidationError = false;
                                    _showFormatErrorEmail = false;
                                    _showMonthError = false;
                                    _showDayError = false;
                                    _showYearError = false;
                                  });
                                  return;
                                }
                                if (_handleLengthValidationError) {
                                  setState(() {
                                    _showNameValidationError = false;
                                    _nameLengthValidationError = false;
                                    _showNameAlphabetsValidationError = false;
                                    _showHandleValidationError = false;
                                    _showHandleError = false;
                                    _showEmailValidationError = false;
                                    _handleLengthValidationError = true;
                                    _showFormatErrorEmail = false;
                                    _showMonthError = false;
                                    _showDayError = false;
                                    _showYearError = false;
                                  });
                                  return;
                                }
                                if (_showEmailValidationError) {
                                  setState(() {
                                    _showNameValidationError = false;
                                    _nameLengthValidationError = false;
                                    _showNameAlphabetsValidationError = false;
                                    _showHandleValidationError = false;
                                    _showHandleError = false;
                                    _showEmailValidationError = true;
                                    _handleLengthValidationError = false;
                                    _showFormatErrorEmail = false;
                                    _showMonthError = false;
                                    _showDayError = false;
                                    _showYearError = false;
                                  });
                                  return;
                                }
                                if (_showFormatErrorEmail) {
                                  setState(() {
                                    _showNameValidationError = false;
                                    _nameLengthValidationError = false;
                                    _showNameAlphabetsValidationError = false;
                                    _showHandleValidationError = false;
                                    _showHandleError = false;
                                    _showEmailValidationError = false;
                                    _handleLengthValidationError = false;
                                    _showFormatErrorEmail = true;
                                    _showMonthError = false;
                                    _showDayError = false;
                                    _showYearError = false;
                                  });
                                  return;
                                }
                                if (_showMonthError) {
                                  setState(() {
                                    _showNameValidationError = false;
                                    _nameLengthValidationError = false;
                                    _showNameAlphabetsValidationError = false;
                                    _showHandleValidationError = false;
                                    _showHandleError = false;
                                    _showEmailValidationError = false;
                                    _handleLengthValidationError = false;
                                    _showFormatErrorEmail = false;
                                    _showMonthError = true;
                                    _showDayError = false;
                                    _showYearError = false;
                                  });
                                  return;
                                }
                                if (_showDayError) {
                                  setState(() {
                                    _showNameValidationError = false;
                                    _nameLengthValidationError = false;
                                    _showNameAlphabetsValidationError = false;
                                    _showHandleValidationError = false;
                                    _showHandleError = false;
                                    _showEmailValidationError = false;
                                    _handleLengthValidationError = false;
                                    _showFormatErrorEmail = false;
                                    _showMonthError = false;
                                    _showDayError = true;
                                    _showYearError = false;
                                  });
                                  return;
                                }
                                if (_showYearError) {
                                  setState(() {
                                    _showNameValidationError = false;
                                    _nameLengthValidationError = false;
                                    _showNameAlphabetsValidationError = false;
                                    _showHandleValidationError = false;
                                    _showHandleError = false;
                                    _showEmailValidationError = false;
                                    _handleLengthValidationError = false;
                                    _showFormatErrorEmail = false;
                                    _showMonthError = false;
                                    _showDayError = false;
                                    _showYearError = true;
                                  });
                                  return;
                                }
                                try {
                                  await auth.registerUserAuth();
                                } catch (error) {
                                  // Handle error
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _showBottomSheetEmail(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return IntrinsicHeight(
        child: Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 44,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF6F5FB),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.privacy_tip_outlined,
                              color: Color(0xffFD5201),
                              size: 20,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            CustomText(
                              text: 'Privacy Info - Email',
                              fontColor: const Color(0xff160323),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          ],
                        ),
                        CustomText(
                          text: 'View All',
                          fontColor: const Color(0xff3C0061),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Used For:',
                    fontColor: const Color(0xff444444),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      CustomText(
                        text: 'Contacting you',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustomText(
                        text: 'Recovering your account',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Shared with:',
                    fontColor: const Color(0xff444444),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      CustomText(
                        text: 'None',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Stored for:',
                    fontColor: const Color(0xff444444),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      CustomText(
                        text: 'As long as you have a Sonata account',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Your Options:',
                    fontColor: const Color(0xff444444),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  CustomText(
                    text:
                        '(We do not currently have any alternative\n options. If you wish to use Sonata, you must\n supply an email address for us to keep)',
                    fontColor: const Color(0xff767676),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    height: 42.h,
                    borderRadius: (8),
                    buttonColor: const Color(0xff3C0061),
                    width: double.infinity,
                    text: "Okay",
                    textColor: const Color(0xffFFFFFF),
                    textSize: 16.sp,
                    textFontWeight: FontWeight.w500,
                    fontFamily: "Chillax",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            )),
      );
    },
  );
}

void _showBottomSheetDateofBirth(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return IntrinsicHeight(
        child: Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 44,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF6F5FB),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.privacy_tip_outlined,
                              color: Color(0xffFD5201),
                              size: 20,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            CustomText(
                              text: 'Privacy Info - Date of Birth',
                              fontColor: const Color(0xff160323),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          ],
                        ),
                        CustomText(
                          text: 'View All',
                          fontColor: const Color(0xff3C0061),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Used For:',
                    fontColor: const Color(0xff444444),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      CustomText(
                        text: 'Contacting you',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustomText(
                        text: 'Recovering your account',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Shared with:',
                    fontColor: const Color(0xff444444),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      CustomText(
                        text: 'None',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Stored for:',
                    fontColor: const Color(0xff444444),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      CustomText(
                        text: 'As long as you have a Sonata account',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Your Options:',
                    fontColor: const Color(0xff444444),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  CustomText(
                    text:
                        '(We do not currently have any alternative\n options. If you wish to use Sonata, you must\n supply an email address for us to keep)',
                    fontColor: const Color(0xff767676),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    height: 42.h,
                    borderRadius: (8),
                    buttonColor: const Color(0xff3C0061),
                    width: double.infinity,
                    text: "Okay",
                    textColor: const Color(0xffFFFFFF),
                    textSize: 16.sp,
                    textFontWeight: FontWeight.w500,
                    fontFamily: "Chillax",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            )),
      );
    },
  );
}

void _showBottomSheetHandle(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return IntrinsicHeight(
        child: Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 44,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF6F5FB),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.privacy_tip_outlined,
                              color: Color(0xffFD5201),
                              size: 20,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            CustomText(
                              text: 'Privacy Info - Handle',
                              fontColor: const Color(0xff160323),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          ],
                        ),
                        CustomText(
                          text: 'View All',
                          fontColor: const Color(0xff3C0061),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Used For:',
                    fontColor: const Color(0xff444444),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      CustomText(
                        text: 'Contacting you',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustomText(
                        text: 'Recovering your account',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Shared with:',
                    fontColor: const Color(0xff444444),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      CustomText(
                        text: 'None',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Stored for:',
                    fontColor: const Color(0xff444444),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      CustomText(
                        text: 'As long as you have a Sonata account',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Your Options:',
                    fontColor: const Color(0xff444444),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  CustomText(
                    text:
                        '(We do not currently have any alternative\n options. If you wish to use Sonata, you must\n supply an email address for us to keep)',
                    fontColor: const Color(0xff767676),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    height: 42.h,
                    borderRadius: (8),
                    buttonColor: const Color(0xff3C0061),
                    width: double.infinity,
                    text: "Okay",
                    textColor: const Color(0xffFFFFFF),
                    textSize: 16.sp,
                    textFontWeight: FontWeight.w500,
                    fontFamily: "Chillax",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            )),
      );
    },
  );
}

void _showBottomSheetName(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return IntrinsicHeight(
        child: Container(
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 44,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFF6F5FB),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.privacy_tip_outlined,
                              color: Color(0xffFD5201),
                              size: 20,
                            ),
                            SizedBox(
                              width: 8.w,
                            ),
                            CustomText(
                              text: 'Privacy Info - Name',
                              fontColor: const Color(0xff160323),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Chillax",
                            ),
                          ],
                        ),
                        CustomText(
                          text: 'View All',
                          fontColor: const Color(0xff3C0061),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Chillax",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Used For:',
                    fontColor: const Color(0xff444444),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      CustomText(
                        text: 'Contacting you',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      CustomText(
                        text: 'Recovering your account',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Shared with:',
                    fontColor: const Color(0xff444444),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      CustomText(
                        text: 'None',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Stored for:',
                    fontColor: const Color(0xff444444),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 12),
                        child: Container(
                          height: 4.h,
                          width: 4.w,
                          decoration: BoxDecoration(
                              color: const Color(0xff444444),
                              borderRadius: BorderRadius.circular(50)),
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      CustomText(
                        text: 'As long as you have a Sonata account',
                        fontColor: const Color(0xff444444),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomText(
                    text: 'Your Options:',
                    fontColor: const Color(0xff444444),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Poppins",
                  ),
                  CustomText(
                    text:
                        '(We do not currently have any alternative\n options. If you wish to use Sonata, you must\n supply an email address for us to keep)',
                    fontColor: const Color(0xff767676),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Poppins",
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    height: 42.h,
                    borderRadius: (8),
                    buttonColor: const Color(0xff3C0061),
                    width: double.infinity,
                    text: "Okay",
                    textColor: const Color(0xffFFFFFF),
                    textSize: 16.sp,
                    textFontWeight: FontWeight.w500,
                    fontFamily: "Chillax",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ),
            )),
      );
    },
  );
}
