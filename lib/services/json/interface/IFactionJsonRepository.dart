import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:assistantnms_app/contracts/faction/faction.dart';
import 'package:flutter/material.dart';

import '../../../contracts/faction/guildMission.dart';

class IFactionJsonRepository {
  //
  Future<ResultWithValue<FactionData>> getAll(BuildContext context) async {
    return ResultWithValue<FactionData>(false, FactionData(), '');
  }

  Future<ResultWithValue<FactionDetail>> getById(
      BuildContext context, String id) async {
    return ResultWithValue<FactionDetail>(false, FactionDetail(), '');
  }

  Future<ResultWithValue<List<GuildMission>>> getAllMissions(
      BuildContext context) async {
    return ResultWithValue<List<GuildMission>>(false, List.empty(), '');
  }

  Future<ResultWithValue<GuildMission>> getMissionId(
      BuildContext context, String id) async {
    return ResultWithValue<GuildMission>(false, GuildMission(), '');
  }
}
