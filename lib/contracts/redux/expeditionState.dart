import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:meta/meta.dart';

@immutable
class ExpeditionState {
  final List<String> claimedRewards;

  const ExpeditionState({this.claimedRewards});

  factory ExpeditionState.initial() {
    return ExpeditionState(claimedRewards: List.empty(growable: true));
  }

  ExpeditionState copyWith({
    List<String> claimedRewards,
  }) {
    return ExpeditionState(
        claimedRewards: claimedRewards ?? this.claimedRewards);
  }

  factory ExpeditionState.fromJson(Map<String, dynamic> json) {
    if (json == null) return ExpeditionState.initial();
    try {
      return ExpeditionState(
        claimedRewards: readListSafe<String>(
            json, 'claimedRewards', (dynamic json) => json.toString()),
      );
    } catch (exception) {
      return ExpeditionState.initial();
    }
  }

  Map<String, dynamic> toJson() => {'claimedRewards': claimedRewards};
}
