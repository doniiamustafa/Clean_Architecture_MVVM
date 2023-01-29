import 'dart:developer';
import 'dart:io';

import 'package:clean_architecture/application/app_constants.dart';
import 'package:clean_architecture/application/app_prefs.dart';
import 'package:clean_architecture/application/di.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state_impl.dart';
import 'package:clean_architecture/presentation/register/view_model/register_view_model.dart';
import 'package:clean_architecture/presentation/resources/assets_manager.dart';
import 'package:clean_architecture/presentation/resources/color_manager.dart';
import 'package:clean_architecture/presentation/resources/route_manager.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';
import 'package:clean_architecture/presentation/resources/values_manager.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _registerViewModel = instance<RegisterViewModel>();

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = instance<ImagePicker>();
  final AppPreferences appPreferences = instance<AppPreferences>();

  final TextEditingController _userNameEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneNumberEditingController =
      TextEditingController();

  void _bind() {
    _registerViewModel.start();
    _userNameEditingController.addListener(() {
      _registerViewModel.setUserName(_userNameEditingController.text);
    });
    _passwordEditingController.addListener(() {
      _registerViewModel.setPassword(_passwordEditingController.text);
    });
    _emailEditingController.addListener(() {
      _registerViewModel.setEmail(_emailEditingController.text);
    });
    _phoneNumberEditingController.addListener(() {
      _registerViewModel.setphoneNumber(_phoneNumberEditingController.text);
    });
    _registerViewModel.isUseRegisteredStreamController.stream
        .listen((isLoggedIn) {
      if (isLoggedIn) {
        appPreferences.setLoginViewed();
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
    _registerViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: AppSizes.s0,
        backgroundColor: ColorManager.white,
        iconTheme: IconThemeData(color: ColorManager.primary),
      ),
      body: StreamBuilder<StateFlow>(
        stream: _registerViewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _registerViewModel.register();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(top: AppPaddings.p28),
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
                child: StreamBuilder<String?>(
                  stream: _registerViewModel.outputIsUserNameError,
                  builder: (context, snapshot) {
                    return TextFormField(
                      controller: _userNameEditingController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          hintText: AppStrings.userName,
                          labelText: AppStrings.userName,
                          errorText: snapshot.data),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: AppSizes.s12,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPaddings.p28, right: AppPaddings.p28),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: CountryCodePicker(
                        onChanged: (country) {
                          _registerViewModel.setMobileCode(
                              country.dialCode ?? Constant.token);
                        },
                        initialSelection: '+20',
                        favorite: const ['+20', '+966', 'FR', '+966'],
                        showCountryOnly: true,
                        showOnlyCountryWhenClosed: true,
                        hideMainText: true,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: StreamBuilder<String?>(
                        stream: _registerViewModel.outputIsPhoneNumberError,
                        builder: (context, snapshot) {
                          return TextFormField(
                            controller: _phoneNumberEditingController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                hintText: AppStrings.mobileNumber,
                                labelText: AppStrings.mobileNumber,
                                errorText: snapshot.data),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.s12,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPaddings.p28, right: AppPaddings.p28),
                child: StreamBuilder<String?>(
                  stream: _registerViewModel.outputIsPasswordError,
                  builder: (context, snapshot) {
                    return TextFormField(
                      controller: _passwordEditingController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          hintText: AppStrings.password,
                          labelText: AppStrings.password,
                          errorText: snapshot.data),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: AppSizes.s12,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPaddings.p28, right: AppPaddings.p28),
                child: StreamBuilder<String?>(
                  stream: _registerViewModel.outputIsEmailError,
                  builder: (context, snapshot) {
                    return TextFormField(
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          hintText: AppStrings.email,
                          labelText: AppStrings.email,
                          errorText: snapshot.data),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: AppSizes.s12,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPaddings.p28, right: AppPaddings.p28),
                child: Container(
                  height: AppSizes.s48,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(AppSizes.s8)),
                      border: Border.all(color: ColorManager.grey, width: 1.5)),
                  child: GestureDetector(
                    child: _getMediaWidget(),
                    onTap: () {
                      _showPicker(context);
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: AppSizes.s12,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppPaddings.p28, right: AppPaddings.p28),
                child: StreamBuilder<bool>(
                  stream: _registerViewModel.areAllOutputsValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      height: AppSizes.s60,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () {
                                _registerViewModel.register();
                              }
                            : null,
                        child: const Text(AppStrings.register),
                      ),
                    );
                  },
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: AppPaddings.p28,
                      right: AppPaddings.p28,
                      top: AppPaddings.p12),
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.loginRoute);
                      },
                      child: Text(
                        AppStrings.alreadyHaveAnAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.end,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppPaddings.p8,
        right: AppPaddings.p8,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Flexible(child: Text(AppStrings.profilePicture)),
        Flexible(
            child: StreamBuilder<File>(
          stream: _registerViewModel.outputIsProfilePictureValid,
          builder: ((context, snapshot) {
            return _imagePickedByUser(snapshot.data);
          }),
        )),
        const Flexible(child: Icon(Icons.camera_enhance))
      ]),
    );
  }

  Widget _imagePickedByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      return Image.file(image);
    } else {
      return Container();
    }
  }

  _showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
              child: Wrap(children: [
            ListTile(
              trailing: const Icon(Icons.arrow_forward),
              leading: const Icon(Icons.camera_enhance),
              title: const Text(AppStrings.photoCamera),
              onTap: () {
                _imagefromCamera();
                Navigator.of(context).pop;
              },
            ),
            ListTile(
              trailing: const Icon(Icons.arrow_forward),
              leading: const Icon(Icons.browse_gallery_rounded),
              title: const Text(AppStrings.photoGallery),
              onTap: () {
                _imagefromGallery();
                Navigator.of(context).pop;
              },
            )
          ]));
        });
  }

  _imagefromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _registerViewModel.setProfilePicture(File(image?.path ?? ""));
  }

  _imagefromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _registerViewModel.setProfilePicture(File(image?.path ?? ""));
  }
}
