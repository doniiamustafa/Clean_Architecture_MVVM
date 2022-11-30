import 'dart:async';
import 'package:clean_architecture/application/app_prefs.dart';
import 'package:clean_architecture/application/di.dart';
import 'package:clean_architecture/domain/usecases/login_usecase.dart';
import 'package:clean_architecture/presentation/base/base_view_model.dart';
import 'package:clean_architecture/presentation/common/freezed_data_class.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  final StreamController _userNameStreamController =
      StreamController<String>.broadcast();

  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();

  final StreamController _areAllInputsValidStreamController =
      StreamController<void>.broadcast(); // void 3lshan mafish data badkhlha

  final StreamController isUserLoggedInStreamController =
      StreamController<bool>();
  // msh ha7ot broadcast 3lshan hy3mel listen mara wahda bs once user logged in successfully

  final AppPreferences _appPreferences = instance<AppPreferences>();

  var loginObject = LoginObject("", "");
  final LoginUseCase loginUseCase;
  LoginViewModel(this.loginUseCase);

  @override
  void dispose() {
    super.dispose();
    _userNameStreamController.close();
    _passwordStreamController.close();
    _areAllInputsValidStreamController.close();
    isUserLoggedInStreamController.close();
  }

  @override
  void start() {
    // view model should tell view to render content state
    // to render login ui
    inputState.add(ContentState());
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;
  @override
  Sink get inputUserName => _userNameStreamController.sink;
  @override
  Sink get inputAreAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    inputAreAllInputsValid.add(null);
  }

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    loginObject = loginObject.copyWith(userName: userName);
    inputAreAllInputsValid.add(null);
  }

  @override
  login() async {
    inputState
        .add(LoadingState(stateRenderType: StateRenderType.popUpLoadingState));
    (await loginUseCase.execute(
            LoginUseCaseInput(loginObject.userName, loginObject.password)))
        .fold(
            (failure) => {
                  // left -> failure
                  inputState.add(ErrorState(
                      StateRenderType.popUpErrorState, failure.message))
                }, (data) {
      _appPreferences.setLoginViewed();
      // right -> data (success)
      inputState.add(ContentState());
      // navigate to main screen
      isUserLoggedInStreamController.add(true);
    });
  }

  @override
  Stream<bool> get outIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outIsUserNameValid => _userNameStreamController.stream
      .map((userName) => _isUserNameValid(userName));

  @override
  Stream<bool> get outAreAllInputsValid =>
      _areAllInputsValidStreamController.stream
          .map((_) => _areAllInputsValid());

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String userName) {
    return userName.isNotEmpty;
  }

  bool _areAllInputsValid() {
    return _isPasswordValid(loginObject.password) &&
        _isUserNameValid(loginObject.userName);
  }
}

abstract class LoginViewModelInputs {
  setUserName(String userName);
  setPassword(String password);
  login();

  Sink get inputUserName;
  Sink get inputPassword;
  Sink get inputAreAllInputsValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outIsUserNameValid;
  Stream<bool> get outIsPasswordValid;
  Stream<bool> get outAreAllInputsValid;
}
