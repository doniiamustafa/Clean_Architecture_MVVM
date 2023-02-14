import 'package:clean_architecture/application/app_prefs.dart';
import 'package:clean_architecture/application/di.dart';
import 'package:clean_architecture/data/data_source/local_data_source.dart';
import 'package:clean_architecture/presentation/resources/route_manager.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';
import 'package:clean_architecture/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppPreferences _appPreferences = instance<AppPreferences>();

  final LocalDataSource _localDataSource = instance<LocalDataSource>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        padding: const EdgeInsets.all(AppPaddings.p8),
        children: [
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(AppStrings.changeLanguage.tr(),
                style: Theme.of(context).textTheme.bodyLarge),
            trailing: const Icon(Icons.arrow_right_outlined),
            onTap: () {
              _changeLanguage();
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_support_sharp),
            title: Text(AppStrings.contactUs.tr(),
                style: Theme.of(context).textTheme.bodyLarge),
            trailing: const Icon(Icons.arrow_right_outlined),
            onTap: () {
              _contactUs();
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: Text(AppStrings.inviteYourFriends.tr(),
                style: Theme.of(context).textTheme.bodyLarge),
            trailing: const Icon(Icons.arrow_right_outlined),
            onTap: () {
              _inviteYourFriends();
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: Text(AppStrings.logout.tr(),
                style: Theme.of(context).textTheme.bodyLarge),
            trailing: const Icon(Icons.arrow_right_outlined),
            onTap: () {
              _logout();
            },
          )
        ],
      ),
    );
  }

  _changeLanguage() {
    _appPreferences.changeAppLanguage();
    Phoenix.rebirth(context);
  }

  _contactUs() {}

  _inviteYourFriends() {}

  _logout() {
    // app preference set user logged out
    _appPreferences.logout();

    // clear user cache
    _localDataSource.clearCache();

    // navigate to login screen
    Navigator.pushReplacementNamed(context, Routes.loginRoute);
  }
}
