// ignore_for_file: no_logic_in_create_state

import 'package:after_layout/after_layout.dart';
import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../components/common/dotPagination.dart';
import '../../../components/common/image.dart';
import '../../../components/portal/portalGlyphList.dart';
import '../../../components/tilePresenters/requiredItemDetailsTilePresenter.dart';
import '../../../components/tilePresenters/youtubersTilePresenter.dart';
import '../../../contracts/generated/weekendMissionViewModel.dart';
import '../../../contracts/redux/appState.dart';
import '../../../contracts/requiredItemDetails.dart';
import '../../../contracts/weekendMission.dart';
import '../../../contracts/weekendStagePageItem.dart';
import '../../../helpers/hexHelper.dart';
import '../../../integration/dependencyInjection.dart';
import '../../../redux/modules/portal/portalGlyphViewModel.dart';
import 'weekendMissionDialog.dart';

class WeekendMissionDetail extends StatefulWidget {
  final int weekendMissionLevelMin;
  final int weekendMissionLevelMax;
  final WeekendStagePageItem pageItem;
  final Future<ResultWithValue<WeekendStagePageItem>> Function(
          BuildContext context, String seasonId, int level)
      getWeekendMissionSeasonData;
  const WeekendMissionDetail(this.pageItem, this.getWeekendMissionSeasonData,
      this.weekendMissionLevelMin, this.weekendMissionLevelMax,
      {Key key})
      : super(key: key);

  @override
  _WeekendMissionDetailWidget createState() =>
      _WeekendMissionDetailWidget(pageItem, getWeekendMissionSeasonData);
}

class _WeekendMissionDetailWidget extends State<WeekendMissionDetail>
    with AfterLayoutMixin<WeekendMissionDetail> {
  List<int> isLoadingAdditionalDetails = List.empty(growable: true);
  List<Widget> additionalDetails = List.empty(growable: true);
  WeekendStagePageItem pageItem;
  final Future<ResultWithValue<WeekendStagePageItem>> Function(
          BuildContext context, String seasonId, int level)
      getWeekendMissionSeasonData;

  _WeekendMissionDetailWidget(this.pageItem, this.getWeekendMissionSeasonData) {
    isLoadingAdditionalDetails.add(pageItem.stage.level);
  }

  @override
  void afterFirstLayout(BuildContext context) {
    if (pageItem == null) return;
    if (pageItem.stage == null) return;
    if (pageItem.stage.level == null) return;
    getMissionExtraDetails(context, pageItem.stage.level);
  }

  Future<void> getMission(BuildContext context, int newLevel) async {
    if (newLevel > widget.weekendMissionLevelMax) return;
    if (newLevel < widget.weekendMissionLevelMin) return;
    if (!mounted) return;

    setState(() {
      isLoadingAdditionalDetails.add(newLevel);
    });

    var localWeekendMissionDataResult =
        await getWeekendMissionSeasonData(context, pageItem.season, newLevel);
    if (localWeekendMissionDataResult.hasFailed) return;

    setState(() {
      pageItem = localWeekendMissionDataResult.value;
    });
    await getMissionExtraDetails(context, newLevel);
  }

  Future<void> getMissionExtraDetails(
      BuildContext context, int newLevel) async {
    ResultWithValue<WeekendMissionViewModel> apiResult =
        await getHelloGamesApiService().getWeekendMissionFromSeasonAndLevel(
      pageItem.season,
      newLevel,
    );
    if (!mounted) return;

    if (!apiResult.isSuccess) {
      setState(() {
        isLoadingAdditionalDetails.remove(newLevel);
        additionalDetails = List.empty(growable: true);
      });
      return;
    }

    setState(() {
      isLoadingAdditionalDetails.remove(newLevel);
      if (apiResult.isSuccess &&
          apiResult.value.level == pageItem.stage.level) {
        additionalDetails =
            getAdditionalWidgetsFromVM(context, apiResult.value);
      }
    });
  }

  List<Widget> getAdditionalWidgetsFromVM(
      BuildContext context, WeekendMissionViewModel viewmodel) {
    // var isConfirmedByCaptSteve = viewmodel.isConfirmedByCaptSteve ?? false;
    // var isConfirmedByAssistantNms =
    //     viewmodel.isConfirmedByAssistantNms ?? false;
    var captainSteveVideoUrl = viewmodel.captainSteveVideoUrl ?? '';
    return getAdditionalWidgets(
      context,
      captainSteveVideoUrl,
    );
  }

  List<Widget> getAdditionalWidgets(
      BuildContext context, String captainSteveVideoUrl) {
    List<Widget> additionalWidgets = List.empty(growable: true);
    if (captainSteveVideoUrl != null && captainSteveVideoUrl.length > 5) {
      additionalWidgets.add(emptySpace(2));
      additionalWidgets.add(customDivider());
      additionalWidgets.add(emptySpace1x());
      additionalWidgets.add(genericItemDescription(
          getTranslations().fromKey(LocaleKey.weekendMissionVideo)));
      additionalWidgets.add(
        Card(
          child: captainSteveYoutubeVideoTile(context, captainSteveVideoUrl),
          margin: EdgeInsets.zero,
        ),
      );
    }
    return additionalWidgets;
  }

  @override
  Widget build(BuildContext context) {
    if (pageItem == null || pageItem.stage == null) {
      return getLoading().customErrorWidget(context);
    }

    List<Widget> widgets = List.empty(growable: true);

    if (pageItem.iteration != null) {
      widgets.add(genericItemImage(
        context,
        pageItem.iteration.icon,
        disableZoom: true,
      ));
    }
    widgets.add(genericItemDescription(pageItem.stage.npcMessage));

    if (pageItem.stage.npcMessageFlows != null) {
      widgets.add(messageFlowsButton(context, pageItem.stage.npcMessageFlows));
    }

    if (pageItem.cost != null) {
      widgets.add(emptySpace1x());
      widgets.add(customDivider());
      widgets.add(emptySpace1x());

      widgets.add(genericItemDescription(
          getTranslations().fromKey(LocaleKey.requiresTheFollowing)));
      widgets.add(flatCard(
        child: requiredItemDetailsTilePresenter(
          context,
          RequiredItemDetails.fromGenericPageItem(
            pageItem.cost,
            pageItem.stage.quantity,
          ),
        ),
      ));
    }

    if (pageItem.stage.portalMessageFlows != null) {
      widgets.add(emptySpace1x());
      widgets.add(
        messageFlowsButton(context, pageItem.stage.portalMessageFlows),
      );
    }

    if (isLoadingAdditionalDetails.contains(pageItem.stage.level)) {
      widgets.add(emptySpace1x());
      widgets.add(customDivider());
      widgets.add(emptySpace1x());
      widgets.add(Center(child: getLoading().smallLoadingIndicator()));
    } else {
      widgets.addAll(additionalDetails);
    }

    widgets.add(emptySpace1x());
    widgets.add(customDivider());
    widgets.add(emptySpace1x());

    widgets.add(genericItemDescription(
      getTranslations().fromKey(LocaleKey.portalAddress),
    ));

    if (pageItem.stage.portalAddress != null) {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: StoreConnector<AppState, PortalGlyphViewModel>(
          converter: (store) => PortalGlyphViewModel.fromStore(store),
          builder: (_, viewModel) => portalGlyphList(
              hexToIntArray(pageItem.stage.portalAddress), 6,
              useAltGlyphs: viewModel.useAltGlyphs),
        ),
      ));
      widgets.add(
        flatCard(
          child: cyberpunk2350Tile(context,
              subtitle: 'Portal address information discovered by'),
        ),
      );
    }

    widgets.add(emptySpace(16));

    var pageContent = ListView(
      children: [
        Padding(
          child: Text(
            pageItem.stage.level.toString(),
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          padding: const EdgeInsets.only(top: 12),
        ),
        ...widgets,
      ],
    );
    // return pageContent;
    return SwipeTo(
      child: dotPagination(
        context,
        content: pageContent,
        currentPosition: pageItem.stage.level - widget.weekendMissionLevelMin,
        numberOfDots:
            (widget.weekendMissionLevelMax - widget.weekendMissionLevelMin) + 1,
        nextLocaleKey: LocaleKey.nextWeekendMission,
        prevLocaleKey: LocaleKey.previousWeekendMission,
        onDotTap: (int dotIndex) => getMission(
          context,
          (dotIndex + widget.weekendMissionLevelMin).toInt(),
        ),
      ),
      offsetDx: 0.5,
      iconSize: 42,
      iconOnRightSwipe: Icons.chevron_left,
      onRightSwipe: () => getMission(
        context,
        pageItem.stage.level - 1,
      ),
      iconOnLeftSwipe: Icons.chevron_right,
      onLeftSwipe: () => getMission(
        context,
        pageItem.stage.level + 1,
      ),
    );
  }

  Widget messageFlowsButton(BuildContext context, MessageFlow flow) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            getTheme().getSecondaryColour(context),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.chat),
            ),
            Text(getTranslations().fromKey(LocaleKey.readConversation),
                textAlign: TextAlign.center)
          ],
        ),
        onPressed: () {
          adaptiveBottomModalSheet(
            context,
            builder: (context) => WeekendMissionDialogPage(
              flow,
            ),
          );
        },
      ),
    );
  }
}
