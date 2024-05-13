import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:progmob_app/forgotpasswordpage.dart';
import 'package:progmob_app/homepage.dart';
import 'package:progmob_app/loginpage.dart';
import 'package:progmob_app/profilepage.dart';
import 'package:progmob_app/registerpage.dart';
import 'package:progmob_app/welcomepage.dart';
import 'package:progmob_app/addanggotapage.dart';
import 'package:progmob_app/EditAnggotaPage.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(MainApp());
}
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => WelcomePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/forgotpassword': (context) => ForgotPasswordPage(),
        '/profile': (context) => ProfilePage(),
        '/addanggota': (context) => AddAnggotaPage(),
        '/editanggota': (context) => EditAnggotaPage(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
    );
  }
}
