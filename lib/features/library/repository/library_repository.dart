import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieflix/models/movie_model.dart';

final libraryRepositoryProvider = Provider<LibraryRepository>((ref) {
  return LibraryRepository(firestore: FirebaseFirestore.instance);
});

class LibraryRepository {
  final FirebaseFirestore _firestore;
  LibraryRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<List<MovieModel>> getNewMovies() {
    return _firestore
        .collection('movies')
        .orderBy('releaseDate', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MovieModel.fromMap(e.data())).toList());
  }

  Stream<List<MovieModel>> getAllMovies() {
    return _firestore.collection('movies').snapshots().map((event) =>
        event.docs.map((e) => MovieModel.fromMap(e.data())).toList());
  }
}
