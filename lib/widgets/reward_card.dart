import 'package:flutter/material.dart';
import '../models/reward_model.dart';

class RewardCard extends StatelessWidget {
  final Reward reward;
  final VoidCallback onCreditsUpdated;

  const RewardCard({
    Key? key,
    required this.reward,
    required this.onCreditsUpdated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.pushNamed(
          context,
          '/rewardDetails',
          arguments: reward,
        );
        onCreditsUpdated();
      },
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  width: 75,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    child: Image.network(
                      reward.imageUrl ?? 'https://xqgmvnldsdgbkryvwdpt.supabase.co/storage/v1/object/public/rewards//placeholder.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: Text(
                          reward.name ?? 'Subpar "copper" ingots',
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${reward.price ?? '0'} ',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const Icon(Icons.stars),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}