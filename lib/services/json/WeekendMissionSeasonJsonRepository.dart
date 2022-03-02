import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/weekendMission.dart';

import 'interface/IWeekendMissionSeasonJsonRepository.dart';

class WeekendMissionSeasonJsonRepository extends BaseJsonService
    implements IWeekendMissionSeasonJsonRepository {
  LocaleKey _jsonLocale;

  WeekendMissionSeasonJsonRepository(this._jsonLocale);

  @override
  Future<ResultWithValue<List<WeekendMission>>> getAll(
      BuildContext context) async {
    String jsonFile = getTranslations().fromKey(_jsonLocale);
    try {
      List list = await this.getListfromJson(context, jsonFile);
      List<WeekendMission> weekendMission =
          list.map((m) => WeekendMission.fromJson(m)).toList();
      return ResultWithValue<List<WeekendMission>>(true, weekendMission, '');
    } catch (exception) {
      getLog().e(
          "WeekendMissionJsonRepository getAll Exception: ${exception.toString()}");
      return ResultWithValue<List<WeekendMission>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<WeekendMission>> getMissionById(
      context, String seasonId) async {
    ResultWithValue<List<WeekendMission>> allGenericItemsResult =
        await this.getAll(context);
    if (allGenericItemsResult.hasFailed) {
      return ResultWithValue(
          false, WeekendMission(), allGenericItemsResult.errorMessage);
    }
    try {
      WeekendMission selectedGeneric =
          allGenericItemsResult.value.firstWhere((r) => r.id == seasonId);
      return ResultWithValue<WeekendMission>(true, selectedGeneric, '');
    } catch (exception) {
      getLog().e(
          "WeekendMissionJsonRepository getMissionById Exception: ${exception.toString()}");
      return ResultWithValue<WeekendMission>(
          false, WeekendMission(), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<WeekendStage>> getStageById(
      context, String seasonId, int level) async {
    ResultWithValue<WeekendMission> missionResult =
        await this.getMissionById(context, seasonId);
    if (missionResult.hasFailed) {
      return ResultWithValue(false, WeekendStage(), missionResult.errorMessage);
    }
    try {
      WeekendStage selectedStage =
          missionResult.value.stages.firstWhere((s) => s.level == level);
      return ResultWithValue<WeekendStage>(true, selectedStage, '');
    } catch (exception) {
      getLog().e(
          "WeekendMissionJsonRepository getStageById Exception: ${exception.toString()}");
      return ResultWithValue<WeekendStage>(
          false, WeekendStage(), exception.toString());
    }
  }
}
