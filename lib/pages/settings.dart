import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../constants/Platforms.dart';

import '../components/modalBottomSheet/logsModalBottomSheet.dart';
import '../components/scaffoldTemplates/genericPageScaffold.dart';
import '../components/tilePresenters/settingTilePresenter.dart';
import '../constants/AnalyticsEvent.dart';
import '../constants/Fonts.dart';
import '../constants/HomepageItems.dart';
import '../contracts/enum/homepageType.dart';
import '../contracts/redux/appState.dart';
import '../helpers/uselessButtonHelper.dart';
import '../redux/modules/setting/settingViewModel.dart';

class Settings extends StatelessWidget {
  final void Function(Locale locale) onLocaleChange;
  Settings(this.onLocaleChange, {Key key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.settingsPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.settings),
      body: StoreConnector<AppState, SettingViewModel>(
        converter: (store) => SettingViewModel.fromStore(store),
        builder: (_, viewModel) => getBody(context, viewModel),
      ),
    );
  }

  Widget getBody(BuildContext context, SettingViewModel viewModel) {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(headingSettingTilePresenter(
        getTranslations().fromKey(LocaleKey.general)));

    widgets.add(languageSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.appLanguage),
      viewModel.selectedLanguage,
      onChange: (Locale locale) => onLocaleChange(locale),
    ));

    // widgets.add(boolSettingTilePresenter(
    //   context,
    //   getTranslations().fromKey(LocaleKey.darkModeEnabled),
    //   getTheme().getIsDark(context),
    //   onChange: () => this._changeBrightness(context),
    // ));

    widgets.add(boolSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.homeUseCompactTiles),
      viewModel.genericTileIsCompact,
      onChange: viewModel.toggleGenericTileIsCompact,
    ));

    widgets.add(boolSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.guidesUseCompactTiles),
      viewModel.guidesIsCompact,
      onChange: viewModel.toggleGuideIsCompact,
    ));

    if (isApple) {
      widgets.add(boolSettingTilePresenter(
        context,
        getTranslations().fromKey(LocaleKey.useMaterialTheme),
        viewModel.showMaterialTheme,
        onChange: viewModel.toggleShowMaterialTheme,
      ));
    }

    widgets.add(boolSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.showItemBackgroundColours),
      viewModel.displayGenericItemColour,
      onChange: viewModel.toggleDisplayGenericItemColour,
    ));

    widgets.add(listSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.platform),
      SelectedPlatform.getFromValue(viewModel.platformIndex).title,
      availablePlatforms
          .map((hp) => DropdownOption(
                hp.title,
                value: hp.index.toString(),
              ))
          .toList(),
      onChange: (String newValue) {
        if (newValue == null) return;
        int intValue = int.tryParse(newValue);
        if (intValue == null) return;
        viewModel.setPlatformIndex(intValue);
      },
    ));

    widgets.add(listSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.settingsFont),
      getTranslations().fromKey(
        SelectedFont.getFromFontFamily(viewModel.fontFamily).localeKey,
      ),
      availableFonts
          .map((hp) => DropdownOption(
                getTranslations().fromKey(hp.localeKey),
                value: hp.fontFamily.toString(),
              ))
          .toList(),
      onChange: (String newValue) {
        viewModel.setFontFamily(newValue);
        getTheme().setFontFamily(context, newValue);
      },
    ));

    widgets.add(listSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.homepage),
      getTranslations().fromKey(
        getLocaleFromHomepageType(viewModel.homepageType),
      ),
      homepageItems
          .map((hp) => DropdownOption(
                getTranslations().fromKey(hp.localeKey),
                value: hp.localeKey.toString(),
              ))
          .toList(),
      onChange: (String newValue) {
        HomepageItem homepageItem = HomepageItem.defaultHomepageItem();
        for (HomepageItem item in homepageItems) {
          if (item.localeKey.toString() == newValue) {
            homepageItem = item;
          }
        }

        if (viewModel.homepageType != homepageItem.homepageType) {
          viewModel.setHomepageType(homepageItem.homepageType);
          getNavigation().navigateHomeAsync(
            context,
            navigateToNamed: HomepageItem.getByType(
              homepageItem.homepageType,
            ).routeToNamed,
            pushReplacement: true,
          );
        }
      },
    ));

    widgets.add(boolSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.hideSpoilerWarnings),
      viewModel.dontShowSpoilerAlert,
      onChange: viewModel.setShowSpoilerAlert,
    ));

    if (isValentinesPeriod()) {
      widgets.add(boolSettingTilePresenter(
        context,
        getTranslations().fromKey(LocaleKey.displaySeasonalBackground),
        viewModel.showFestiveBackground,
        onChange: () => viewModel.setShowFestiveBackground(
          !viewModel.showFestiveBackground,
        ),
      ));
    }

    widgets.add(patreonCodeSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.patreonAccess),
      viewModel.isPatron,
      onChange: viewModel.setIsPatron,
    ));

    widgets.add(
      headingSettingTilePresenter(getTranslations().fromKey(LocaleKey.portals)),
    );

    widgets.add(boolSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.useAltGlyphs),
      viewModel.useAltGlyphs,
      onChange: viewModel.toggleAltGlyphs,
    ));

    widgets.add(
      headingSettingTilePresenter(getTranslations().fromKey(LocaleKey.other)),
    );

    widgets.add(linkSettingTilePresenter(
      context,
      'Logs',
      icon: Icons.code,
      onTap: () => adaptiveBottomModalSheet(
        context,
        hasRoundedCorners: true,
        builder: (BuildContext innerContext) => const LogsModalBottomSheet(),
      ),
    ));

    widgets.add(linkSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.privacyPolicy),
      icon: Icons.description,
      onTap: () => launchExternalURL(ExternalUrls.privacyPolicy),
    ));

    widgets.add(linkSettingTilePresenter(
      context,
      getTranslations().fromKey(LocaleKey.termsAndConditions),
      icon: Icons.description,
      onTap: () => launchExternalURL(ExternalUrls.termsAndConditions),
    ));

    widgets.add(legalTilePresenter());

    if (viewModel.selectedLanguage == 'en') {
      widgets.add(positiveButton(
        title: 'Useless button',
        colour: getTheme().getSecondaryColour(context),
        onPress: () => uselessButtonFunc(context, viewModel.uselessButtonTaps,
            viewModel.increaseUselessButtonTaps),
      ));
    }

    widgets.add(emptySpace3x());

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }

  // void _changeBrightness(BuildContext context) {
  //   bool isDark = getTheme().getIsDark(context);
  //   getTheme().setBrightness(context, isDark);
  //   getAnalytics().trackEvent(
  //     isDark ? AnalyticsEvent.lightMode : AnalyticsEvent.darkMode,
  //   );
  // }
}
