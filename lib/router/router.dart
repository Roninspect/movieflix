import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:movieflix/features/home/pages/home.dart';
import 'package:movieflix/features/library/pages/movie_list_page.dart';

import '../features/auth/pages/login_page.dart';
import '../features/auth/repository/auth_repository.dart';
import '../features/home/pages/homepage.dart';
import '../features/stream/pages/stream_page.dart';
import '../models/movie_model.dart';

enum AppRoutes {
  home,
  homepage,
  stream,
  login,
  register,
  movieList,
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    routes: [
      GoRoute(
        path: '/',
        name: AppRoutes.home.name,
        builder: (context, state) => const Home(),
      ),
      ShellRoute(
          navigatorKey: _shellNavigatorKey,
          builder: (context, state, child) {
            return Home();
          },
          routes: [
            GoRoute(
              path: '/homepage',
              name: AppRoutes.homepage.name,
              builder: (context, state) => const HomePage(),
              routes: [
                GoRoute(
                    path: 'stream/:id',
                    name: AppRoutes.stream.name,
                    builder: (context, state) {
                      return StreamPage(id: state.params['id']!);
                    }),
                GoRoute(
                  path: 'movieList/:type',
                  name: AppRoutes.movieList.name,
                  builder: (context, state) =>
                      MovieListPage(type: state.params['type']!),
                )
              ],
            ),
          ]),
      GoRoute(
        path: '/login',
        name: AppRoutes.login.name,
        builder: (context, state) => const LoginScreen(),
      )
    ],
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) return null;
      final isAuth = authState.valueOrNull != null;

      final isHome = state.location == '/';

      if (isHome) {
        return isAuth ? '/' : '/login';
      }

      final isLoggingIn = state.location == '/login';

      if (isLoggingIn) return isAuth ? '/' : null;

      return isAuth ? null : '/';
    },
  );
});
