import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movieflix/core/error_text.dart';
import 'package:movieflix/features/home/controller/home_controller.dart';
import 'package:movieflix/features/home/widgets/search_field.dart';
import 'package:movieflix/features/home/widgets/fetaures.dart';
import 'package:movieflix/models/slider_model.dart';
import 'package:video_player/video_player.dart';

import '../../../router/router.dart';
import '../widgets/indicator.dart';
import '../widgets/movie_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<HomePage> {
  int activeIndex = 0;
  String? selectedGenre = 'Action';
  void selectedgenre(String genre) {
    setState(() {
      selectedGenre = genre;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            extendBodyBehindAppBar: true,
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ref.watch(sliderProvider).when(
                          data: (sliders) => Stack(
                            children: [
                              CarouselSlider.builder(
                                itemCount: sliders.length,
                                itemBuilder: (context, index, realIndex) {
                                  SliderModel slider = sliders[index];
                                  return Featureds(
                                      onTap: () {},
                                      index: index,
                                      url: slider.poster,
                                      title: slider.title,
                                      rating: slider.rating);
                                },
                                options: CarouselOptions(
                                  height: 500,
                                  viewportFraction: 1,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      activeIndex = index;
                                    });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 440.0, left: 280),
                                child: BuildIndicator(
                                  activeIndex: activeIndex,
                                  length: sliders.length,
                                ),
                              )
                            ],
                          ),
                          error: (error, stackTrace) =>
                              ErrorText(error: error.toString()),
                          loading: () => const CircularProgressIndicator(),
                        ),
                    const SearchBar(),
                    SizedBox(
                      height: 100,
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
                                              color:
                                                  selectedGenre == genre.label
                                                      ? Colors.black
                                                      : Colors.white,
                                            ),
                                          ),
                                          backgroundColor:
                                              selectedGenre == genre.label
                                                  ? Colors.amber
                                                  : null,
                                        )),
                                  );
                                },
                              );
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const CircularProgressIndicator(),
                          ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Movies by favourite genre",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: () => context.pushNamed(
                                AppRoutes.movieList.name,
                                params: {'type': selectedGenre!}),
                            child: const Text("show all"))
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 380,
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
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                          ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Popular Movies",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 380,
                      child: ref.watch(popularMovieProvider).when(
                            data: (popularMovies) => ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: min(popularMovies.length, 7),
                              itemBuilder: (context, index) {
                                final movie = popularMovies[index];

                                return SizedBox(
                                    width: 210,
                                    child: MovieCard(
                                      moviemodel: movie,
                                      onTap: () => context.pushNamed(
                                          AppRoutes.stream.name,
                                          params: {'id': movie.id}),
                                    ));
                              },
                            ),
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Center(
                                child: CircularProgressIndicator()),
                          ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
