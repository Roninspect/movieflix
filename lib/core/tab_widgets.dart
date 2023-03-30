import 'package:flutter/material.dart';
import 'package:movieflix/features/bookmark/page/bookmark_page.dart';
import 'package:movieflix/features/home/pages/homepage.dart';
import 'package:movieflix/features/library/pages/library_page.dart';
import 'package:movieflix/features/search/pages/search_page.dart';

class TabWidgets {
  static final List<Widget> tabWidgets = <Widget>[
    const HomePage(),
    const LibraryPage(),
    BookMarkPage(),
    SearchPage(),
  ];
}
