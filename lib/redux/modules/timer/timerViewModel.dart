import 'package:redux/redux.dart';

import '../../../contracts/redux/appState.dart';
import '../../../contracts/timer/timerItem.dart';
import 'actions.dart';
import 'selector.dart';

class TimerViewModel {
  List<TimerItem> timers;

  Function(TimerItem timer) addTimer;
  Function(TimerItem timer) editTimer;
  Function(String timerId) removeTimer;

  TimerViewModel({
    this.timers,
    this.addTimer,
    this.editTimer,
    this.removeTimer,
  });

  static TimerViewModel fromStore(Store<AppState> store) {
    return TimerViewModel(
      timers: getTimers(store.state),
      addTimer: (TimerItem timer) => store.dispatch(AddTimerAction(timer)),
      editTimer: (TimerItem timer) => store.dispatch(EditTimerAction(timer)),
      removeTimer: (String timerId) =>
          store.dispatch(RemoveTimerAction(timerId)),
    );
  }
}
