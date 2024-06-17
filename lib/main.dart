import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:smart_counter/pages/pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_counter/providers/providers.dart';
import 'package:smart_counter/services/services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const AppState(),
  );
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
      ],
      child: const MyApp(),
    );
  }
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
        'home': (context) => const HomePage(),
        'login': (context) => const LoginPage(),
        'register': (context) => const RegisterPage(),
        'profile': (context) => const ProfilePage(),
        'history': (context) => const HistoryPage(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: Color.fromRGBO(195, 151, 229, 1),
        ),
      ),
    );
  }
}
