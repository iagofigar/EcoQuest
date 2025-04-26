import 'dart:typed_data';

import 'package:flutter/material.dart';

class QuestCard extends StatelessWidget {
  final String? name;
  final String? description;
  final int? reward;
  final int? progress;

  const QuestCard({
    Key? key,
    this.name,
    this.description,
    this.reward,
    this.progress
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: IntrinsicWidth(
        child: IntrinsicHeight(
          child: Card(
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
                            name ?? 'Loading...',
                            softWrap: true, maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16)
                        ),
                      ),
                      SizedBox(
                        width: 300,
                        height: 25,
                        child: Row(
                          children: [
                            Text(
                                'Progress: ${progress ?? '0%'}',
                                style: const TextStyle(fontSize: 16)
                            ),
                            const Spacer(),
                            Text(
                                '${reward ?? '0'} ',
                                style: const TextStyle(fontSize: 16)
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
      )
    );
  }
}