import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieflix/models/movie_model.dart';

final streamRepositoryProvider = Provider<StreamRepository>((ref) {
  return StreamRepository(firestore: FirebaseFirestore.instance);
});

final getSequelsProvider =
    StreamProvider.family((ref, List<String> sequelOfIds) {
  return ref.watch(streamRepositoryProvider).getSequels(sequelOfIds);
});

class StreamRepository {
  final FirebaseFirestore _firestore;
  StreamRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  Stream<List<MovieModel>> getSimilarMovies(List<String> genres) {
    return _firestore
        .collection('movies')
        .where('genres', arrayContainsAny: genres)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MovieModel.fromMap(e.data())).toList());
  }

  Stream<List<MovieModel>> getSequels(List<String> sequelOfIds) {
    return _firestore
        .collection('movies')
        .where(FieldPath.documentId, whereIn: sequelOfIds)
        .limit(10)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MovieModel.fromMap(e.data())).toList());
  }
}
