import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_image.dart';
import '../../../constants/nms_external_urls.dart';
import '../../../contracts/enum/community_mission_status.dart';
import '../../../contracts/helloGames/community_mission_tracked.dart';
import '../../../integration/dependencyInjection.dart';

class CommunityMissionExtraData extends StatelessWidget {
  final int missionId;
  final CommunityMissionStatus status;

  const CommunityMissionExtraData(
    this.missionId,
    this.status, {
    Key? key,
  }) : super(key: key);

  Future<ResultWithValue<CommunityMissionExtraDataPageData>>
      getExtraCommunityMissionData(int localMissionId) async {
    if (status == CommunityMissionStatus.future) {
      return ResultWithValue<CommunityMissionExtraDataPageData>(
        false,
        CommunityMissionExtraDataPageData.initial(),
        '',
      );
    }

    ResultWithValue<List<CommunityMissionTracked>> apiResult =
        await getCommunityMissionProgressApiService()
            .getProgressByMission(localMissionId);
    if (apiResult.isSuccess == false || apiResult.value.isEmpty) {
      return ResultWithValue<CommunityMissionExtraDataPageData>(
        false,
        CommunityMissionExtraDataPageData.initial(),
        '',
      );
    }

    CommunityMissionExtraDataPageData data = CommunityMissionExtraDataPageData(
      startDateRecorded: apiResult.value.first.dateRecorded,
      endDateRecorded: apiResult.value.last.dateRecorded,
    );
    return ResultWithValue<CommunityMissionExtraDataPageData>(true, data, '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getExtraCommunityMissionData(missionId),
      builder: (
        BuildContext bodyContext,
        AsyncSnapshot<ResultWithValue<CommunityMissionExtraDataPageData>>
            snapshot,
      ) {
        bool showLoader = false;

        Widget Function() errorWidgetFunc;
        errorWidgetFunc = () => const EmptySpace1x();

        switch (snapshot.connectionState) {
          case ConnectionState.none:
            showLoader = true;
            break;
          case ConnectionState.done:
            if (snapshot.hasError) {
              return errorWidgetFunc();
            }
            break;
          default:
            showLoader = true;
            break;
        }

        List<Widget> widgets = List.empty(growable: true);

        widgets.add(const EmptySpace2x());
        widgets.add(FlatCard(
          child: genericListTileWithSubtitle(
            bodyContext,
            leadingImage: AppImage.communityMissionProgress,
            name: 'Community Mission Progress Tracker', //TODO translate
            subtitle: const Text('Data below supplied by the NMSCD'),
            trailing: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.open_in_new_rounded),
            ),
            onTap: () =>
                launchExternalURL(NmsExternalUrls.communityMissionProgress),
          ),
        ));

        if (showLoader == false) {
          if (snapshot.data == null ||
              snapshot.data?.value == null ||
              snapshot.data?.value.startDateRecorded == null ||
              snapshot.data?.value.endDateRecorded == null) {
            return errorWidgetFunc();
          }

          CommunityMissionExtraDataPageData pageData = snapshot.data!.value;

          widgets.add(ListTile(
            title: Text(getTranslations().fromKey(LocaleKey.startDate)),
            subtitle: Text(_getDateTimeString(pageData.startDateRecorded)),
            onTap: () =>
                launchExternalURL(NmsExternalUrls.communityMissionProgress),
          ));

          if (status == CommunityMissionStatus.past) {
            widgets.add(ListTile(
              title: Text(getTranslations().fromKey(LocaleKey.endDate)),
              subtitle: Text(_getDateTimeString(pageData.endDateRecorded)),
              onTap: () =>
                  launchExternalURL(NmsExternalUrls.communityMissionProgress),
            ));
          }
        } else {
          widgets.add(getLoading().smallLoadingTile(bodyContext));
        }

        if (snapshot.data == null || snapshot.data!.hasFailed) {
          return errorWidgetFunc();
        }

        return animateWidgetIn(
          child: Column(children: widgets),
        );
      },
    );
  }

  String _getDateTimeString(DateTime dateTimeObj) {
    DateTime utcDate = DateTime.utc(
      dateTimeObj.year,
      dateTimeObj.month,
      dateTimeObj.day,
      dateTimeObj.hour,
      dateTimeObj.minute,
      dateTimeObj.second,
    );
    final convertedDate = utcDate.toLocal();

    String result = '${convertedDate.year}-';
    result += padString(convertedDate.month.toString(), 2);
    result += '-';
    result += padString(convertedDate.day.toString(), 2);
    result += ' ';
    result += padString(convertedDate.hour.toString(), 2);
    result += ':';
    result += padString(convertedDate.minute.toString(), 2);

    // int utcOffsetMinutes = convertedDate.timeZoneOffset.inMinutes;
    // int utcOffsetHours = utcOffsetMinutes ~/ 60;
    // int utcOffsetMinutesLeft = utcOffsetMinutes - (utcOffsetHours * 60);
    // result += ' (';
    // result += padString(utcOffsetHours.toString(), 2);
    // result += ':';
    // result += padString(utcOffsetMinutesLeft.toString(), 2);
    // result += ')';

    result += ' (${convertedDate.timeZoneName})';
    return result;
  }
}
