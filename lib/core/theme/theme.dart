import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.0.2.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///  theme: AppTheme.light,
///  darkTheme: AppTheme.dark,
///  :
/// );
sealed class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    fontFamily: "Satoshi",
    scheme: FlexScheme.blue,
    appBarStyle: FlexAppBarStyle.primary,
    appBarElevation: 4.0,
    bottomAppBarElevation: 8.0,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
      defaultRadius: 4.0,
      elevatedButtonSchemeColor: SchemeColor.onPrimary,
      elevatedButtonSecondarySchemeColor: SchemeColor.primary,
      toggleButtonsBorderSchemeColor: SchemeColor.surfaceContainerHigh,
      segmentedButtonSchemeColor: SchemeColor.black,
      segmentedButtonSelectedForegroundSchemeColor: SchemeColor.secondary,
      segmentedButtonUnselectedSchemeColor: SchemeColor.black,
      segmentedButtonBorderSchemeColor: SchemeColor.transparent,
      inputDecoratorSchemeColor: SchemeColor.onSurface,
      inputDecoratorIsFilled: true,
      inputDecoratorContentPadding:
          EdgeInsetsDirectional.fromSTEB(14, 20, 14, 12),
      inputDecoratorBackgroundAlpha: 13,
      inputDecoratorBorderSchemeColor: SchemeColor.primary,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: false,
      listTileContentPadding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      listTileMinVerticalPadding: 4.0,
      fabUseShape: true,
      fabAlwaysCircular: true,
      fabSchemeColor: SchemeColor.secondary,
      chipSchemeColor: SchemeColor.surfaceContainerHigh,
      chipBlendColors: false,
      chipRadius: 4.0,
      chipIconSize: 16,
      chipPadding: EdgeInsetsDirectional.fromSTEB(6, 4, 6, 4),
      popupMenuRadius: 4.0,
      popupMenuElevation: 8.0,
      popupMenuSchemeColor: SchemeColor.surfaceContainerLow,
      alignedDropdown: true,
      tooltipRadius: 4,
      datePickerHeaderBackgroundSchemeColor: SchemeColor.primary,
      snackBarElevation: 0,
      snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
      appBarScrolledUnderElevation: 4.0,
      tabBarIndicatorSize: TabBarIndicatorSize.tab,
      tabBarIndicatorWeight: 2,
      tabBarIndicatorTopRadius: 0,
      tabBarDividerColor: Color(0x00000000),
      drawerElevation: 16.0,
      drawerWidth: 304.0,
      bottomSheetElevation: 10.0,
      bottomSheetModalElevation: 20.0,
      bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedLabel: true,
      bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedIcon: true,
      bottomNavigationBarElevation: 8.0,
      menuElevation: 8.0,
      menuBarRadius: 0.0,
      menuBarElevation: 1.0,
      searchBarBackgroundSchemeColor: SchemeColor.surfaceContainerLow,
      searchViewBackgroundSchemeColor: SchemeColor.surfaceContainerLow,
      searchBarElevation: 0.0,
      searchViewElevation: 0.0,
      searchUseGlobalShape: true,
      navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
      navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
      navigationBarMutedUnselectedLabel: true,
      navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
      navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
      navigationBarMutedUnselectedIcon: true,
      navigationBarIndicatorSchemeColor: SchemeColor.onSecondaryFixedVariant,
      navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
      navigationBarElevation: 0.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
      navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
      navigationRailMutedUnselectedLabel: true,
      navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
      navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
      navigationRailMutedUnselectedIcon: true,
      navigationRailUseIndicator: true,
      navigationRailIndicatorSchemeColor: SchemeColor.secondary,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    fontFamily: "Satoshi",
    scheme: FlexScheme.blue,
    appBarStyle: FlexAppBarStyle.material,
    appBarElevation: 4.0,
    bottomAppBarElevation: 8.0,
    tabBarStyle: FlexTabBarStyle.forAppBar,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useMaterial3Typography: true,
      useM2StyleDividerInM3: true,
      adaptiveElevationShadowsBack: FlexAdaptive.all(),
      adaptiveAppBarScrollUnderOff: FlexAdaptive.all(),
      defaultRadius: 4.0,
      elevatedButtonSchemeColor: SchemeColor.onPrimary,
      elevatedButtonSecondarySchemeColor: SchemeColor.primary,
      toggleButtonsBorderSchemeColor: SchemeColor.surfaceContainerHigh,
      segmentedButtonSchemeColor: SchemeColor.black,
      segmentedButtonSelectedForegroundSchemeColor: SchemeColor.secondary,
      segmentedButtonUnselectedSchemeColor: SchemeColor.black,
      segmentedButtonBorderSchemeColor: SchemeColor.transparent,
      inputDecoratorIsFilled: true,
      inputDecoratorContentPadding:
          EdgeInsetsDirectional.fromSTEB(14, 20, 14, 12),
      inputDecoratorBackgroundAlpha: 20,
      inputDecoratorBorderType: FlexInputBorderType.outline,
      inputDecoratorUnfocusedHasBorder: false,
      listTileContentPadding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      listTileMinVerticalPadding: 4.0,
      fabUseShape: true,
      fabAlwaysCircular: true,
      fabSchemeColor: SchemeColor.secondary,
      chipSchemeColor: SchemeColor.surfaceContainerHigh,
      chipBlendColors: false,
      chipRadius: 4.0,
      chipIconSize: 16,
      chipPadding: EdgeInsetsDirectional.fromSTEB(6, 4, 6, 4),
      popupMenuRadius: 4.0,
      popupMenuElevation: 8.0,
      popupMenuSchemeColor: SchemeColor.surfaceContainerLow,
      alignedDropdown: true,
      tooltipRadius: 4,
      datePickerHeaderBackgroundSchemeColor: SchemeColor.primary,
      snackBarElevation: 0,
      snackBarBackgroundSchemeColor: SchemeColor.inverseSurface,
      appBarScrolledUnderElevation: 4.0,
      bottomAppBarSchemeColor: SchemeColor.surface,
      tabBarIndicatorSize: TabBarIndicatorSize.tab,
      tabBarIndicatorWeight: 2,
      tabBarIndicatorTopRadius: 0,
      tabBarDividerColor: Color(0x00000000),
      drawerElevation: 16.0,
      drawerWidth: 304.0,
      bottomSheetElevation: 10.0,
      bottomSheetModalElevation: 20.0,
      bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedLabel: true,
      bottomNavigationBarSelectedIconSchemeColor: SchemeColor.primary,
      bottomNavigationBarMutedUnselectedIcon: true,
      bottomNavigationBarElevation: 8.0,
      menuElevation: 8.0,
      menuBarRadius: 0.0,
      menuBarElevation: 1.0,
      searchBarBackgroundSchemeColor: SchemeColor.surfaceContainerLow,
      searchViewBackgroundSchemeColor: SchemeColor.surfaceContainerLow,
      searchBarElevation: 0.0,
      searchViewElevation: 0.0,
      searchUseGlobalShape: true,
      navigationBarSelectedLabelSchemeColor: SchemeColor.onSurface,
      navigationBarUnselectedLabelSchemeColor: SchemeColor.onSurface,
      navigationBarMutedUnselectedLabel: true,
      navigationBarSelectedIconSchemeColor: SchemeColor.onSurface,
      navigationBarUnselectedIconSchemeColor: SchemeColor.onSurface,
      navigationBarMutedUnselectedIcon: true,
      navigationBarIndicatorSchemeColor: SchemeColor.onSecondaryFixedVariant,
      navigationBarBackgroundSchemeColor: SchemeColor.surfaceContainer,
      navigationBarElevation: 0.0,
      navigationRailSelectedLabelSchemeColor: SchemeColor.onSurface,
      navigationRailUnselectedLabelSchemeColor: SchemeColor.onSurface,
      navigationRailMutedUnselectedLabel: true,
      navigationRailSelectedIconSchemeColor: SchemeColor.onSurface,
      navigationRailUnselectedIconSchemeColor: SchemeColor.onSurface,
      navigationRailMutedUnselectedIcon: true,
      navigationRailUseIndicator: true,
      navigationRailIndicatorSchemeColor: SchemeColor.secondary,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}