import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({required this.label, super.key});

  /// Read by screen readers; not shown visually.
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(semanticsLabel: label));
  }
}
