import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/quest_model.dart';

class QuestDetailsPage extends StatefulWidget {
  final Quest quest;

  const QuestDetailsPage({
    Key? key,
    required this.quest,
  }) : super(key: key);

  @override
  State<QuestDetailsPage> createState() => _QuestDetailsPageState();
}

class _QuestDetailsPageState extends State<QuestDetailsPage> {
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    _checkQuestCompletion();
  }

  Future<void> _checkQuestCompletion() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    final response = await supabase
        .from('user_quest_progress')
        .select('completed')
        .eq('daily_quest_id', widget.quest.id)
        .eq('userId', user.id);

    if (response.isNotEmpty) {
      setState(() {
        isCompleted = response[0]['completed'] as bool;
      });
    }
  }

  Future<void> _completeQuest() async {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    if (user == null) return;

    // Insert or update quest progress
    await supabase.from('user_quest_progress').upsert({
      'daily_quest_id': widget.quest.id,
      'userId': user.id,
      'progress': 100,
      'completed': true,
    });

    // Update user credits
    final response = await supabase
        .from('users')
        .select('credits')
        .eq('id', user.id)
        .single();

    final currentCredits = response['credits'] as int;
    final newCredits = currentCredits + (widget.quest.reward ?? 0);

    await supabase
        .from('users')
        .update({'credits': newCredits})
        .eq('id', user.id);

    setState(() {
      isCompleted = true;
    });

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quest finished successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quest Details'),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: Text(
                        widget.quest.name ?? 'Subpar "copper" ingots',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Reward: ${widget.quest.reward ?? '0'} ',
                            style: const TextStyle(fontSize: 22),
                          ),
                          const Icon(Icons.stars),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              widget.quest.description ?? 'No Description',
              style: const TextStyle(fontSize: 20),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(isCompleted ? Colors.grey : const Color(0xFF4CAF50)),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(vertical: 26.0, horizontal: 42.0),
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0),
                    ),
                  ),
                ),
                onPressed: isCompleted ? null : _completeQuest,
                child:
                  Text(
                    isCompleted ? 'Quest finished' : 'Finish quest',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}