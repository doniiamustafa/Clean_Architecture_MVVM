import 'package:clean_architecture/application/di.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state_impl.dart';
import 'package:clean_architecture/presentation/forgot_password/view_model/forgetpassword_viewmodel.dart';
import 'package:clean_architecture/presentation/resources/assets_manager.dart';
import 'package:clean_architecture/presentation/resources/color_manager.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';
import 'package:clean_architecture/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _forgetPasswordController =
      TextEditingController();
  final ForgetPasswordViewModel _viewModel =
      instance<ForgetPasswordViewModel>();

  bind() {
    _viewModel.start();
    _forgetPasswordController
        .addListener(() => _viewModel.setEmail(_forgetPasswordController.text));
  }

  @override
  void initState() {
    bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorManager.white,
        body: StreamBuilder<StateFlow>(
            stream: _viewModel.outputState,
            builder: (context, snapshot) {
              return snapshot.data
                      ?.getScreenWidget(context, _getContentWidget(), () {
                    _viewModel.forgetPassword();
                  }) ??
                  _getContentWidget();
            }));
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
                  child: TextFormField(
                    controller: _forgetPasswordController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        hintText: AppStrings.userName.tr(),
                        labelText: AppStrings.userName.tr(),
                        errorText: AppStrings.userNameError.tr()),
                  )),
              const SizedBox(
                height: AppSizes.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPaddings.p28,
                    right: AppPaddings.p28,
                    top: AppPaddings.p8),
                child: StreamBuilder<bool>(
                    stream: _viewModel.outAreAllInputsValid,
                    builder: (context, snapshot) {
                      return SizedBox(
                        height: AppSizes.s60,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: (snapshot.data ?? false)
                                ? () => _viewModel.forgetPassword()
                                : null,
                            child: const Text(AppStrings.forgetPassword)),
                      );
                    }),
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    AppStrings.didnotRecieveEmail,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.end,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
