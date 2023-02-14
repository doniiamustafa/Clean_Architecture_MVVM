import 'package:clean_architecture/application/app.dart';
import 'package:clean_architecture/application/di.dart';
import 'package:clean_architecture/presentation/resources/language_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EasyLocalization.ensureInitialized();
  // check that all await functions are ready to build then build the app
  await initAppModule();
  runApp(EasyLocalization(
      child: Phoenix(child: MyApp()),
      supportedLocales: const [arabicLocale, englishLocale],
      path: assets_path_localisations));
}
