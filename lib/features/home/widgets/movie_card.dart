// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movieflix/core/error_text.dart';
import 'package:movieflix/features/bookmark/controller/bookmark_controller.dart';

import 'package:movieflix/features/home/widgets/imdb_tile.dart';
import 'package:movieflix/models/movie_model.dart';

class MovieCard extends ConsumerWidget {
  MovieModel moviemodel;
  Function()? onTap;
  MovieCard({
    super.key,
    required this.moviemodel,
    this.onTap,
  });
  void addBookmark(WidgetRef ref, MovieModel model) {
    ref.watch(bookmarkControllerProvider).addBookmark(model);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  moviemodel.poster,
                  fit: BoxFit.contain,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          moviemodel.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('bookamrks')
                          .where('id', isEqualTo: moviemodel.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.active) {
                          if (snapshot.data!.docs.isEmpty) {
                            return IconButton(
                                onPressed: () async {
                                  addBookmark(ref, moviemodel);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("added")));
                                },
                                icon: const Icon(Icons.bookmark_add_outlined));
                          } else {
                            return IconButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Already Added")));
                                },
                                icon: const Icon(Icons.bookmark_added));
                          }
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        return const SizedBox();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 15),
            child: ImdbTile(rating: moviemodel.rating),
          )
        ],
      ),
    );
  }
}
