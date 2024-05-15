import 'package:flutter/material.dart';
import 'package:smart_counter/pages/pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Counter',
      initialRoute: 'login',
      debugShowCheckedModeBanner: false,
      routes: {
        //  'checking': (context) => const CheckAuthScreen(),
        //  'home': (context) => const HomeScreen(),
        'login': (context) => const LoginPage(),
        //  'product': (context) => const ProductScreen(),
        //  'register': (context) => const RegisterScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Colors.orangeAccent,
        ),
      ),
      home: const LoginPage(),
    );
  }
}
