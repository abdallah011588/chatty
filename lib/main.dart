import 'package:chat/layout/chat.dart';
import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/modules/login_screen/login_screen.dart';
import 'package:chat/modules/onboarding/onboarding_screen.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/local/cache.dart';
import 'package:chat/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await cache.init();

  bool IsLogin= cache.getBool(key: 'isLogin')==null? false:cache.getBool(key: 'isLogin');
  bool onBoarding= cache.getBool(key: 'onBoarding')==null? false:cache.getBool(key: 'onBoarding');
  bool isDark= cache.getBool(key: 'isdark')==null? false:cache.getBool(key: 'isdark');



  uId=cache.getString(key: 'uId').toString();

  print(cache.getString(key: 'uId').toString()+'from main');

  runApp( MyApp(IsLogin: IsLogin,onBoarding: onBoarding,isDark: isDark,));
}


class MyApp extends StatelessWidget {
  //const MyApp({Key? key}) : super(key: key);

  late bool IsLogin;
  late bool onBoarding;
  late bool isDark;

  MyApp({
    required this.IsLogin,
    required this.onBoarding,
    required this.isDark,

  });

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => appCubit()..getUserData()..getAllUsers()..changeAppMode(dataFromShared: isDark),//..getRequests(),
      child: BlocConsumer<appCubit,appStates>(
        listener: (context, state) {},
        builder:(context, state) {
          return MaterialApp(
            title: 'Chaty',
            home: onBoarding? IsLogin? chatLayout():loginScreen(): onboardingScreen(),
            theme:lightTheme,
            darkTheme: darktheme,
            themeMode: appCubit.get(context).isdark?ThemeMode.dark: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            //const MyHomePage(title: 'Flutter Demo Home Page'),
          );
        },
      ),
    );
  }
}



















// 59:2C:8F:B4:8E:97:60:56:07:EB:64:3F:0C:3D:14:82:6B:CF:27:14


/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

*/