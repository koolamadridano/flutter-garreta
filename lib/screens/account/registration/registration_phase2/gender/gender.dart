import 'package:flutter/material.dart';
import 'package:garreta/controllers/user/userController.dart';
import 'package:menu_button/menu_button.dart';
import 'package:get/get.dart';

String selectedKey;
List<String> keys = <String>[
  'Male',
  'Female',
  'Rather not to say',
];

class SelectGender extends StatefulWidget {
  const SelectGender({Key key}) : super(key: key);
  @override
  _SelectGenderState createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  // Global state
  final _userController = Get.put(UserController());

  void _onSelectGender(String value) {
    setState(() => selectedKey = value);
    _userController.gender = value;
  }

  @override
  Widget build(BuildContext context) {
    String selectedKey = _userController.gender != null ? _userController.gender : "Gender";
    final Widget normalChildButton = SizedBox(
      width: double.infinity,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(child: Text(selectedKey, overflow: TextOverflow.ellipsis)),
            const SizedBox(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.arrow_drop_down_outlined,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return MenuButton<String>(
      child: normalChildButton,
      items: keys,
      itemBuilder: (String value) => Container(
        height: 50,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
        child: Text(value),
      ),
      toggledChild: Container(
        child: normalChildButton,
      ),
      onItemSelected: (String value) => _onSelectGender(value),
      onMenuButtonToggle: (bool isToggle) {},
    );
  }
}
