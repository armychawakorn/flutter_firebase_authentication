import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_authentication/firebase_options.dart';
import 'package:flutter_authentication/views/create_account_screen.dart';
import 'package:flutter_authentication/views/forgot_password_screen.dart';
import 'package:flutter_authentication/views/home_screen.dart';
import 'package:flutter_authentication/views/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      routes: {
        '/login': (context) => LoginPage(),
        '/create_account': (context) => CreateAccountPage(),
        '/home': (context) => HomePage(),
        '/forgot_password': (context) => ForgotPasswordPage()
      },
    );
  }
}
