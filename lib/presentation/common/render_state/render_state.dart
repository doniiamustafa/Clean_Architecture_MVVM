import 'package:clean_architecture/presentation/resources/color_manager.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';
import 'package:clean_architecture/presentation/resources/styles_manager.dart';
import 'package:clean_architecture/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

enum StateRenderType {
  popUpLoadingState,
  popUpErrorState,
  fullScreenLoadingState,
  fullScreenErrorState,
  fullScreenEmptyState,
  successState,
}

class StateRenderer extends StatelessWidget {
  StateRenderType stateRenderType;
  Function retryActionFunction;
  String title;
  String message;

  StateRenderer(
      {required this.stateRenderType,
      required this.retryActionFunction,
      this.title = AppStrings.loading,
      this.message = ""});

  @override
  Widget build(BuildContext context) {
    return _getStateRendered(context);
  }

  Widget _getStateRendered(BuildContext context) {
    switch (stateRenderType) {
      case StateRenderType.popUpLoadingState:
        return _getPopupDialog(context, [_getAnimatedImage()]);

      case StateRenderType.popUpErrorState:
        return _getPopupDialog(context, [
          _getAnimatedImage(),
          _getMessage(message),
          _getRetryActionButton(AppStrings.ok, context)
        ]);

      case StateRenderType.fullScreenLoadingState:
        return _getScreenContent(
            [_getAnimatedImage(), _getMessage(AppStrings.loading)]);

      case StateRenderType.fullScreenErrorState:
        return _getScreenContent([
          _getAnimatedImage(),
          _getMessage(message),
          _getRetryActionButton(AppStrings.retryAgain, context)
        ]);

      case StateRenderType.fullScreenEmptyState:
        return _getScreenContent([_getAnimatedImage(), _getMessage(message)]);

      case StateRenderType.successState:
        return Container();

      default:
        return Container();
    }
  }

  Widget _getScreenContent(List<Widget> children) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getPopupDialog(BuildContext context, List<Widget> children) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: AppSizes.s1_5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.s10),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(AppSizes.s20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
            )
          ],
        ),
        child: _getDialogContent(context, children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context, List<Widget> children) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );
  }

  Widget _getAnimatedImage() {
    return SizedBox(
        height: AppSizes.s100, width: AppSizes.s100, child: Container());
  }

  Widget _getMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPaddings.p14),
        child: Text(message,
            style: getRegularStyle(
                color: ColorManager.darkGrey, fontSize: AppSizes.s20)),
      ),
    );
  }

  Widget _getRetryActionButton(String buttonTitle, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppPaddings.p18),
        child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  if (stateRenderType == StateRenderType.fullScreenErrorState) {
                    retryActionFunction.call();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: Text(buttonTitle))),
      ),
    );
  }
}
