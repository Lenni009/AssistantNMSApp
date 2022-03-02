import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../helpers/searchHelpers.dart';
import '../../contracts/nmsfm/nmsfmTrackData.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/nmsfmTrackDataTilePresenter.dart';
import '../../integration/dependencyInjection.dart';

class NMSFMTrackListPage extends StatefulWidget {
  @override
  _NMSFMTrackListPageWidget createState() => _NMSFMTrackListPageWidget();
}

class _NMSFMTrackListPageWidget extends State<NMSFMTrackListPage> {
  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.nmsfm),
      body: SearchableList<NmsfmTrackData>(
        () => getApiRepo().getNmsfmTrackList(),
        listItemDisplayer: nmsfmTrackTilePresenter,
        listItemSearch: searchNmsfm,
        addFabPadding: true,
        key: Key(getTranslations().currentLanguage),
      ),
    );
  }
}
