import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../contracts/seasonalExpedition/seasonalExpeditionSeason.dart';

import './interface/ISeasonalExpeditionJsonRepository.dart';

class SeasonalExpeditionJsonRepository extends BaseJsonService
    implements ISeasonalExpeditionJsonRepository {
  //
  @override
  Future<ResultWithValue<List<SeasonalExpeditionSeason>>> getAll(
    BuildContext context,
    bool isCustom,
  ) async {
    String jsonFile = isCustom
        ? 'en/SeasonalExpeditionCustom.lang'
        : getTranslations().fromKey(LocaleKey.seasonalExpeditionJson);
    try {
      List responseDetailsJson = await getListfromJson(context, jsonFile);
      List<SeasonalExpeditionSeason> seasonalExp = responseDetailsJson
          .map((m) => SeasonalExpeditionSeason.fromJson(m))
          .toList();
      return ResultWithValue<List<SeasonalExpeditionSeason>>(
          true, seasonalExp, '');
    } catch (exception) {
      getLog().e(
          "SeasonalExpeditionJsonRepository Exception: ${exception.toString()}");
      return ResultWithValue<List<SeasonalExpeditionSeason>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  @override
  Future<ResultWithValue<SeasonalExpeditionSeason>> getById(
    BuildContext context,
    String id,
    bool isCustom,
  ) async {
    ResultWithValue<List<SeasonalExpeditionSeason>> expeditionsResult =
        await getAll(context, isCustom);
    if (expeditionsResult.hasFailed) {
      return ResultWithValue(
          false, SeasonalExpeditionSeason(), expeditionsResult.errorMessage);
    }
    print(id + ' ' + isCustom.toString());
    try {
      SeasonalExpeditionSeason selectedexpedition =
          expeditionsResult.value.firstWhere(
        (r) => r.id == id,
        orElse: () => null,
      );
      if (selectedexpedition == null) {
        throw Exception('expedition not found');
      }
      return ResultWithValue<SeasonalExpeditionSeason>(
          true, selectedexpedition, '');
    } catch (exception) {
      getLog().e(
          "SeasonalExpeditionJsonRepository getById ($id) Exception: ${exception.toString()}");
      return ResultWithValue<SeasonalExpeditionSeason>(
          false, SeasonalExpeditionSeason(), exception.toString());
    }
  }
}
