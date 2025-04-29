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
      final today = DateTime.now();
      final formattedDate = DateTime(today.year, today.month, today.day);

      final response = await _supabaseClient
          .from('daily_assigned_quests')
          .select('id, quests(name, description, reward)')
          .eq('assigned_date', formattedDate.toIso8601String());
      final user = _supabaseClient.auth.currentUser;

      if (user == null) return;

      final progressResponse = await _supabaseClient
          .from('user_quest_progress')
          .select('daily_quest_id, completed')
          .eq('userId', user.id);

      final progressMap = {
        for (var progress in progressResponse as List<dynamic>)
          progress['daily_quest_id']: progress['completed'] as bool
      };

      setState(() {
        quests.addAll((response as List<dynamic>).map((quest) {
          final isCompleted = progressMap[quest['id']] ?? false;
          return Quest.fromMap(quest['id'], quest['quests'] as Map<String, dynamic>, isCompleted);
        }).toList());
      });
    } catch (error) {
      print(error.toString());
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
      case 2:
        Navigator.pushReplacementNamed(context, '/user');
        break;
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
                quest: quest,
                isCompleted: quest.isCompleted,
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