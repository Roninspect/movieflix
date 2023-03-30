// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'imdb_tile.dart';

class Featureds extends ConsumerWidget {
  Function()? onTap;
  int index;
  String url;
  String title;
  num rating;
  Featureds({
    super.key,
    required this.onTap,
    required this.index,
    required this.url,
    required this.title,
    required this.rating,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Builder(builder: (context) {
                return ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Colors.black38,
                    BlendMode.darken,
                  ),
                  child: Container(
                    height: 480,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(url), fit: BoxFit.cover),
                    ),
                  ),
                );
              }),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 20),
                  child: ImdbTile(rating: rating))
            ],
          )
        ],
      ),
    );
  }
}
