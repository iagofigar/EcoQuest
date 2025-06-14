import 'package:ecoquest/loading.dart';
import 'package:ecoquest/login.dart';
import 'package:ecoquest/providers/user_provider.dart';
import 'package:ecoquest/qrCode.dart';
import 'package:ecoquest/qrScanner.dart';
import 'package:ecoquest/rewardDetails.dart';
import 'package:ecoquest/rewards.dart';
import 'package:ecoquest/user.dart';
import 'package:ecoquest/welcome.dart';
import 'package:ecoquest/register.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecoquest/verification.dart';
import 'package:ecoquest/map.dart';
import 'package:ecoquest/quests.dart';
import 'package:ecoquest/questDetails.dart';

import 'package:ecoquest/models/quest_model.dart';

import 'models/reward_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
      url: 'https://xqgmvnldsdgbkryvwdpt.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhxZ212bmxkc2RnYmtyeXZ3ZHB0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk4MTA3NTIsImV4cCI6MjA1NTM4Njc1Mn0.uPgUWiyFPXKYmG9b4W75OQKC40j64WRAFyQTHMSHmgQ'
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EcoQuest',
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/verification': (context) => const VerificationPage(),
        '/loading': (context) => const LoadingPage(),
        '/rewards' : (context) => const RewardsPage(),
        '/rewardDetails': (context) => RewardDetailsPage(
          reward: ModalRoute.of(context)!.settings.arguments as Reward,
        ),
        '/map': (context) => const MapPage(),
        '/quests': (context) => const QuestsPage(),
        '/questDetails': (context) => QuestDetailsPage(quest: ModalRoute.of(context)!.settings.arguments as Quest,),
        '/home': (context) => const WelcomePage(),
        '/qrCode': (context) => const QRCodeScreen(),
        '/qrScanner': (context) => const QRScannerScreen(),
        '/user' : (context) => const ProfilePage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
    );
  }
}