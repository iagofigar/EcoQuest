import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'models/reward_model.dart';

class RewardDetailsPage extends StatelessWidget {
  final Reward reward;
  final _supabaseClient = Supabase.instance.client;
  int credits = 0;

  RewardDetailsPage({
    Key? key,
    required this.reward,
  }) : super(key: key);

  void initState() {
    _getUserCredits();
  }

  Future<void> _getUserCredits() async {
    try {
      final response = await _supabaseClient.from('users').select('credits').match({'id': _supabaseClient.auth.currentUser!.id});
      credits = response[0]['credits'] as int;
    } catch (error) {
      print("Error fetching user credits: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    _getUserCredits();
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
                Image.network(
                  reward.imageUrl ?? 'https://xqgmvnldsdgbkryvwdpt.supabase.co/storage/v1/object/public/rewards//placeholder.jpg',
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
            const Padding(padding: EdgeInsets.only(top: 20)),
            Align(
              alignment: Alignment.bottomCenter,
              child:
              TextButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFF4CAF50)),
                  padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                    const EdgeInsets.symmetric(vertical: 26.0, horizontal: 42.0),
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0),
                    ),
                  ),
                ),
                onPressed: () {
                  showDialog(context: context, builder: (BuildContext context)
                  {
                    return AlertDialog(
                      content: const Text(
                          'Are you sure you want to cash out this reward?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final supabase = Supabase.instance.client;
                            print("WHAT IS CREDITS $credits");
                            if ((reward.price ?? 0) <= credits) {
                              if ((reward.stock ?? 0) > 0) {
                                final response = await supabase
                                    .from('rewards')
                                    .update({'stock': (reward.stock ?? 0) - 1})
                                    .eq('id', reward.id)
                                    .execute();

                                print("WHAT IS RESPONSE.DATA ${response.data}");
                                if (response.data == null) {
                                  await supabase
                                      .from('users')
                                      .update({'credits': credits - (reward.price ?? 0)})
                                      .eq('id', supabase.auth.currentUser!.id)
                                      .execute();

                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Reward cashed out successfully!')),
                                  );
                                } else {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text(
                                        'Unexpected error occurred, try again later!')),
                                  );
                                }
                              } else {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text(
                                      'Sorry, reward is currently out of stock!')),
                                );
                              }
                            }else{
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text(
                              'Not enough credits to cash out this reward!')),
                              );
                            }
                          },
                          child: const Text('Confirm'),
                        ),
                      ],
                    );
                  });
                },
                child:
                const Text(
                  'Cash out reward!',
                  style: TextStyle(
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