import 'package:ecoquest/models/quest_model.dart';
import 'package:flutter/material.dart';

class QuestCard extends StatelessWidget {
  final Quest quest;
  final bool isCompleted;

  const QuestCard({
    Key? key,
    required this.quest,
    required this.isCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/questDetails',
          arguments: quest,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: IntrinsicWidth(
          child: IntrinsicHeight(
            child: Card(
              color: isCompleted ? Colors.green : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 45,
                          child: Text(
                            quest.name ?? 'Loading...',
                            softWrap: true,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          height: 25,
                          child: Row(
                            children: [
                              const Spacer(),
                              Text(
                                '${quest.reward ?? '0'} ',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Icon(Icons.stars),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}