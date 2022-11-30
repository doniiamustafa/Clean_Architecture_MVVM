import 'dart:async';

import 'package:clean_architecture/application/app_prefs.dart';
import 'package:clean_architecture/application/di.dart';
import 'package:clean_architecture/presentation/onboarding/view/onboarding_view.dart';
import 'package:clean_architecture/presentation/resources/assets_manager.dart';
import 'package:clean_architecture/presentation/resources/color_manager.dart';
import 'package:clean_architecture/presentation/resources/constants_manager.dart';
import 'package:clean_architecture/presentation/resources/route_manager.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _splashDelay() {
    _timer = Timer(
        const Duration(seconds: AppConstants.splashDelayseconds), _goNext);
  }

  _goNext() {
    _appPreferences.isLoginViewed().then((isLoggedIn) => {
          if (isLoggedIn)
            {Navigator.pushReplacementNamed(context, Routes.mainRoute)}
          else
            {
              _appPreferences
                  .isOnBoardingViewed()
                  .then((isOnBoardingViewed) => {
                        if (isOnBoardingViewed)
                          {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.loginRoute)
                          }
                        else
                          {
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.onboardingRoute)
                          }
                      })
            }
        });
    Navigator.pushReplacementNamed(context, Routes.onboardingRoute);
  }

  @override
  void initState() {
    super.initState();
    _splashDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: const Center(
        child: Image(
          image: AssetImage(ImageAssets.splashLogo),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
