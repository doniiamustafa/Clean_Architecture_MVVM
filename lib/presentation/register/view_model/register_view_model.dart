// ignore_for_file: unused_field, unused_element, non_constant_identifier_names

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:clean_architecture/application/app_prefs.dart';
import 'package:clean_architecture/application/di.dart';
import 'package:clean_architecture/application/functions.dart';
import 'package:clean_architecture/domain/usecases/register_usecase.dart';
import 'package:clean_architecture/presentation/base/base_view_model.dart';
import 'package:clean_architecture/presentation/common/freezed_data_class.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';

import '../../common/render_state/render_state_impl.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInputs, RegisterViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _phoneNumberStreamController =
      StreamController<String>.broadcast();
  final StreamController _profilePictureStreamController =
      StreamController<File>.broadcast();
  // ha3mel stream controller lel button 3lshan y3mel enable and disable button
  final StreamController _areAllInputsValidStreamController =
      StreamController<String>.broadcast();
  final StreamController isUseRegisteredStreamController =
      StreamController<bool>();

  final AppPreferences _appPreferences = instance<AppPreferences>();

  var _registerObject = RegisterObject("", "", "", "", "", "");
  final RegisterUseCase registerUseCase;
  RegisterViewModel(this.registerUseCase);

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    super.dispose();
    _userNameStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
    _phoneNumberStreamController.close();
    _profilePictureStreamController.close();
    _areAllInputsValidStreamController.close();
    isUseRegisteredStreamController.close();
  }

  // Inputs  ***************************************************************
  @override
  Sink get _inputEmail => _emailStreamController.sink;

  @override
  Sink get _inputPassword => _passwordStreamController.sink;

  @override
  Sink get _inputProfilePicture => _profilePictureStreamController.sink;

  @override
  Sink get _inputUserName => _userNameStreamController.sink;

  @override
  Sink get _inputphoneNumber => _phoneNumberStreamController.sink;

  @override
  Sink get _areAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  setEmail(String email) {
    _inputEmail.add(email);
    if (isEmailValid(email)) {
      // if email is valid set a value in register object
      _registerObject = _registerObject.copyWith(email: email);
      log("email ${_registerObject.email},");
    } else {
      // if email is not valid or user clear its value; reset the value which saved in register object
      _registerObject = _registerObject.copyWith(email: "");
    }
    _validate(); // b3d ma y3mel set lel data hyro7 yshof akhli el button enable wla lsa fi fields fadia aw not valid
  }

  @override
  setPassword(String password) {
    _inputPassword.add(password);
    if (_isPasswordValid(password)) {
      _registerObject = _registerObject.copyWith(password: password);
      log(" password ${_registerObject.password},");
    } else {
      _registerObject = _registerObject.copyWith(password: "");
    }
    _validate();
  }

  @override
  setProfilePicture(File profilePicture) {
    _inputProfilePicture.add(profilePicture);
    if (profilePicture.path.isNotEmpty) {
      _registerObject =
          _registerObject.copyWith(profilePicture: profilePicture.path);
      log("profile pic ${_registerObject.profilePicture}");
    } else {
      _registerObject = _registerObject.copyWith(profilePicture: "");
    }
    _validate();
  }

  @override
  setUserName(String userName) {
    _inputUserName.add(userName);
    if (_isUserNameValid(userName)) {
      _registerObject = _registerObject.copyWith(userName: userName);
      log("username ${_registerObject.userName}");
    } else {
      _registerObject = _registerObject.copyWith(userName: "");
    }
    _validate();
  }

  @override
  setMobileCode(String mobileCode) {
    if (mobileCode.isNotEmpty) {
      _registerObject = _registerObject.copyWith(mobileCode: mobileCode);
      log(" mobileCode${_registerObject.mobileCode}, ");
    } else {
      _registerObject = _registerObject.copyWith(mobileCode: "");
    }
    _validate();
  }

  @override
  setphoneNumber(String phoneNumber) {
    _inputphoneNumber.add(phoneNumber);
    if (_isPhoneNumberValid(phoneNumber)) {
      _registerObject = _registerObject.copyWith(phoneNumber: phoneNumber);
      log("mobileNumber ${_registerObject.phoneNumber}");
    } else {
      _registerObject = _registerObject.copyWith(phoneNumber: "");
    }
    _validate();
  }

  // Outputs ***************************************************************

  @override // ha3mel check 3la el email b3d kda hadi el result "if it is valid or not" lel stream bta3 el string 3lshan yerga3li error string aw null
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputIsEmailError => outputIsEmailValid
      .map((isEmailValid) => isEmailValid ? null : AppStrings.emailNotValid);

  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));
  @override
  Stream<String?> get outputIsPasswordError =>
      outputIsPasswordValid.map((isPasswordValid) =>
          isPasswordValid ? null : AppStrings.passwordNotValid);

  @override
  Stream<bool> get outputIsPhoneNumberValid =>
      _phoneNumberStreamController.stream
          .map((phoneNumber) => _isPhoneNumberValid(phoneNumber));

  @override
  Stream<String?> get outputIsPhoneNumberError =>
      outputIsPhoneNumberValid.map((isPhoneNumberValid) =>
          isPhoneNumberValid ? null : AppStrings.phoneNumberNotValid);

  @override
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<String?> get outputIsUserNameError =>
      outputIsUserNameValid.map((isUserNameValid) =>
          isUserNameValid ? null : AppStrings.userNameNotValid);

  @override
  Stream<File> get outputIsProfilePictureValid =>
      _profilePictureStreamController.stream.map((file) => file);

  @override
  Stream<bool> get areAllOutputsValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _checkingInputsValidation());

  // private functions for validaty of inputs *******************************************

  _isUserNameValid(String userName) {
    return userName.length > 5;
  }

  _isPasswordValid(String password) {
    return password.length > 5;
  }

  _isPhoneNumberValid(String phoneNumber) {
    return phoneNumber.length > 5;
  }

  _isProfilePicValid(File image) {
    return true;
  }

  bool _checkingInputsValidation() {
    return _registerObject.email.isNotEmpty &&
        _registerObject.userName.isNotEmpty &&
        _registerObject.password.isNotEmpty &&
        _registerObject.phoneNumber.isNotEmpty &&
        _registerObject.mobileCode.isNotEmpty &&
        _registerObject.profilePicture.isNotEmpty;
  }

  _validate() {
    // m3 kol set lel textformfield ha3mel call lel function di 3lshan a-check el inputs valid wla la fa akhli el button yenwar wla la
    _areAllInputsValid.add(null);
  }

  @override
  register() async {
    log(" REGISTER username ${_registerObject.userName}, password ${_registerObject.password}, email ${_registerObject.email}, mobileCode${_registerObject.mobileCode}, mobileNumber ${_registerObject.phoneNumber}");

    inputState
        .add(LoadingState(stateRenderType: StateRenderType.popUpLoadingState));
    // hb3at el attributes b nafs el tarteb eli maktob beh class RegisterUseCaseInput aw akhli el class constructor named 3lshan el values matkhoshesh f b3d
    (await registerUseCase.execute(RegisterUseCaseInput(
      userName: _registerObject.userName,
      email: _registerObject.email,
      password: _registerObject.password,
      mobileCode: _registerObject.mobileCode,
      mobileNumber: _registerObject.phoneNumber,
      profilePicture: _registerObject.profilePicture,
    )))
        .fold(
            (failure) => {
                  inputState.add(ErrorState(
                      StateRenderType.popUpErrorState, failure.message))
                }, (data) {
      inputState.add(ContentState());
      isUseRegisteredStreamController.add(true);
    });
  }
}

abstract class RegisterViewModelInputs {
  register();
  Sink get _inputUserName;
  Sink get _inputPassword;
  Sink get _inputProfilePicture;
  Sink get _inputphoneNumber;
  Sink get _inputEmail;
  Sink get _areAllInputsValid;

  setUserName(String userName);
  setPassword(String password);
  setphoneNumber(String phoneNumber);
  setMobileCode(String mobileCode);
  setEmail(String email);
  setProfilePicture(File profilePicture);
}

abstract class RegisterViewModelOutputs {
  // fl model da bdal ma ha-check 3la el validty bta3et el textformfield fl view; la ana ha3mel check hena w harga3 el error f stream controller mn el viewmodel
  Stream<bool> get outputIsUserNameValid;
  Stream<String?> get outputIsUserNameError;

  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputIsPasswordError;

  Stream<bool> get outputIsPhoneNumberValid;
  Stream<String?> get outputIsPhoneNumberError;

  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputIsEmailError;

  Stream<File> get outputIsProfilePictureValid;

  Stream<bool> get areAllOutputsValid;
}
