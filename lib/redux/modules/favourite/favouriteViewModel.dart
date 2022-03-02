import 'package:redux/redux.dart';

import '../../../contracts/favourite/favouriteItem.dart';
import '../../../contracts/redux/appState.dart';
import '../setting/selector.dart';
import 'actions.dart';
import 'selector.dart';

class FavouriteViewModel {
  List<FavouriteItem> favourites;
  final bool genericTileIsCompact;
  final bool displayGenericItemColour;

  Function(FavouriteItem newItem) addFavourite;
  Function(String itemId) removeFavourite;

  FavouriteViewModel({
    this.favourites,
    this.genericTileIsCompact,
    this.displayGenericItemColour,
    this.addFavourite,
    this.removeFavourite,
  });

  static FavouriteViewModel fromStore(Store<AppState> store) =>
      FavouriteViewModel(
        favourites: getFavourites(store.state),
        genericTileIsCompact: getGenericTileIsCompact(store.state),
        displayGenericItemColour: getDisplayGenericItemColour(store.state),
        addFavourite: (FavouriteItem newItem) =>
            store.dispatch(AddFavouriteAction(newItem)),
        removeFavourite: (String itemId) =>
            store.dispatch(RemoveFavouriteAction(itemId)),
      );
}
