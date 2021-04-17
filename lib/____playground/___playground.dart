import 'package:flutter/material.dart';
import 'package:garreta/controllers/login/loginController.dart';
import 'package:get/get.dart';

class ScreenPlayground extends StatefulWidget {
  ScreenPlayground({Key key}) : super(key: key);

  @override
  _ScreenPlaygroundState createState() => _ScreenPlaygroundState();
}

class _ScreenPlaygroundState extends State<ScreenPlayground> {
  final _loginControllerState = Get.find<LoginController>();
  final _loginController = Get.put(LoginController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(_loginControllerState.userId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Text("${_loginControllerState.loginSuccess}"),
            ],
          ),
        ),
      ),
    );
  }
}
