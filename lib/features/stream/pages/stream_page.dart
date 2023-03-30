// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movieflix/core/error_text.dart';
import 'package:movieflix/features/home/controller/home_controller.dart';
import 'package:movieflix/features/stream/controller/stream_controller.dart';
import 'package:movieflix/features/stream/repository/stream_repository.dart';
import 'package:movieflix/features/stream/widgets/videoPlayerView.dart';

import 'package:video_player/video_player.dart';

import '../../../models/movie_model.dart';
import '../../../router/router.dart';
import '../../bookmark/controller/bookmark_controller.dart';

// ignore: must_be_immutable
class StreamPage extends ConsumerStatefulWidget {
  String id;

  StreamPage({
    super.key,
    required this.id,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StreamPageState();
}

class _StreamPageState extends ConsumerState<StreamPage>
    with TickerProviderStateMixin {
  TabController? _tabController;
  late String _currentMovieId;

  void addBookmark(WidgetRef ref, MovieModel model) {
    ref.watch(bookmarkControllerProvider).addBookmark(model);
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentMovieId = widget.id;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ref.watch(getMoviesByNameProvider(widget.id)).when(
                data: (movie) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //* video player
                            VideoPlayerView(
                              movieId: widget.id,
                              url: movie.movielink,
                              dataSourceType: DataSourceType.network,
                            ),
                            const SizedBox(height: 20),

                            //* title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    movie.name,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .collection('bookamrks')
                                      .where('id', isEqualTo: movie.id)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.active) {
                                      if (snapshot.data!.docs.isEmpty) {
                                        return Column(
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  addBookmark(ref, movie);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  "added")));
                                                },
                                                icon: const Icon(
                                                  Icons.bookmark_add_outlined,
                                                  size: 40,
                                                )),
                                            const Text("Add to watch")
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Already Added")));
                                                },
                                                icon: const Icon(
                                                  Icons.bookmark_added,
                                                  size: 40,
                                                )),
                                            const Text(
                                              "Added",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            )
                                          ],
                                        );
                                      }
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    return const SizedBox();
                                  },
                                ),
                              ],
                            ),

                            //* genre list
                            SizedBox(
                              height: 60,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemCount: movie.genres.length,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: Chip(label: Text(movie.genres[index])),
                                ),
                              ),
                            ),

                            //* plot
                            const SizedBox(height: 10),
                            const Text(
                              "Plot",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              movie.description,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 10),
                            //* tab
                            Column(
                              children: [
                                SizedBox(
                                  width: double.maxFinite,
                                  child:
                                      TabBar(controller: _tabController, tabs: [
                                    Tab(
                                        text: movie.isMovie
                                            ? "sequels"
                                            : "episodes"),
                                    const Tab(text: "Similar"),
                                  ]),
                                ),
                                SizedBox(
                                  width: double.maxFinite,
                                  height: 300,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      ref
                                          .watch(getSequelsProvider(
                                              movie.sequelof))
                                          .when(
                                            data: (data) => ListView.builder(
                                              itemCount: data.length,
                                              itemBuilder: (context, index) {
                                                final sequelMovie = data[index];
                                                return ListTile(
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                  leading: Text('${index + 1}'),
                                                  title: Text(sequelMovie.name),
                                                  trailing: Image.network(
                                                      sequelMovie.poster),
                                                );
                                              },
                                            ),
                                            error: (error, stackTrace) =>
                                                const Center(
                                                    child: Text("No sequels")),
                                            loading: () =>
                                                const CircularProgressIndicator(),
                                          ),
                                      ref
                                          .watch(getSimilarMoviesProvider(
                                              movie.genres))
                                          .when(
                                            data: (similarMovies) =>
                                                ListView.builder(
                                              itemCount: similarMovies.length,
                                              itemBuilder: (context, index) {
                                                final similarMovie =
                                                    similarMovies[index];
                                                return ref
                                                    .watch(
                                                        getMoviesByNameProvider(
                                                            similarMovie.id))
                                                    .when(
                                                      data: (sm) =>
                                                          GestureDetector(
                                                        onTap:
                                                            widget.id == sm.id
                                                                ? () {}
                                                                : () {
                                                                    context.pushNamed(
                                                                        AppRoutes
                                                                            .stream
                                                                            .name,
                                                                        params: {
                                                                          'id':
                                                                              sm.id
                                                                        });
                                                                  },
                                                        child: ListTile(
                                                            tileColor: widget
                                                                        .id ==
                                                                    sm.id
                                                                ? const Color.fromARGB(
                                                                    66,
                                                                    158,
                                                                    158,
                                                                    158)
                                                                : Colors
                                                                    .transparent,
                                                            contentPadding:
                                                                const EdgeInsets.all(
                                                                    10),
                                                            leading: Text(
                                                                "${index + 1}"),
                                                            title: Text(
                                                                similarMovie
                                                                    .name),
                                                            trailing: Image.network(
                                                                similarMovie
                                                                    .poster)),
                                                      ),
                                                      error: (error,
                                                              stackTrace) =>
                                                          ErrorText(
                                                              error: error
                                                                  .toString()),
                                                      loading: () =>
                                                          const CircularProgressIndicator(),
                                                    );
                                              },
                                            ),
                                            error: (error, stackTrace) =>
                                                ErrorText(
                                                    error: error.toString()),
                                            loading: () => const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  );
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const CircularProgressIndicator(),
              )),
    );
  }
}
