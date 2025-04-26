import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ecoquest/models/quest_model.dart';
import 'package:ecoquest/widgets/quest_card.dart';

class QuestsPage extends StatefulWidget {
  const QuestsPage({super.key});

  @override
  _QuestsPageState createState() => _QuestsPageState();
}
class _QuestsPageState extends State<QuestsPage> {
  final List<Quest> quests = [];
  final _supabaseClient = Supabase.instance.client;
  late Timer _timer;
  Duration _timeUntilMidnight = Duration.zero;

  @override
  void initState() {
    super.initState();
    _fetchQuests();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchQuests() async {
    try {
      final response = await _supabaseClient.from('daily_assigned_quests').select('id, quests(name, description, reward)');
      setState(() {
        quests.addAll((response as List<dynamic>).map((quest) => Quest.fromMap(quest['id'], quest['quests'] as Map<String, dynamic>)).toList());
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  void _startCountdown() {
    _updateTimeUntilMidnight();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _updateTimeUntilMidnight();
      });
    });
  }

  void _updateTimeUntilMidnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    _timeUntilMidnight = midnight.difference(now);
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/rewards');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/map');
        break;
      // case 2:
      //   Navigator.pushReplacementNamed(context, '/login');
      //   break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Today\'s quests',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(40, 40, 0, 0),
        child: Column(
          children: [
            ...quests.map((quest) {
              return QuestCard(
                name: quest.name ?? "",
                description: quest.description ?? "",
                reward: quest.reward ?? 0,
              );
            }),
            const SizedBox(height: 20),
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Quests will reset in:\n', style: TextStyle(fontSize: 20, color: Colors.lightBlue)),
                  TextSpan(text: '${_formatDuration(_timeUntilMidnight)}', style: const TextStyle(fontSize: 20, color: Colors.black54, fontWeight: FontWeight.bold)),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ]
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        currentIndex: 1,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}