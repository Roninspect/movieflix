// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:movieflix/features/search/repository/search_repository.dart';

import '../../../core/error_text.dart';
import '../../../router/router.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
      title: TextField(
        onTap: () async {
          await showSearch(
            context: context,
            delegate: MySearchDelegate(ref: ref),
          );
        },
        decoration: const InputDecoration(
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    ));
  }
}

class MySearchDelegate extends SearchDelegate {
  WidgetRef ref;
  MySearchDelegate({
    required this.ref,
  });
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return ref.watch(searchResultProvider(query)).when(
          data: (movies) {
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  title: Text(movie.name),
                  leading: Image.network(movie.poster),
                );
              },
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const CircularProgressIndicator(),
        );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchResultProvider(query)).when(
          data: (movies) {
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return GestureDetector(
                  onTap: () => context.pushNamed(AppRoutes.stream.name,
                      params: {'id': movie.id}),
                  child: ListTile(
                    title: Text(movie.name),
                    leading: Image.network(movie.poster),
                  ),
                );
              },
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const CircularProgressIndicator(),
        );
  }
}
