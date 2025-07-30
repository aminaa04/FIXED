import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen_page/Provider/UserProvider.dart';
import 'package:screen_page/Screeen/User_empl_screen/HomeUser.dart';
import 'package:screen_page/Screeen/auth_screen/Login.dart';
import 'package:screen_page/Screeen/auth_screen/Otpscreen.dart';
import 'package:screen_page/Screeen/auth_screen/SignUpScreen.dart';
import 'package:screen_page/Screeen/auth_screen/WelcomePage%20.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder:
          (context) => MultiProvider(
            providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
            child: MyApp(),
          ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true, // 🔥 Required for DevicePreview
      locale: DevicePreview.locale(context), // 🔥 Required
      builder: DevicePreview.appBuilder, // 🔥 Required
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(elevation: 0),
        sliderTheme: const SliderThemeData(trackHeight: 4),
      ),
      home: Login(),
    );
  }
}
