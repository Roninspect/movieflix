// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImdbTile extends ConsumerWidget {
  num rating;
  ImdbTile({
    super.key,
    required this.rating,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 30,
      width: 95,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(222, 181, 34, 0.7),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text(
            "IMDB",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
          Text(
            rating.toString(),
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
