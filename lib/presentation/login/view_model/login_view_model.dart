import 'dart:async';
import 'dart:developer';
import 'package:clean_architecture/domain/usecases/login_usecase.dart';
import 'package:clean_architecture/presentation/base/base_view_model.dart';
import 'package:clean_architecture/presentation/common/freezed_data_class.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _inputsValidStreamController =
      StreamController<void>.broadcast(); // void 3lshan mafish data badkhlha

  final LoginUseCase loginUseCase;
  LoginViewModel(this.loginUseCase);

  var loginObject = LoginObject("", "");

  @override
  void start() {}

  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _inputsValidStreamController.close();
  }

  @override
  login() async {
    (await loginUseCase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold((Failure) => Failure.message, (data) => log(data.customer!.name));
  }

  @override
  Sink get inputPassword => _userNameStreamController.sink;

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject.copyWith(password: password);
    inputsValid.add(null);
  }

  @override
  Sink get inputUserName => _passwordStreamController.sink;
  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject.copyWith(userName: userName);
  }

  @override
  Sink get inputsValid => _inputsValidStreamController.sink;

  @override
  Stream<bool> get outIsUserNameValid => _userNameStreamController.stream
      .map((userName) => isUserNameValid(userName));

  bool isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }

  @override
  Stream<bool> get outIsPasswordValid => _passwordStreamController.stream
      .map((password) => isPasswordValid(password));

  bool isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  @override
  Stream<bool> get outIsInputsValid => _inputsValidStreamController.stream
      .map((_) => isInputsValid()); // _ 3lshan ana msh bab3at haga fl stream

  bool isInputsValid() {
    return isPasswordValid(loginObject.userName) &&
        isUserNameValid(loginObject.password);
  }
}

abstract class LoginViewModelInputs {
  setUserName(String userName);
  setPassword(String password);
  login();

  Sink get inputUserName;
  Sink get inputPassword;
  Sink get inputsValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outIsUserNameValid;
  Stream<bool> get outIsPasswordValid;
  Stream<bool> get outIsInputsValid;
}
