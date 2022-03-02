import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import '../../contracts/titleDataWithOwned.dart';
import '../../helpers/currencyHelper.dart';
import '../../redux/modules/titles/titleViewModel.dart';

Widget Function(BuildContext, TitleDataWithOwned) titleDataTilePresenter(
        TitleViewModel viewModel) =>
    (BuildContext context, TitleDataWithOwned titleData) {
      return TitleDataTile(
        viewModel,
        titleData,
        key: Key(titleData.id),
      );
    };

class TitleDataTile extends StatefulWidget {
  final TitleViewModel viewModel;
  final TitleDataWithOwned titleData;
  TitleDataTile(this.viewModel, this.titleData, {Key key}) : super(key: key);

  @override
  _TitleDataTileState createState() => _TitleDataTileState(
        this.viewModel,
        this.titleData,
      );
}

class _TitleDataTileState extends State<TitleDataTile> {
  final TitleViewModel viewModel;
  final TitleDataWithOwned titleData;

  _TitleDataTileState(this.viewModel, this.titleData);

  void setOwned(bool newIsOwned, void Function() callback) {
    this.setState(() {
      titleData.isOwned = newIsOwned;
    });
    callback();
  }

  @override
  Widget build(BuildContext context) {
    Function() viewModelFunc = titleData.isOwned
        ? () => viewModel.removeFromOwned(titleData.id)
        : () => viewModel.addToOwned(titleData.id);
    Function() toggleOwned = () => setOwned(!titleData.isOwned, viewModelFunc);
    return ListTile(
      leading: (titleData.appIcon == null || titleData.appIcon.length < 5)
          ? null
          : localImage(
              '${getPath().imageAssetPathPrefix}/${titleData.appIcon}',
            ),
      title: Text(
        titleData.title.replaceAll(
          "{0}",
          viewModel.playerTitle ?? 'YourNameHere',
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        titleData.description.replaceAll(
            "%NUM%",
            currencyFormat(
              titleData.unlockedByStatValue.toString(),
              addDecimal: false,
            )),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: adaptiveCheckbox(
        value: titleData.isOwned,
        activeColor: getTheme().getSecondaryColour(context),
        onChanged: (_) => toggleOwned(),
      ),
      onTap: toggleOwned,
    );
  }
}
