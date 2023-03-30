import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieflix/models/movie_model.dart';

final searchProvider = Provider<SearchRepository>((ref) {
  return SearchRepository(firebaseFirestore: FirebaseFirestore.instance);
});

final searchResultProvider = StreamProvider.family((ref, String query) {
  return ref.watch(searchProvider).searchMovie(query);
});

class SearchRepository {
  final FirebaseFirestore _firestore;

  SearchRepository({required FirebaseFirestore firebaseFirestore})
      : _firestore = firebaseFirestore;

  Stream<List<MovieModel>> searchMovie(String query) {
    return _firestore
        .collection('movies')
        .where('name',
            isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
            isLessThan: query.toLowerCase().isEmpty
                ? null
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .snapshots()
        .map(
      (event) {
        List<MovieModel> movieResult = [];
        for (var movie in event.docs) {
          movieResult.add(MovieModel.fromMap(movie.data()));
        }
        return movieResult;
      },
    );
  }
}
