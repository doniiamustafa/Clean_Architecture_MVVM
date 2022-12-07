import 'package:clean_architecture/application/app_constants.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';
import 'package:flutter/material.dart';

abstract class StateFlow {
  StateRenderType getStateRendertype();
  String getMessage();
}

// Loading State POPUP, FULLSCREEN
class LoadingState extends StateFlow {
  String? message;
  StateRenderType stateRenderType;
  LoadingState(
      {required this.stateRenderType, String message = AppStrings.loading});
  @override
  String getMessage() => message ?? AppStrings.loading;

  @override
  StateRenderType getStateRendertype() => stateRenderType;
}

// Error State POPUP, FULLSCREEN
class ErrorState extends StateFlow {
  StateRenderType stateRenderType;
  String message;
  ErrorState(
    this.stateRenderType,
    this.message,
  );

  @override
  String getMessage() => message;

  @override
  StateRenderType getStateRendertype() => stateRenderType;
}

// Content State
class ContentState extends StateFlow {
  @override
  String getMessage() => Constant.empty;

  @override
  StateRenderType getStateRendertype() => StateRenderType.contentState;
}

// Empty State
class EmptyState extends StateFlow {
  String message;

  EmptyState(
    this.message,
  );
  @override
  String getMessage() => message;

  @override
  StateRenderType getStateRendertype() => StateRenderType.fullScreenEmptyState;
}

//  Success State
class SuccessState extends StateFlow {
  String message;

  SuccessState(
    this.message,
  );
  @override
  String getMessage() => message;

  @override
  StateRenderType getStateRendertype() => StateRenderType.popUpSuccessState;
}

extension FlowStateExtension on StateFlow {
  // content screen widget means el ui eli byb2a mawgood wara el popup lazem a3redo w a3red fo2eeh as a stack el popup
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    //runtimeType means the stateflow that workes on runtime
    switch (runtimeType) {
      case LoadingState: // popup or fullScreen
        {
          if (getStateRendertype() == StateRenderType.popUpLoadingState) {
            // show pop up of loading
            showPopup(context, getStateRendertype(), getMessage());
            // show content of screen behind pop up
            return contentScreenWidget;
          } else {
            // show fullscreen
            return StateRenderer(
                message: getMessage(),
                stateRenderType: getStateRendertype(),
                retryActionFunction: retryActionFunction);
          }
        }
      case ErrorState:
        {
          dismissDialog(
              context); // close any dialog before error dialog launches
          if (getStateRendertype() == StateRenderType.popUpErrorState) {
            // show pop up of error
            showPopup(context, getStateRendertype(), getMessage());
            // show content of screen behind pop up
            return contentScreenWidget;
          } else {
            // show fullscreen
            return StateRenderer(
                message: getMessage(),
                stateRenderType: getStateRendertype(),
                retryActionFunction: retryActionFunction);
          }
        }
      case SuccessState:
        {
          dismissDialog(context);
          showPopup(context, StateRenderType.popUpSuccessState, getMessage(),
              title: AppStrings.success);
          return contentScreenWidget;
        }
      case EmptyState:
        {
          return StateRenderer(
            stateRenderType: getStateRendertype(),
            retryActionFunction: () {},
            message: getMessage(),
          );
        }
      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
      default:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
    }
  }

  isCurrentDialogRunning(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;
  // checking if there is two dialogs running at the same time

  dismissDialog(BuildContext context) {
    // check if there is two dialogs running at the same time and close on of them for example loading and error pop up, close loading
    if (isCurrentDialogRunning(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(
      BuildContext context, StateRenderType stateRendererType, String message,
      {String title = Constant.empty}) {
    // addPostFrameCallback used when we have to render an ui in fucntion body or in logic part
    WidgetsBinding.instance.addPostFrameCallback((_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
            stateRenderType: stateRendererType,
            title: title,
            message: message,
            retryActionFunction: () {})));
  }
}
