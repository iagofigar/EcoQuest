import 'package:ecoquest/widgets/reward_card.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  _RewardsPageState createState() => _RewardsPageState();
}
class _RewardsPageState extends State<RewardsPage> {
  final _supabaseClient = Supabase.instance.client;
  int credits = 0;

  @override
  void initState(){
    super.initState();
    _getUserCredits();
  }

  Future<void> _getRewards() async {
    try {
      final response = await _supabaseClient.from('rewards').select('name, description, price, stock, userLimit');
      final rewardsData = response.data as List;
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
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Rewards')),
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
                Text('Credits: $credits '),
                const Icon(Icons.stars),
                const Padding(padding: EdgeInsets.only(bottom: 50)),
              ],
            ),
            const Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceEvenly,
              spacing: 10,
              runSpacing: 10,
              children: [
                RewardCard(
                  name: 'Subpar "copper" ingots',
                  price: 1080,
                  imageRoute: 'assets/placeholder.jpg',
                ),
                RewardCard(
                  name: 'Nanni\'s Enemy\n"Tell Ea-nasir: Nanni sends the following message"',
                  price: 50,
                  imageRoute: 'assets/placeholder.jpg',
                ),
                RewardCard(
                  name: 'The "Copper" Scroll',
                  price: 100,
                  imageRoute: 'assets/placeholder.jpg',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
