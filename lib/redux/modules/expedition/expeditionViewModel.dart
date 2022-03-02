import 'package:redux/redux.dart';

import '../../../contracts/redux/appState.dart';
import '../setting/selector.dart';
import 'actions.dart';
import 'selector.dart';

class ExpeditionViewModel {
  final bool useAltGlyphs;
  List<String> claimedRewards;

  void Function(String) addToClaimedRewards;
  void Function(String) removeFromClaimedRewards;

  ExpeditionViewModel({
    this.useAltGlyphs,
    this.claimedRewards,
    this.addToClaimedRewards,
    this.removeFromClaimedRewards,
  });

  static ExpeditionViewModel fromStore(Store<AppState> store) {
    return ExpeditionViewModel(
      useAltGlyphs: getUseAltGlyphs(store.state),
      claimedRewards: getClaimedRewards(store.state),
      addToClaimedRewards: (String rewardId) =>
          store.dispatch(AddToClaimedRewardsAction(rewardId)),
      removeFromClaimedRewards: (String rewardId) =>
          store.dispatch(RemoveClaimedRewardAction(rewardId)),
    );
  }
}
