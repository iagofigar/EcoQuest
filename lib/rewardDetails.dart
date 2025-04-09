import 'package:flutter/material.dart';
import 'models/reward_model.dart';

class RewardDetailsPage extends StatelessWidget {
  final Reward reward;

  const RewardDetailsPage({
    Key? key,
    required this.reward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reward Details'),
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
                SizedBox(width: 150 ,height: 200,
                child:
                Image.asset(
                  'assets/placeholder.jpg',
                  fit: BoxFit.fill,
                ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Text(
                        reward.name ?? 'Subpar "copper" ingots',
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Price: ${reward.price ?? '0'} ',
                          style: const TextStyle(fontSize: 22),
                        ),
                        const Icon(Icons.stars),
                      ],
                    ),
                  ],
                )
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              reward.description ?? 'No Description',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}