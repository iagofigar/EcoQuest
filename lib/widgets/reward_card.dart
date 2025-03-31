import 'package:flutter/material.dart';

class RewardCard extends StatelessWidget {
  final String? name;
  final int? price;
  final String? imageRoute;

  const RewardCard({
    Key? key,
    this.name,
    this.price,
    this.imageRoute,
  });

  @override
  Widget build(BuildContext context) {
    String? priceS = price?.toString();
    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                  ),
                  width: 75,
                  height: 100,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                      child: Image.asset(
                          imageRoute ?? 'assets/placeholder.jpg',
                          fit: BoxFit.fill
                      )
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: Text(
                          name ?? 'Subpar "copper" ingots',
                          softWrap: true, maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16)
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            '${priceS ?? '0'} ',
                            style: const TextStyle(fontSize: 16)
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
    );
  }
}