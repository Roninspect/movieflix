import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../search/pages/search_page.dart';

class SearchBar extends ConsumerWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextFormField(
        readOnly: true,
        onTap: () async {
          await showSearch(
            context: context,
            delegate: MySearchDelegate(ref: ref),
          );
        },
        onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: const InputDecoration(
          hintText: "Search...",
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
