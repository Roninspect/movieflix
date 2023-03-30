import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieflix/models/chip_model.dart';
import 'package:movieflix/models/movie_model.dart';

import 'package:movieflix/models/slider_model.dart';

enum MovieEnmus {
  slider,
  genres,
  movies,
  viewCount,
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepository(firestore: FirebaseFirestore.instance);
});

class HomeRepository {
  final FirebaseFirestore _firestore;
  HomeRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  // Stream<List<MovieModel>> getMoviesbyTitle(String name) {}
  Stream<List<SliderModel>> sliders() {
    return _firestore.collection(MovieEnmus.slider.name).snapshots().map(
        (event) =>
            event.docs.map((e) => SliderModel.fromMap(e.data())).toList());
  }

  Stream<List<GenreModel>> getGenres() {
    return _firestore.collection(MovieEnmus.genres.name).snapshots().map(
        (event) =>
            event.docs.map((e) => GenreModel.fromMap(e.data())).toList());
  }

  Stream<List<MovieModel>> getMoviesbygenre(String? selectedgenre) {
    return _firestore
        .collection(MovieEnmus.movies.name)
        .where(MovieEnmus.genres.name, arrayContains: selectedgenre)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MovieModel.fromMap(e.data())).toList());
  }

  Stream<List<MovieModel>> getMoviesbyView() {
    return _firestore
        .collection(MovieEnmus.movies.name)
        .orderBy(MovieEnmus.viewCount.name, descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MovieModel.fromMap(e.data())).toList());
  }

  Stream<MovieModel> getmoviesByName(String id) {
    return _firestore.collection('movies').doc(id).snapshots().map(
        (event) => MovieModel.fromMap(event.data() as Map<String, dynamic>));
  }
}
