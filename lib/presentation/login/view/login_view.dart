import 'dart:developer';

import 'package:clean_architecture/application/app_prefs.dart';
import 'package:clean_architecture/application/di.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state_impl.dart';
import 'package:clean_architecture/presentation/login/view_model/login_view_model.dart';
import 'package:clean_architecture/presentation/resources/assets_manager.dart';
import 'package:clean_architecture/presentation/resources/color_manager.dart';
import 'package:clean_architecture/presentation/resources/route_manager.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';
import 'package:clean_architecture/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _loginViewModel = instance<LoginViewModel>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _bind() {
    // function to bind view model with view
    _loginViewModel.start();
    // 3lshan yb2a up to date l ay changes hate7sal hatsama3 3latol
    _userNameController.addListener(
        () => _loginViewModel.setUserName(_userNameController.text));
    _passwordController.addListener(
        () => _loginViewModel.setPassword(_passwordController.text));

    // law el user dkhal el email w el password sa7 isLoggedIn = true therefore ha3mel navigate 3la el mainScreen
    _loginViewModel.isUserLoggedInStreamController.stream.listen((isLoggedIn) {
      if (isLoggedIn) {
        _appPreferences.setUserLoggedIn();
        SchedulerBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
      }
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _loginViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<StateFlow>(
        stream: _loginViewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _loginViewModel.login();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPaddings.p100),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center(
                child: Image(
                  image: AssetImage(ImageAssets.splashLogo),
                ),
              ),
              const SizedBox(
                height: AppSizes.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPaddings.p28, right: AppPaddings.p28),
                child: StreamBuilder<bool>(
                  stream: _loginViewModel.outIsUserNameValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      controller: _userNameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: AppStrings.userName.tr(),
                          labelText: AppStrings.userName.tr(),
                          errorText: (snapshot.data ?? true
                              ? null
                              : AppStrings.userNameError.tr())),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: AppSizes.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPaddings.p28, right: AppPaddings.p28),
                child: StreamBuilder<bool>(
                  stream: _loginViewModel.outIsPasswordValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          hintText: AppStrings.password.tr(),
                          labelText: AppStrings.password.tr(),
                          errorText: (snapshot.data ?? true
                              ? null
                              : AppStrings.passwordError.tr())),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: AppSizes.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPaddings.p28, right: AppPaddings.p28),
                child: StreamBuilder<bool>(
                  stream: _loginViewModel.outAreAllInputsValid,
                  builder: (context, snapshot) {
                    // if condition true -> enable button else disable it, ?? disbale as default
                    return SizedBox(
                      height: AppSizes.s60,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: (snapshot.data ?? false)
                              ? () {
                                  log("${snapshot.data} message");
                                  _loginViewModel.login();
                                }
                              : null,
                          child: Text(AppStrings.login.tr())),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPaddings.p28,
                    right: AppPaddings.p28,
                    top: AppPaddings.p8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.forgotPasswordRoute);
                          },
                          child: Text(
                            AppStrings.forgetPassword.tr(),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.end,
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.registerRoute);
                          },
                          child: Text(
                            AppStrings.notaMember.tr(),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.end,
                          )),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
