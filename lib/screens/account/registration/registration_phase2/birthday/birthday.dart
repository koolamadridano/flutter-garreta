import 'package:flutter/material.dart';
import 'package:garreta/controllers/garretaApiServiceController/garretaApiServiceController.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:garreta/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:jiffy/jiffy.dart';
import 'package:get/get.dart';

class SelectBirthday extends StatefulWidget {
  const SelectBirthday({Key key}) : super(key: key);

  @override
  _SelectBirthdayState createState() => _SelectBirthdayState();
}

class _SelectBirthdayState extends State<SelectBirthday> {
  // Global state
  final _userController = Get.put(UserController());

  // State
  var selectedDateToString = "Select birthday";

  @override
  void initState() {
    super.initState();
    // Validate if birthday existed in memory
    if (_userController.birthday != null) {
      setState(() => selectedDateToString = _userController.displayBirthday);
    }
  }

  _onSelectBirthdate({@required year, @required month, @required day}) {
    // Date format  YYYY-MM-DD
    _userController.birthday = "$year-$month-$day";
    _userController.displayBirthday = Jiffy([year, month, day]).yMMMMd;

    setState(() => selectedDateToString = Jiffy([year, month, day]).yMMMMd);
    // January 19, 2021
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          theme: _datePickerTheme,
          minTime: DateTime(1900, 1, 1),
          maxTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
          onChanged: (date) {},
          onConfirm: (date) => _onSelectBirthdate(year: date.year, month: date.month, day: date.day),
          currentTime: DateTime.now(),
          locale: LocaleType.en,
        );
      },
      child: Container(
        margin: EdgeInsets.only(left: 5),
        child: Row(
          children: [
            Text(selectedDateToString.toString(), style: _selectBirthdayTextStyle),
            SizedBox(width: 5),
            Icon(LineIcons.birthdayCake, color: primary, size: 21),
          ],
        ),
      ),
    );
  }
}

DatePickerTheme _datePickerTheme = DatePickerTheme(
  containerHeight: 250,
  itemStyle: GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w300,
  ),
);
TextStyle _selectBirthdayTextStyle = GoogleFonts.roboto(
  fontSize: 16,
  fontWeight: FontWeight.w300,
  color: primary,
);
