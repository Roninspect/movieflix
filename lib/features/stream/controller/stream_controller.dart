import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieflix/features/stream/repository/stream_repository.dart';

import '../../../models/movie_model.dart';

final streamControllerProvider = Provider<StreamController>((ref) {
  return StreamController(
      streamRepository: ref.watch(streamRepositoryProvider));
});

final getSimilarMoviesProvider =
    StreamProvider.family((ref, List<String> genres) {
  return ref.watch(streamControllerProvider).getSimilarMovies(genres);
});
// final getSequelsProvider = StreamProvider.family((ref, List<String> sequelIds) {
//   return ref.watch(streamControllerProvider).getSequels(sequelIds);
// });

class StreamController {
  StreamRepository _streamRepository;
  StreamController({required StreamRepository streamRepository})
      : _streamRepository = streamRepository;

  Stream<List<MovieModel>> getSimilarMovies(List<String> genres) {
    return _streamRepository.getSimilarMovies(genres);
  }

  // Stream<List<MovieModel>> getSequels(List<String> sequelIds) {
  //   return _streamRepository.getSequels(sequelIds);
  // }
}
