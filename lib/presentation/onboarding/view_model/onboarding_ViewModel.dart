import 'dart:async';

import 'package:clean_architecture/presentation/base/base_view_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../domain/models/models.dart';
import '../../resources/assets_manager.dart';
import '../../resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInput, OnBoardingViewModelOutput {
  final StreamController _streamController =
      StreamController<SliderViewObject>();

  late final List<SliderObject> _list;

  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    _list = _getSliderData();
    postDataInOnBoardingview();
  }

  @override
  int goNext() {
    int nextIndex = ++_currentIndex;
    if (nextIndex == _list.length) {
      nextIndex = 0;
    }
    return nextIndex;
  }

  @override
  int goPrevious() {
    int previousIndex = --_currentIndex;
    if (previousIndex == -1) {
      previousIndex = _list.length - 1;
    }
    return previousIndex;
  }

  @override
  void onPageChange(int index) {
    _currentIndex = index;
    postDataInOnBoardingview();
  }

  @override
  // sink (inputs)
  Sink get inputSliderViewObject => _streamController.sink;

  @override
  // stream controller output
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((SliderViewObject) =>
          SliderViewObject); // zay ma htakhod el data bta3et el slide e3redhali msh hatghyar fiha haga

  // private data for onBoarding
  void postDataInOnBoardingview() {
    inputSliderViewObject.add(
        SliderViewObject(_list[_currentIndex], _currentIndex, _list.length));
  }

  int _currentIndex = 0;

  List<SliderObject> _getSliderData() => [
        SliderObject(AppStrings.onBoardingTitle1,
            AppStrings.onBoardingSubTitle1, ImageAssets.onBoardingLogo1),
        SliderObject(AppStrings.onBoardingTitle2,
            AppStrings.onBoardingSubTitle2, ImageAssets.onBoardingLogo2),
        SliderObject(AppStrings.onBoardingTitle3,
            AppStrings.onBoardingSubTitle3, ImageAssets.onBoardingLogo3),
        SliderObject(AppStrings.onBoardingTitle4,
            AppStrings.onBoardingSubTitle4, ImageAssets.onBoardingLogo4),
      ];
}

// this class includes any functions take order like go to the next screen
abstract class OnBoardingViewModelInput {
  int goNext(); // when user click next or swipe left
  int goPrevious(); // when user click back or swipe right
  void onPageChange(int index);

  // stream controller input
  Sink get inputSliderViewObject;
}

abstract class OnBoardingViewModelOutput {
  //stream controller output
  Stream<SliderViewObject> get outputSliderViewObject;
}
