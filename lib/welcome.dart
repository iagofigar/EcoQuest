import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 250)),
            SizedBox(
              width: 270,
              height: 270,
              child: Image.asset('assets/EcoQuestLogoNobg.png', fit: BoxFit.fill),
            ),
            const Padding(padding: EdgeInsets.only(top: 40)),
            const Text('Welcome!', style: TextStyle(fontSize: 35)),
          ],
        )
      ),
    );
  }
}