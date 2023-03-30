import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieflix/features/home/controller/nav_state.dart';

final navStateProvider = StateNotifierProvider<NavNotifier, NavState>((ref) {
  return NavNotifier();
});

class NavNotifier extends StateNotifier<NavState> {
  NavNotifier() : super(const NavState());

  void onIndexChange({required int index}) {
    state = state.copyWith(index: index);
  }
}
