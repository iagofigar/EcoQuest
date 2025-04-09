import 'package:ecoquest/widgets/reward_card.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'models/reward_model.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  _RewardsPageState createState() => _RewardsPageState();
}
class _RewardsPageState extends State<RewardsPage> {
  final _supabaseClient = Supabase.instance.client;
  int credits = 0;
  List<dynamic> rewards = [];

  @override
  void initState(){
    super.initState();
    _getUserCredits();
    _getRewards();
  }

  Future<void> _getRewards() async {
    try {
      final response = await _supabaseClient.from('rewards').select('id, name, description, price, stock, userLimit');
      setState(() {
        rewards = (response as List<dynamic>).map((reward) => Reward.fromMap(reward as Map<String, dynamic>)).toList();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching rewards")),
      );
    }
  }
  Future<void> _getUserCredits() async {
    try {
      final response = await _supabaseClient.from('users').select('credits').match({'id': _supabaseClient.auth.currentUser!.id});
      credits = response.data as int;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching user credits")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Credits: $credits ', style: const TextStyle(fontSize: 20)),
                const Icon(Icons.stars),
                const Padding(padding: EdgeInsets.only(bottom: 50)),
              ],
            ),
          Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceEvenly,
              spacing: 10,
              runSpacing: 10,
              children: [
                SizedBox(
                  height: screenHeight*0.8,
                  child:SingleChildScrollView(
                    child: Column(
                      children: rewards.map((reward) {
                        return RewardCard(
                          reward: reward,
                        );
                      }).toList(),
                    ),
                  )
                )],
            ),
          ],
        ),
      ),
    );
  }
}
