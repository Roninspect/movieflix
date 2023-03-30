import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:movieflix/features/bookmark/repository/bookmark_repository.dart';
import 'package:movieflix/models/movie_model.dart';

final bookmarkControllerProvider = Provider<BookmarkController>((ref) {
  return BookmarkController(
      bookmarkRepository: ref.watch(bookRepositoryProvider), ref: ref);
});

final getBookmarksProvider = StreamProvider<List<MovieModel>>((ref) {
  return ref.watch(bookmarkControllerProvider).getBookmarks();
});

class BookmarkController {
  BookmarkRepository _bookmarkRepository;
  Ref _ref;
  BookmarkController(
      {required BookmarkRepository bookmarkRepository, required Ref ref})
      : _bookmarkRepository = bookmarkRepository,
        _ref = ref;
  final user = FirebaseAuth.instance.currentUser;
  void addBookmark(MovieModel model) {
    _bookmarkRepository.addBookmark(user!.uid, model);
  }

  Stream<List<MovieModel>> getBookmarks() {
    return _bookmarkRepository.getBookmarks(user!.uid);
  }

  void deleteBookmark(String id, BuildContext context) async {
    final res = await _bookmarkRepository.deleteBookmark(id, user!.uid);
    res.fold(
      (l) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.toString()))),
      (r) {
        Future.delayed(const Duration(seconds: 1));
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("deleted")));
      },
    );
  }
}
