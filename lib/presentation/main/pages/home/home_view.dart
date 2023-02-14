import 'dart:async';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:clean_architecture/application/di.dart';
import 'package:clean_architecture/domain/models/models.dart';
import 'package:clean_architecture/presentation/common/render_state/render_state_impl.dart';
import 'package:clean_architecture/presentation/main/pages/home/home_view_model.dart';
import 'package:clean_architecture/presentation/resources/color_manager.dart';
import 'package:clean_architecture/presentation/resources/route_manager.dart';
import 'package:clean_architecture/presentation/resources/strings_manager.dart';
import 'package:clean_architecture/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeViewModel _homeViewModel = instance<HomeViewModel>();

  _bind() {
    _homeViewModel.start();
  }

  @override
  void initState() {
    super.initState();
    _bind();
  }

  @override
  void dispose() {
    _homeViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: StreamBuilder<StateFlow>(
            stream: _homeViewModel.outputState,
            builder: ((context, snapshot) {
              return snapshot.data
                      ?.getScreenWidget(context, _getContentWidget(), () {
                    _homeViewModel.start();
                  }) ??
                  _getContentWidget();
            })),
      ),
    );
  }

  _getContentWidget() {
    return StreamBuilder<HomeData>(
        stream: _homeViewModel.outputHomeData,
        builder: ((context, snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getBannerWidget(snapshot.data?.bannersAd),
              _getSection(AppStrings.services.tr()),
              _getServicesWidget(snapshot.data?.services),
              _getSection(AppStrings.stores.tr()),
              _getStoresWidget(snapshot.data?.stores)
            ],
          );
        }));
  }

  Widget _getBannerWidget(List<BannersAd>? bannersList) {
    if (bannersList != null) {
      return CarouselSlider(
          // el items btakhod list of widgets w el banners parameter identified as list of bannsersAd model
          // fa lazem el banners a7welha l list of widgets using .map()
          items: bannersList.map((banner) {
            return SizedBox(
              width: double.infinity,
              child: Card(
                elevation: AppSizes.s4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.s12),
                    side: BorderSide(
                        color: ColorManager.primary, width: AppSizes.s1_5)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.s12),
                  child: Image.network(
                    banner.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }).toList(),
          options: CarouselOptions(
              height: AppSizes.s190,
              autoPlay: true,
              // enableInfiniteScroll: true,
              enlargeCenterPage: true));
    } else {
      return Container();
    }
  }

  Widget _getSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(
          left: AppPaddings.p12,
          right: AppPaddings.p12,
          top: AppPaddings.p14,
          bottom: AppPaddings.p8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  // Widget _getServices() {
  //   return StreamBuilder<HomeData>(
  //       stream: _homeViewModel.outputHomeData,
  //       builder: (context, snapshot) {
  //         return _getServicesWidget(snapshot.data);
  //       });
  // }

  Widget _getServicesWidget(List<Services>? servicesList) {
    if (servicesList != null) {
      return Padding(
        padding: const EdgeInsets.only(
            left: AppPaddings.p12, right: AppPaddings.p12),
        child: Container(
          height: AppSizes.s155,
          margin: const EdgeInsets.symmetric(vertical: AppMargins.m12),
          child: ListView(
            scrollDirection: Axis.horizontal,
            // el children btakhod list of widgets w el services parameter identified as list of Services model
            // fa lazem el services a7welha l list of widgets using .map()
            children: servicesList
                .map((service) => Card(
                      elevation: AppSizes.s4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSizes.s12),
                          side: BorderSide(
                              color: ColorManager.white, width: AppSizes.s1_5)),
                      child: Column(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppSizes.s12),
                          child: Image.network(
                            service.image,
                            fit: BoxFit.cover,
                            width: AppSizes.s120,
                            height: AppSizes.s120,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: AppPaddings.p8),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                service.title,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )),
                        ),
                      ]),
                    ))
                .toList(),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  // Widget _getStores() {
  //   return StreamBuilder<HomeData>(
  //       stream: _homeViewModel.outputHomeData,
  //       builder: (context, snapshot) {
  //         return _getStoresWidget(snapshot.data);
  //       });
  // }

  Widget _getStoresWidget(List<Stores>? storesList) {
    if (storesList != null) {
      return Padding(
        padding: const EdgeInsets.only(
            left: AppPaddings.p12,
            right: AppPaddings.p12,
            top: AppPaddings.p12),
        child: Flex(
          direction: Axis.vertical,
          children: [
            GridView.count(
              crossAxisCount: AppSizes.s2,
              crossAxisSpacing: AppSizes.s8,
              mainAxisSpacing: AppSizes.s8,
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              // ha3mel grid list clickable
              children: List.generate(storesList.length, (index) {
                return InkWell(
                  onTap: () {
                    // navigate to store details screen
                    Navigator.of(context).pushNamed(Routes.storeDetailsRoute);
                  },
                  child: Card(
                    elevation: AppSizes.s4,
                    child: Image.network(
                      storesList[index].image,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      );
    } else {
      return Container();
    }
  }
}
