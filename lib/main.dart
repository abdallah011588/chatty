import 'package:chat/layout/chat.dart';
import 'package:chat/layout/cubit/cubit.dart';
import 'package:chat/layout/cubit/states.dart';
import 'package:chat/localization/localization_methods.dart';
import 'package:chat/localization/set_localization.dart';
import 'package:chat/modules/login_screen/login_screen.dart';
import 'package:chat/modules/onboarding/onboarding_screen.dart';
import 'package:chat/modules/setting_screen/setting_screen.dart';
import 'package:chat/modules/splash_screen/splash_screen.dart';
import 'package:chat/shared/constant/constants.dart';
import 'package:chat/shared/local/cache.dart';
import 'package:chat/shared/remote/dio_tool.dart';
import 'package:chat/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();
  Fluttertoast.showToast(
    msg: 'onBackgroundMessage => ${message.notification!.title}',
    backgroundColor: Colors.blue,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
  );
}



void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  var token = await messaging.getToken();
  print(token);

  FirebaseMessaging.onMessage.listen((event) {
    marker++;
    print(marker);
    Fluttertoast.showToast(
      msg:'${event.notification!.title.toString()} \n\n ${event.notification!.body.toString()}',
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    marker++;
    Fluttertoast.showToast(
      msg: 'onMessageOpenedApp'+ '${event.notification!.body.toString()}',
      backgroundColor: Colors.red,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  await cache.init();
  dioTool.init();
  bool IsLogin= cache.getBool(key: 'isLogin')==null? false:cache.getBool(key: 'isLogin');
  bool onBoarding= cache.getBool(key: 'onBoarding')==null? false:cache.getBool(key: 'onBoarding');
  bool isDark= cache.getBool(key: 'isdark')==null? false:cache.getBool(key: 'isdark');



  uId=cache.getString(key: 'uId').toString();

  print(cache.getString(key: 'uId').toString()+'from main');

  runApp( MyApp(IsLogin: IsLogin,onBoarding: onBoarding,isDark: isDark,));
}


class MyApp extends StatefulWidget {

  late bool IsLogin;
  late bool onBoarding;
  late bool isDark;

  MyApp({
    required this.IsLogin,
    required this.onBoarding,
    required this.isDark,

  });

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Locale? _local;
  void setLocale(Locale locale) {
    setState(() {
      _local = locale;
    });
  }
  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._local = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    if (_local == null) {
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else
    {
      return BlocProvider(
        create: (context) => appCubit()..getUserData()..getAllUsers()..changeAppMode(dataFromShared: widget.isDark),//..getRequests(),
        child: BlocConsumer<appCubit,appStates>(
          listener: (context, state) {},
          builder:(context, state) {

            return MaterialApp(
              title:'Chatty',
              home:splashScreen(
                isLogin:widget.IsLogin,
                onBoarding: widget.onBoarding,
                isDark: widget.isDark,
              ),// widget.onBoarding? widget.IsLogin? chatLayout():loginScreen(): onboardingScreen(),
              theme:lightTheme,
              darkTheme: darktheme,
              themeMode: appCubit.get(context).isdark?ThemeMode.dark: ThemeMode.light,
              debugShowCheckedModeBanner: false,


              locale: _local,
              supportedLocales: [
                Locale('en', 'US'),
                Locale('ar', 'EG')
              ],

              localizationsDelegates: [
                SetLocalization.localizationsDelegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (deviceLocal, supportedLocales)
              {
                for (var local in supportedLocales)
                {
                  if (local.languageCode == deviceLocal!.languageCode &&
                      local.countryCode == deviceLocal.countryCode)
                  {
                    return deviceLocal;
                  }
                }
                return supportedLocales.first;
              },


            );
          },
        ),
      );

    }

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