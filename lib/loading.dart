import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 1), () {});
    Navigator.of(context).pushReplacementNamed('/map');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('EcoQuest')),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Center(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 200)),
              SizedBox(
                width: 270,
                height: 270,
                child: Image.asset('assets/EcoQuestLogoNobg.png', fit: BoxFit.fill),
              ),
              const Padding(padding: EdgeInsets.only(top: 50)),
              const Text('   Loading...', style: TextStyle(fontSize: 30, color: Color(0xFF2196f3))),
            ],
          )
      ),
    );
  }
}