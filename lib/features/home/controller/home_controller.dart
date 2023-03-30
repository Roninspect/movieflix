import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieflix/features/home/repository/home_repository.dart';
import 'package:movieflix/models/chip_model.dart';

import '../../../models/movie_model.dart';
import '../../../models/slider_model.dart';

final homeControllerProvider = Provider<HomeController>((ref) {
  return HomeController(homeRepository: ref.watch(homeRepositoryProvider));
});

final sliderProvider = StreamProvider<List<SliderModel>>((ref) {
  return ref.watch(homeControllerProvider).sliders();
});

final genreProvider = StreamProvider<List<GenreModel>>((ref) {
  return ref.watch(homeControllerProvider).getGenres();
});

final getMoviesbygenreProvider =
    StreamProvider.family<List<MovieModel>, String?>(
        (ref, String? selectedgenre) {
  return ref.watch(homeControllerProvider).getMoviesbygenre(selectedgenre);
});

final popularMovieProvider = StreamProvider<List<MovieModel>>((ref) {
  return ref.watch(homeControllerProvider).getMoviesbyView();
});

final getMoviesByNameProvider = StreamProvider.family((ref, String id) {
  return ref.watch(homeControllerProvider).getmoviesByName(id);
});

class HomeController {
  final HomeRepository _homeRepository;
  HomeController({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;

  Stream<List<SliderModel>> sliders() {
    return _homeRepository.sliders();
  }

  Stream<List<GenreModel>> getGenres() {
    return _homeRepository.getGenres();
  }

  Stream<List<MovieModel>> getMoviesbygenre(String? selectedgenre) {
    return _homeRepository.getMoviesbygenre(selectedgenre);
  }

  Stream<List<MovieModel>> getMoviesbyView() {
    return _homeRepository.getMoviesbyView();
  }

  Stream<MovieModel> getmoviesByName(String id) {
    return _homeRepository.getmoviesByName(id);
  }
}
