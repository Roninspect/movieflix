import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieflix/features/library/repository/library_repository.dart';

import '../../../models/movie_model.dart';

final libraryControllerProvider = Provider<LibraryController>((ref) {
  return LibraryController(
      libraryRepository: ref.watch(libraryRepositoryProvider));
});

final getNewMoviesProvider = StreamProvider<List<MovieModel>>((ref) {
  return ref.watch(libraryControllerProvider).getNewMovies();
});
final getAllMoviesProvider = StreamProvider<List<MovieModel>>((ref) {
  return ref.watch(libraryControllerProvider).getAllMovies();
});

class LibraryController {
  final LibraryRepository _libraryRepository;
  LibraryController({required LibraryRepository libraryRepository})
      : _libraryRepository = libraryRepository;

  Stream<List<MovieModel>> getNewMovies() {
    return _libraryRepository.getNewMovies();
  }

  Stream<List<MovieModel>> getAllMovies() {
    return _libraryRepository.getAllMovies();
  }
}
