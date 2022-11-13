abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {}

abstract class BaseViewModelInputs {
  void start(); // start view model job

  void dispose(); // end view model job
}

abstract class BaseViewModelOutputs {}
