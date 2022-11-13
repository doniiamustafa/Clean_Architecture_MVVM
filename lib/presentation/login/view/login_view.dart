import 'package:clean_architecture/application/di.dart';
import 'package:clean_architecture/domain/usecases/login_usecase.dart';
import 'package:clean_architecture/presentation/login/view_model/login_view_model.dart';
import 'package:clean_architecture/presentation/resources/assets_manager.dart';
import 'package:clean_architecture/presentation/resources/color_manager.dart';
import 'package:clean_architecture/presentation/resources/route_manager.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';
import 'package:clean_architecture/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

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

  _bind() {
    // function to bind view model with view
    _loginViewModel.start();
    // 3lshan yb2a up to date l ay changes hate7sal hatsama3 3latol
    _userNameController.addListener(
        () => _loginViewModel.setUserName(_userNameController.text));
    _userNameController.addListener(
        () => _loginViewModel.setPassword(_passwordController.text));
  }

  @override
  void setState(VoidCallback fn) {
    _bind();
    super.setState(fn);
  }

  @override
  void dispose() {
    _loginViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _getContentWidget();
  }

  Widget _getContentWidget() {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Container(
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
                            hintText: AppStrings.userName,
                            labelText: AppStrings.userName,
                            errorText: (snapshot.data ?? true
                                ? null
                                : AppStrings.userNameError)),
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
                            hintText: AppStrings.password,
                            labelText: AppStrings.password,
                            errorText: (snapshot.data ?? true
                                ? null
                                : AppStrings.passwordError)),
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
                    stream: _loginViewModel.outIsInputsValid,
                    builder: (context, snapshot) {
                      // if condition true -> enable button else disable it, ?? disbale as default
                      return SizedBox(
                        height: AppSizes.s60,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: (snapshot.data ?? false)
                                ? () {
                                    _loginViewModel.login();
                                  }
                                : null,
                            child: const Text(AppStrings.login)),
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
                              Navigator.pushReplacementNamed(
                                  context, Routes.forgotPasswordRoute);
                            },
                            child: Text(
                              AppStrings.forgetPassword,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.end,
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, Routes.registerRoute);
                            },
                            child: Text(
                              AppStrings.register,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.end,
                            )),
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
