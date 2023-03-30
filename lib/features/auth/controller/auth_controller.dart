import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/snackbar.dart';
import '../../../models/usermodel.dart';
import '../repository/auth_repository.dart';

final userProvider = StateProvider<UserModel?>((ref) {
  return null;
});

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, bool>((ref) =>
        AuthController(authRepo: ref.watch(authRepositoryProvider), ref: ref));

class AuthController extends StateNotifier<bool> {
  final Ref _ref;
  final AuthRepository _authRepository;

  AuthController({required AuthRepository authRepo, required Ref ref})
      : _authRepository = authRepo,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChnages;

  Stream<UserModel> getuserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void singInWithGoogle(BuildContext context) async {
    state = true;

    final user = await _authRepository.signInWithGoogle();

    state = false;
    user.fold(
      (l) {
        print(l.toString());
        return ErrorSnackbar().showsnackBar(context, l.toString());
      },
      (r) => _ref.read(userProvider.notifier).update((state) => r),
    );
  }
}
