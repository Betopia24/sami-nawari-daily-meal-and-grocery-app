import 'package:flutter/material.dart';
import 'explore_map_view.dart';

/// Backward-compatible wrapper delegating to ExploreMapView
class MockMapView extends StatelessWidget {
  const MockMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExploreMapView();
  }
}
