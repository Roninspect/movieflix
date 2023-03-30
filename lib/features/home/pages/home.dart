import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movieflix/core/tab_widgets.dart';
import 'package:movieflix/features/home/controller/nav_controller.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final navIndex = ref.watch(navStateProvider);
    return SafeArea(
      child: Scaffold(
        body: TabWidgets.tabWidgets[navIndex.index],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: navIndex.index,
            onTap: (value) {
              ref.watch(navStateProvider.notifier).onIndexChange(index: value);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_library_rounded), label: 'library'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark), label: 'saved'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'search'),
            ]),
      ),
    );
  }
}
