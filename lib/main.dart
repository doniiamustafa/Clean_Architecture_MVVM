import 'package:clean_architecture/application/app.dart';
import 'package:clean_architecture/application/di.dart';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // check that all await functions are ready to build then build the app
  await initAppModule();
  runApp(MyApp());
}
