import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:movieflix/core/failure.dart';
import 'package:movieflix/core/typedefs.dart';

import '../../../models/movie_model.dart';

final bookRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepository(firestore: FirebaseFirestore.instance);
});

class BookmarkRepository {
  FirebaseFirestore _firestore;
  BookmarkRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid addBookmark(String uid, MovieModel movieModel) async {
    try {
      // ignore: void_checks
      return right(await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookamrks')
          .add(movieModel.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<MovieModel>> getBookmarks(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('bookamrks')
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MovieModel.fromMap(e.data())).toList());
  }

  FutureVoid deleteBookmark(String id, String uid) async {
    try {
      final bookmarkQuerySnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('bookamrks')
          .where('id', isEqualTo: id)
          .get();
      if (bookmarkQuerySnapshot.size == 1) {
        final bookmarkDocumentSnapshot = bookmarkQuerySnapshot.docs[0];
        await bookmarkDocumentSnapshot.reference.delete();
        return right(null);
      }
      return left(Failure('Bookmark not found'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}

  // Stream<MovieModel> getBookmarks

