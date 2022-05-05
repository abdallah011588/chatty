
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

ThemeData lightTheme=ThemeData(

  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: Colors.teal,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.teal,
    ),
  ),

  textTheme: TextTheme(
    subtitle2: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14.0,
      color: Colors.white,
      height: 1.3,
    ),
    headline1: TextStyle(
      fontSize: 16.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,

    ),
    headline2: TextStyle(
      fontSize: 14.0,
      color: Colors.grey[600],
    ),
    headline3: TextStyle(
      fontSize: 14.0,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      fontSize: 14.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),


  ),

);

ThemeData darktheme=ThemeData(

  scaffoldBackgroundColor: HexColor('1B242F'),

  dialogBackgroundColor: HexColor('212D3B'),
  dialogTheme: DialogTheme(
    backgroundColor: HexColor('212D3B'),
    titleTextStyle: TextStyle(color: Colors.white,fontSize: 14.0,fontWeight: FontWeight.bold),
  ),

  appBarTheme: AppBarTheme(
    titleSpacing: 20.0,
    backgroundColor:  HexColor('23303F'),
    elevation: 0.0,
    titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold
    ),

    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: HexColor('23303F'),
      statusBarIconBrightness: Brightness.light,
    ),

    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),

  floatingActionButtonTheme:  FloatingActionButtonThemeData(
              backgroundColor: Colors.deepOrange,
            ),

  textTheme: TextTheme(
    bodyText1: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: Colors.white
    ),
    subtitle1: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.0,
      color: Colors.white,
    ),
    subtitle2: TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14.0,
      color: Colors.white,
      height: 1.3,
    ),
    headline1: TextStyle(
      fontSize: 16.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,

    ),
    headline2: TextStyle(
      fontSize: 14.0,
      color: Colors.grey[400],
    ),
    headline3: TextStyle(
      fontSize: 14.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    headline4: TextStyle(
      fontSize: 14.0,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),


  ),

  drawerTheme: DrawerThemeData(
    backgroundColor:  HexColor('1B242F'),
   // scrimColor: Colors.red,
  ),
 // backgroundColor: HexColor('1B242F'),


);
