
import 'dart:async';

import 'package:chat/layout/chat.dart';
import 'package:chat/modules/login_screen/login_screen.dart';
import 'package:chat/modules/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hexcolor/hexcolor.dart';

class splashScreen extends StatefulWidget {

  late bool isLogin;
  late bool onBoarding;
  late bool isDark;

   splashScreen({
     required this.isLogin ,
     required this.onBoarding,
     required this.isDark,
   });

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {


  Timer? timer;
  void goTo()
  {
     timer= Timer(const Duration(seconds: 5), (){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget.onBoarding? widget.isLogin? chatLayout():loginScreen(): const onboardingScreen(),
        ),
       (route) => false
      );
     });
  }

  @override
  void initState() {
    goTo();
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor:widget.isDark?HexColor('23303F'):Colors.white,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:widget.isDark?HexColor('23303F'):Colors.white,
          statusBarIconBrightness: widget.isDark?Brightness.light: Brightness.dark,
        ),
      ),
      body: Container(
        width: double.infinity,
        color:widget.isDark?HexColor('23303F'):Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TweenAnimationBuilder(
                  duration: Duration(seconds: 3),
                  curve: Curves.bounceInOut,
                  tween: Tween<double>(begin: 40,end: 60),
                  builder: (context,double value,child)
                  {
                    return Text(
                      'Chatty',
                      style: TextStyle(
                        color:widget.isDark?Colors.white: Colors.teal,
                        fontSize: value,
                        fontFamily: 'Galada',
                      ),
                    );
                  },
                 // child: FlutterLogo(size: 200,)
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: SpinKitPouringHourGlass(
                color: widget.isDark?Colors.white :Colors.teal,
                duration: Duration(milliseconds: 1700),
                size: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
