import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieflix/core/error_text.dart';

import '../controller/bookmark_controller.dart';

class BookMarkPage extends ConsumerWidget {
  BookMarkPage({super.key});

  void deleteBookmark(String id, WidgetRef ref, BuildContext context) {
    ref.watch(bookmarkControllerProvider).deleteBookmark(id, context);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("bookmarks"),
      ),
      body: ref.watch(getBookmarksProvider).maybeWhen(
            data: (bookmarks) {
              if (bookmarks.isEmpty) {
                return const Center(
                  child: Text('No bookmarks'),
                );
              } else {
                return ListView.builder(
                  itemCount: bookmarks.length,
                  itemBuilder: (context, index) {
                    final bookmark = bookmarks[index];
                    return InkWell(
                      onLongPress: () => deleteBookmark(
                          bookmark.id, ref, _scaffoldKey.currentContext!),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: Text('${index + 1}.'),
                        title: Text(bookmark.name),
                        trailing: Image.network(bookmark.poster),
                      ),
                    );
                  },
                );
              }
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const CircularProgressIndicator(),
            orElse: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
