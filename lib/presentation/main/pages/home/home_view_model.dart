import 'dart:async';
import 'dart:ffi';

import 'package:clean_architecture/domain/models/models.dart';
import 'package:clean_architecture/domain/usecases/getHomeData_usecase.dart';
import 'package:clean_architecture/presentation/base/base_view_model.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state_impl.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';

class HomeViewModel extends BaseViewModel with HomeInputs, HomeOutputs {
  final HomeDataUseCase _homeDataUseCase;
  HomeViewModel(this._homeDataUseCase);

  // hastakhdem " rxdart " el mara di
  // bdal ma a7ot .broadcast 3lshan y3mel listen 3la kol action gded by7sal
  // ha7ot behavior subject eli mn rxdart package w di fiha stream build-in fl package w by3mel listen 3la ay action gded
  // final StreamController _bannersStreamController =
  //     BehaviorSubject<List<BannersAd>>();
  // final StreamController _storesStreamController =
  //     BehaviorSubject<List<Stores>>();
  // final StreamController _servicesStreamController =
  //     BehaviorSubject<List<Services>>();

  // ? ha3mel refactor lel code w hakhli stream controller wahed bs shayel el class fiha el data kollaha
  final StreamController _homeDataStreamController =
      BehaviorSubject<HomeData>();

  @override
  void start() {
    getHomeData();
  }

  @override
  void dispose() {
    // _bannersStreamController.close();
    // _servicesStreamController.close();
    // _storesStreamController.close();
    _homeDataStreamController.close();

    super.dispose();
  }

  getHomeData() async {
    inputState.add(
        LoadingState(stateRenderType: StateRenderType.fullScreenLoadingState));
    (await _homeDataUseCase.execute(Void)).fold(
        (failure) => {
              inputState.add(ErrorState(
                  StateRenderType.fullScreenErrorState, failure.message))
            }, (data) {
      // in case data was received successfully
      // render home screen content then send banners, stores and services in sink through stream controllers to get then in list from streams
      inputState.add(ContentState());
      // inputBanners.add(data.homeData?.bannersAd);
      // inputServices.add(data.homeData?.services);
      // inputStores.add(data.homeData?.stores);
      inputHomeData.add(data.homeData);
    });
  }

  // @override
  // Sink get inputBanners => _bannersStreamController.sink;

  // @override
  // Sink get inputServices => _servicesStreamController.sink;

  // @override
  // Sink get inputStores => _storesStreamController.sink;

  @override
  Sink get inputHomeData => _homeDataStreamController.sink;

  // @override
  // Stream<List<BannersAd>> get outputBanners =>
  //     _bannersStreamController.stream.map((banners) => banners);

  // @override
  // Stream<List<Services>> get outputServices =>
  //     _servicesStreamController.stream.map((serives) => serives);

  // @override
  // Stream<List<Stores>> get outputStores =>
  //     _storesStreamController.stream.map((stores) => stores);

  @override
  Stream<HomeData> get outputHomeData =>
      _homeDataStreamController.stream.map((data) => data);
}

abstract class HomeInputs {
  // Sink get inputStores;
  // Sink get inputServices;
  // Sink get inputBanners;

  Sink get inputHomeData;
}

abstract class HomeOutputs {
  // Stream<List<Stores>> get outputStores;
  // Stream<List<Services>> get outputServices;
  // Stream<List<BannersAd>> get outputBanners;

  Stream<HomeData> get outputHomeData;
}

class HomeViewObject {
  List<Stores>? stores;
  List<Services>? services;
  List<BannersAd>? banners;

  HomeViewObject({this.services, this.stores, this.banners});
}
