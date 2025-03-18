import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 200)),
            Image(image: AssetImage('assets/EcoQuestLogoNobg.png')),
            Text('Welcome!', style: TextStyle(fontSize: 35)),
          ],
        )
      ),
    );
  }
}