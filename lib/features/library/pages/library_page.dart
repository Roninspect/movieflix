import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movieflix/core/error_text.dart';
import 'package:movieflix/features/home/controller/home_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../router/router.dart';
import '../../home/widgets/movie_card.dart';
import '../controller/library_controller.dart';

class LibraryPage extends ConsumerStatefulWidget {
  const LibraryPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LibraryPageState();
}

class _LibraryPageState extends ConsumerState<LibraryPage> {
  String? selectedGenre = 'Action';

  void selectedgenre(String genre) {
    setState(() {
      selectedGenre = genre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Library"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Movies by Genre',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ref.watch(genreProvider).when(
                        data: (genres) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: genres.length,
                            itemBuilder: (context, index) {
                              final genre = genres[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () => selectedgenre(genre.label),
                                  child: Chip(
                                    label: Text(
                                      genre.label,
                                      style: TextStyle(
                                        color: selectedGenre == genre.label
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    ),
                                    backgroundColor:
                                        selectedGenre == genre.label
                                            ? Colors.amber
                                            : Colors.transparent,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const CircularProgressIndicator(),
                      ),
                ),
                //* movie by genres
                SizedBox(
                  height: 360,
                  child: ref
                      .watch(getMoviesbygenreProvider(selectedGenre))
                      .when(
                        data: (movies) => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            final movie = movies[index];
                            return SizedBox(
                              width: 200,
                              child: MovieCard(
                                moviemodel: movie,
                                onTap: () => context.pushNamed(
                                    AppRoutes.stream.name,
                                    params: {'id': movie.id}),
                              ),
                            );
                          },
                        ),
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                ),
                const SizedBox(height: 10),

                //* movie newly added
                const Text(
                  'Newly Added',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 360,
                  child: ref.watch(getNewMoviesProvider).when(
                        data: (newMovies) => ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: newMovies.length,
                          itemBuilder: (context, index) {
                            final newMovie = newMovies[index];
                            return SizedBox(
                              width: 200,
                              child: MovieCard(
                                moviemodel: newMovie,
                                onTap: () => context.pushNamed(
                                    AppRoutes.stream.name,
                                    params: {'id': newMovie.id}),
                              ),
                            );
                          },
                        ),
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                      ),
                ),
                //* all movies
                const SizedBox(height: 10),
                const Text(
                  'All Movies',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                ref.watch(getAllMoviesProvider).when(
                      data: (allMovies) => MasonryGridView.builder(
                        physics: const NeverScrollableScrollPhysics(), //
                        shrinkWrap: true,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        itemCount: allMovies.length,
                        gridDelegate:
                            const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2),
                        itemBuilder: (context, index) {
                          final movie = allMovies[index];
                          return GestureDetector(
                              onTap: () => context.pushNamed(
                                  AppRoutes.stream.name,
                                  params: {'id': movie.id}),
                              child: Image.network(movie.poster));
                        },
                      ),
                      error: (error, stackTrace) =>
                          ErrorText(error: error.toString()),
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                    ),
              ],
            ),
          ),
        ));
  }
}
