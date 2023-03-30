// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BuildIndicator extends ConsumerWidget {
  int activeIndex;
  int length;

  BuildIndicator({
    super.key,
    required this.activeIndex,
    required this.length,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: length,
      effect: const ExpandingDotsEffect(
          activeDotColor: Colors.white,
          dotColor: Colors.white,
          dotHeight: 10,
          dotWidth: 10),
    );
  }
}
