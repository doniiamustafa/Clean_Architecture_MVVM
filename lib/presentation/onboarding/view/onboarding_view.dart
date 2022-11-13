import 'dart:async';
import 'dart:io';

import 'package:clean_architecture/presentation/onboarding/view_model/onboarding_ViewModel.dart';
import 'package:clean_architecture/presentation/resources/assets_manager.dart';
import 'package:clean_architecture/presentation/resources/color_manager.dart';
import 'package:clean_architecture/presentation/resources/constants_manager.dart';
import 'package:clean_architecture/presentation/resources/route_manager.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';
import 'package:clean_architecture/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/models/models.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    _bind();
  }

  final PageController _pageController = PageController();
  final OnBoardingViewModel _viewModel = OnBoardingViewModel();

  _bind() {
    _viewModel.start();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
        stream: _viewModel.outputSliderViewObject,
        builder: (context, snapshot) {
          return _getContentWidget(snapshot.data!);
        });
  }

  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject) {
    return Container(
      color: ColorManager.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //left arrow
          Padding(
            padding: const EdgeInsets.all(AppPaddings.p12),
            child: GestureDetector(
                child: SizedBox(
                  height: AppSizes.s20,
                  width: AppSizes.s20,
                  child: SvgPicture.asset(ImageAssets.leftArrow),
                ),
                onTap: () {
                  _pageController.animateToPage(_viewModel.goPrevious(),
                      duration: const Duration(
                          milliseconds: AppConstants.screenAnimationTime),
                      curve: Curves.bounceInOut);
                }),
          ),

          // circle detector
          Row(
            children: [
              for (int i = 0; i < sliderViewObject.numberOfSliders; i++)
                Padding(
                  padding: const EdgeInsets.all(AppPaddings.p8),
                  child: _getCircleDetected(i, sliderViewObject.currentIndex),
                ),
            ],
          ),

          // right arrow
          Padding(
            padding: const EdgeInsets.all(AppPaddings.p12),
            child: GestureDetector(
              child: SizedBox(
                  height: AppSizes.s20,
                  width: AppSizes.s20,
                  child: SvgPicture.asset(ImageAssets.rightArrow)),
              onTap: () {
                _pageController.animateToPage(_viewModel.goNext(),
                    duration: const Duration(
                        milliseconds: AppConstants.screenAnimationTime),
                    curve: Curves.bounceInOut);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCircleDetected(int index, int _currentIndex) {
    if (index == _currentIndex) {
      return SvgPicture.asset(ImageAssets.hollowCircle);
    } else {
      return SvgPicture.asset(ImageAssets.solidCircle);
    }
  }

  Widget _getContentWidget(SliderViewObject sliderViewObject) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorManager.white,
          elevation: AppSizes.s0,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: ColorManager.white,
              statusBarBrightness: Brightness.dark)),
      backgroundColor: ColorManager.white,
      body: PageView.builder(
          controller: _pageController,
          itemCount: sliderViewObject.numberOfSliders,
          onPageChanged: (index) {
            _viewModel.onPageChange(index);
          },
          itemBuilder: (context, index) {
            // OnBoardingViewclass
            return OnBoardingView(sliderViewObject.sliderObject);
          }),
      bottomSheet: Container(
          color: ColorManager.white,
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // ya3ne khod el mesa7a eli enta 3aizha
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, Routes.loginRoute);
                    },
                    child: Text(
                      AppStrings.skip,
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.end,
                    )),
              ),
              // _getBottomSheet widget
              _getBottomSheetWidget(sliderViewObject),
            ],
          )),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

class OnBoardingView extends StatelessWidget {
  final SliderObject _sliderObject;
  const OnBoardingView(this._sliderObject, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: AppSizes.s40),
        Padding(
          padding: const EdgeInsets.all(AppPaddings.p8),
          child: Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPaddings.p8),
          child: Text(
            _sliderObject.subTtile,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: AppSizes.s60),
        SvgPicture.asset(_sliderObject.image)
      ],
    );
  }
}
