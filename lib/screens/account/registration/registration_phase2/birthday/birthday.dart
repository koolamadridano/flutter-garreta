import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:garreta/controllers/registration/registrationController.dart';
import 'package:garreta/utils/colors/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';

class SelectBirthday extends StatefulWidget {
  const SelectBirthday({Key key}) : super(key: key);

  @override
  _SelectBirthdayState createState() => _SelectBirthdayState();
}

class _SelectBirthdayState extends State<SelectBirthday> {
  // Global state
  final _registrationController = Get.put(RegistrationController());

  // State
  var selectedDateToString = "Select birthday";

  @override
  void initState() {
    super.initState();
    // @desc - validate if birthday existed in memory
    if (_registrationController.customerBirthday != null) {
      setState(() {
        selectedDateToString = _registrationController.labelBirthday;
      });
    }
  }

  _onSelectBirthdate({@required year, @required month, @required day}) {
    //(NOTE: format is YYYY-MM-DD)
    _registrationController.customerBirthday = "$year-$month-$day";
    _registrationController.labelBirthday = Jiffy([year, month, day]).yMMMMd;
    setState(() {
      selectedDateToString = Jiffy([year, month, day]).yMMMMd;
    });
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
            Icon(LineIcons.birthdayCake, color: darkGray, size: 21),
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
  color: darkGray,
);
