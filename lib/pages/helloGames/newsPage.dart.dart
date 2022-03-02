import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../components/tilePresenters/helloGamesTilePresenter.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/helloGames/newsItem.dart';
import '../../helpers/searchHelpers.dart';
import '../../integration/dependencyInjection.dart';

class NewsPage extends StatelessWidget {
  NewsPage() {
    getAnalytics().trackEvent(AnalyticsEvent.newsPage);
  }
  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.news),
      body: SearchableList<NewsItem>(
        () => getHelloGamesApiService().getNews(),
        listItemDisplayer: newsItemTilePresenter,
        listItemSearch: searchNews,
      ),
    );
  }
}
