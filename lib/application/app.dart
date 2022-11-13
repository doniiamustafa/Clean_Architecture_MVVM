import 'package:clean_architecture/presentation/resources/route_manager.dart';
import 'package:clean_architecture/presentation/resources/theme_manager.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  MyApp._internal(); //named constructor

  static final MyApp _instance =
      MyApp._internal(); // single instance or singleton, ya3ne lma b3melo call bygebli nafs el instance msh by3mel wahda gdeda

  factory MyApp() => _instance; // factory ya3ne kol ma a3melo call by3meli instance gdeda

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
