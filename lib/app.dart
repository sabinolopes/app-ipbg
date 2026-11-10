import 'package:app_igreja_guacui/app_dependencies.dart';
import 'package:app_igreja_guacui/ui/pages/home_page.dart';
import 'package:flutter/material.dart';

const _seedColor = Color(0xFF1B5E20);

class App extends StatelessWidget {
  const App({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Igreja Presbiteriana de Guaçuí',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
      ),
      home: HomePage(dependencies: dependencies),
    );
  }
}
