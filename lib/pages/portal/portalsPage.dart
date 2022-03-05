import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/dialogs/baseDialog.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/portalTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/portal/portalRecord.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/searchHelpers.dart';
import '../../redux/modules/portal/portalViewModel.dart';
import 'addPortalPage.dart';
import 'viewPortalPage.dart';

class PortalsPage extends StatefulWidget {
  const PortalsPage({Key key}) : super(key: key);

  @override
  _PortalsPageState createState() => _PortalsPageState();
}

class _PortalsPageState extends State<PortalsPage> {
  int _counter = 0;
  _PortalsPageState() {
    getAnalytics().trackEvent(AnalyticsEvent.portalPage);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PortalViewModel>(
      converter: (store) => PortalViewModel.fromStore(store),
      builder: (_, portalViewModel) => basicGenericPageScaffold(
        context,
        title: getTranslations().fromKey(LocaleKey.savedPortalCoordinates),
        actions: [
          ActionItem(
            icon: Icons.help_outline,
            onPressed: () => getDialog().showSimpleHelpDialog(
              context,
              getTranslations().fromKey(LocaleKey.help),
              getTranslations().fromKey(LocaleKey.cartContent),
            ),
          )
        ],
        body: getBody(context, portalViewModel),
        fab: FloatingActionButton(
          onPressed: () async {
            PortalRecord temp =
                await getNavigation().navigateAsync<PortalRecord>(
              context,
              navigateTo: (context) => AddPortalPage(
                PortalRecord(
                    codes: List.empty(growable: true),
                    tags: List.empty(growable: true)),
              ),
            );
            if (temp == null || temp is! PortalRecord) return;
            portalViewModel.addPortal(temp.name, temp.codes, temp.tags);
            setState(() {
              _counter++;
            });
          },
          heroTag: 'PortalsPage',
          child: const Icon(Icons.add),
          foregroundColor: getTheme().fabForegroundColourSelector(context),
          backgroundColor: getTheme().fabColourSelector(context),
        ),
      ),
    );
  }

  Widget getBody(BuildContext context, PortalViewModel portalViewModel) {
    return SearchableList<PortalRecord>(
      getSearchListFutureFromList(portalViewModel.portals),
      listItemDisplayer: (BuildContext context, PortalRecord portal) =>
          portalTilePresenter(
        context,
        portal,
        useAltGlyphs: portalViewModel.useAltGlyphs,
        onTap: () => onTap(portal),
        onEdit: () => onEdit(portal, portalViewModel),
        onDelete: () => onDelete(portal, portalViewModel),
      ),
      listItemSearch: searchPortal,
      deleteAll: () => deleteAll(portalViewModel),
      key: Key(
        'numItems: ${portalViewModel.portals.length.toString()} counter: $_counter useAltGlyphs: ${portalViewModel.useAltGlyphs}',
      ),
      minListForSearch: 5,
    );
  }

  void onTap(PortalRecord portal) async {
    await getNavigation().navigateAsync(
      context,
      navigateTo: (context) => ViewPortalPage(portal),
    );
    setState(() {
      _counter++;
    });
  }

  void onEdit(PortalRecord portal, PortalViewModel portalViewModel) async {
    PortalRecord temp = await getNavigation().navigateAsync<PortalRecord>(
      context,
      navigateTo: (context) => AddPortalPage(portal, isEdit: true),
    );
    if (temp == null || temp is! PortalRecord) return;
    portalViewModel.editPortal(
      temp.name,
      temp.codes,
      temp.tags,
      temp.uuid,
    );
    setState(() {
      _counter++;
    });
  }

  void onDelete(PortalRecord portal, PortalViewModel portalViewModel) {
    simpleDialog(
      context,
      getTranslations().fromKey(LocaleKey.delete),
      getTranslations().fromKey(LocaleKey.areYouSure),
      buttons: [
        simpleDialogCloseButton(context),
        simpleDialogPositiveButton(context,
            title: LocaleKey.yes,
            onTap: () => portalViewModel.removePortal(portal.uuid)),
      ],
    );
  }

  void deleteAll(PortalViewModel portalViewModel) {
    simpleDialog(
      context,
      getTranslations().fromKey(LocaleKey.deleteAll),
      getTranslations().fromKey(LocaleKey.areYouSure),
      buttons: [
        simpleDialogCloseButton(context),
        simpleDialogPositiveButton(context,
            title: LocaleKey.yes,
            onTap: () => portalViewModel.removeAllPortals()),
      ],
    );
  }
}
