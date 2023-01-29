import 'package:clean_architecture/presentation/resources/color_manager.dart';
import 'package:clean_architecture/presentation/resources/font_manager.dart';
import 'package:clean_architecture/presentation/resources/styles_manager.dart';
import 'package:clean_architecture/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // Main Colors
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.lightPrimary,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.grey1,

    //Card View theme
    cardTheme: CardTheme(
        color: ColorManager.white,
        elevation: AppSizes.s4,
        shadowColor: ColorManager.grey),

    //App Bar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorManager.primary,
      shadowColor: ColorManager.lightPrimary,
      elevation: AppSizes.s4,
      titleTextStyle: getRegularStyle(
          color: ColorManager.white, fontSize: FontSizeManager.s16),
    ),

    //button theme
    buttonTheme: ButtonThemeData(
        shape: const StadiumBorder(), // ya3ne button rounded from the corners
        buttonColor: ColorManager.primary,
        splashColor: ColorManager.lightPrimary,
        disabledColor: ColorManager.grey1),

    //Elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            textStyle: getRegularStyle(
                color: ColorManager.white, fontSize: FontSizeManager.s16),
            primary: ColorManager.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.s12)))),

    //Text theme
    textTheme: TextTheme(
        headlineLarge: getLightStyle(
            color: ColorManager.white, fontSize: FontSizeManager.s16),
        titleMedium: getMediumStyle(
            color: ColorManager.primary, fontSize: FontSizeManager.s16),
        bodyMedium: getRegularStyle(
            color: ColorManager.grey1, fontSize: FontSizeManager.s14),
        bodySmall: getRegularStyle(
            color: ColorManager.white, fontSize: FontSizeManager.s16),
        headlineMedium: getRegularStyle(color: ColorManager.darkGrey),
        displayLarge: getSemiBoldStyle(
            color: ColorManager.darkGrey, fontSize: FontSizeManager.s22)),

    //Input Decoration theme (TextForm field)
    inputDecorationTheme: InputDecorationTheme(
      //content padding
      contentPadding: const EdgeInsets.all(AppPaddings.p8),

      //hint style
      hintStyle: getRegularStyle(
          color: ColorManager.grey, fontSize: FontSizeManager.s14),

      //label style
      labelStyle: getRegularStyle(
          color: ColorManager.grey, fontSize: FontSizeManager.s14),

      //error style
      errorStyle: getRegularStyle(color: ColorManager.error),

      //enabled Border
      enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorManager.grey, width: AppSizes.s1_5),
          borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s8))),

      //focused Border
      focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorManager.primary, width: AppSizes.s1_5),
          borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s8))),

      //error border
      errorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorManager.error, width: AppSizes.s1_5),
          borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s8))),

      //focused error border
      focusedErrorBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorManager.primary, width: AppSizes.s1_5),
          borderRadius: const BorderRadius.all(Radius.circular(AppSizes.s8))),
    ),
  );
}
