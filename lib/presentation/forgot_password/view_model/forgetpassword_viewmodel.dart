import 'dart:async';
import 'package:clean_architecture/domain/usecases/forgetPassword_usecase.dart';
import 'package:clean_architecture/presentation/base/base_view_model.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state_impl.dart';

class ForgetPasswordViewModel extends BaseViewModel
    with ForgetViewInputs, ForgetViewOutputs {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _areAllInputsValidStreamController =
      StreamController<String>.broadcast();
  final ForgetPasswordUsecase _usecase;
  ForgetPasswordViewModel(this._usecase);

  var email = "";

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _emailStreamController.close();
    _areAllInputsValidStreamController.close();
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputAreAllInputsValid => _areAllInputsValidStreamController.sink;

  @override
  Stream<bool> get outIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<bool> get outAreAllInputsValid =>
      _areAllInputsValidStreamController.stream.map((_) => _isAllInputsValid());

  isEmailValid(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  _isAllInputsValid() {
    return isEmailValid(email);
  }

  @override
  forgetPassword() async {
    inputState
        .add(LoadingState(stateRenderType: StateRenderType.popUpLoadingState));
    (await _usecase.execute(email)).fold((failure) {
      inputState
          .add(ErrorState(StateRenderType.popUpErrorState, failure.message));
    }, (success) => inputState.add(ContentState()));
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    inputAreAllInputsValid.add(null);
  }
}

abstract class ForgetViewInputs {
  forgetPassword();
  setEmail(String email);

  Sink get inputEmail;
  Sink get inputAreAllInputsValid;
}

abstract class ForgetViewOutputs {
  Stream<bool> get outIsEmailValid;
  Stream<bool> get outAreAllInputsValid;
}
