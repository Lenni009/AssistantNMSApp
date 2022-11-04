import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart'
    hide UIConstants;
import 'package:flutter/material.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';

import '../../constants/AnalyticsEvent.dart';
import '../../contracts/enum/appType.dart';
import '../../contracts/generated/feedbackAnsweredViewModel.dart';
import '../../contracts/generated/feedbackQuestionAnsweredViewModel.dart';
import '../../contracts/generated/feedbackViewModel.dart';
import '../../integration/dependencyInjection.dart';
import 'feedbackQuestionsPage.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({Key key}) : super(key: key) {
    getAnalytics().trackEvent(AnalyticsEvent.feedbackPage);
  }

  @override
  Widget build(BuildContext context) {
    return simpleGenericPageScaffold(
      context,
      title: getTranslations().fromKey(LocaleKey.feedback),
      body: FutureBuilder(
        future: getApiRepo().getLatestFeedbackForm(),
        builder: getBody,
      ),
    );
  }

  Widget getBody(BuildContext context,
      AsyncSnapshot<ResultWithValue<FeedbackViewModel>> snapshot) {
    Widget errorWidget = asyncSnapshotHandler(
      context,
      snapshot,
      isValidFunction: (ResultWithValue<FeedbackViewModel> result) {
        if (snapshot.data.value == null ||
            snapshot.data.value.guid == null ||
            snapshot.data.value.name == null ||
            snapshot.data.value.questions == null ||
            snapshot.data.value.questions.isEmpty) {
          return false;
        }
        return true;
      },
      invalidBuilder: () => listWithScrollbar(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Container(
            child: Text(
              getTranslations().fromKey(LocaleKey.somethingWentWrong),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 20),
            ),
            margin: const EdgeInsets.only(top: 30),
          );
        },
      ),
    );
    if (errorWidget != null) return errorWidget;

    FeedbackViewModel feedbackForm = snapshot.data.value;
    FeedbackAnsweredViewModel answerForm = FeedbackAnsweredViewModel();
    answerForm.feedbackGuid = feedbackForm.guid;
    answerForm.appType = getAppTypeForPlatform();
    answerForm.answers = feedbackForm.questions
        .map(
          (q) => FeedbackQuestionAnsweredViewModel(
            feedbackQuestionGuid: q.guid,
            answer: '',
          ),
        )
        .toList();
    return FeedbackQuestionsPage(
      feedbackForm: feedbackForm,
      answerForm: answerForm,
    );
  }

  AppType getAppTypeForPlatform() {
    AppType platType = AppType.Web;
    if (isiOS) platType = AppType.Ios;
    if (isAndroid) platType = AppType.Android;

    return platType;
  }
}
