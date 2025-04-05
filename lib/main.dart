import 'package:ecoquest/loading.dart';
import 'package:ecoquest/login.dart';
import 'package:ecoquest/qrScanner.dart';
import 'package:ecoquest/welcome.dart';
import 'package:ecoquest/register.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecoquest/verification.dart';
import 'package:ecoquest/map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://xqgmvnldsdgbkryvwdpt.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhxZ212bmxkc2RnYmtyeXZ3ZHB0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk4MTA3NTIsImV4cCI6MjA1NTM4Njc1Mn0.uPgUWiyFPXKYmG9b4W75OQKC40j64WRAFyQTHMSHmgQ'
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoQuest',
      initialRoute: '/map',
      routes: {
//        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/verification': (context) => const VerificationPage(),
        '/home': (context) => const WelcomePage(),
        '/map': (context) => const MapPage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
    );
  }
}