// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:movieflix/features/home/controller/home_controller.dart';

import '../../../core/error_text.dart';
import '../../../router/router.dart';
import '../../home/widgets/movie_card.dart';

class MovieListPage extends ConsumerWidget {
  String type;
  MovieListPage({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(8.0).copyWith(left: 15),
          child: Text('$type movies', style: const TextStyle(fontSize: 25)),
        ),
        Expanded(
            child: ref.watch(getMoviesbygenreProvider(type)).when(
                  data: (movies) => MasonryGridView.builder(
                    physics: const NeverScrollableScrollPhysics(), //
                    shrinkWrap: true,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 20,
                    itemCount: movies.length,
                    gridDelegate:
                        const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                          onTap: () => context.pushNamed(AppRoutes.stream.name,
                              params: {'id': movie.id}),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: 320,
                                  child: MovieCard(moviemodel: movie))));
                    },
                  ),
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ))
      ]),
    );
  }
}
