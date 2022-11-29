import 'dart:async';

import 'package:clean_architecture/presentation/common/render_state/render_state_impl.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  // shared variables and functions that used along all view models
  final StreamController _inputsStreamController =
      StreamController<StateFlow>.broadcast();

  // ha3mel implement lel input state hena fel base class 3lshan msh haro7 a3mel implement l kol viewModel class
  @override
  Sink get inputState => _inputsStreamController;

  // ha3mel implement output state hena fel base class 3lshan msh haro7 a3mel implement l kol viewModel class
  @override
  Stream<StateFlow> get outputState =>
      _inputsStreamController.stream.map((stateFlow) => stateFlow);
  
  @override
  void dispose() {
    // kol dispose mawgod f viewModel zay el login kda hakhli y_call el super.dispose 3lshan yenafez el dispose() di el awel w b3d kda el dispose eli fl model
    _inputsStreamController.close();
  }
}

abstract class BaseViewModelInputs {
  void start(); // start view model job

  void dispose(); // end view model job

  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  Stream<StateFlow> get outputState;
}
