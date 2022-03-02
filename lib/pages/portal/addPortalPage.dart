import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/portal/portalGlyphList.dart';
import '../../components/scaffoldTemplates/genericPageScaffold.dart';
import '../../constants/AnalyticsEvent.dart';
import '../../contracts/portal/portalRecord.dart';
import '../../contracts/redux/appState.dart';
import '../../helpers/actionHelper.dart';
import '../../helpers/genericHelper.dart';
import '../../helpers/hexHelper.dart';
import '../../redux/modules/portal/portalViewModel.dart';

class AddPortalPage extends StatefulWidget {
  final bool isEdit;
  final PortalRecord item;
  AddPortalPage(this.item, {this.isEdit = false});

  @override
  _PortalPageState createState() => _PortalPageState(item, isEdit: isEdit);
}

class _PortalPageState extends State<AddPortalPage> {
  String validationMessage;
  PortalRecord item;
  final bool isEdit;
  bool disableEditBtns;
  bool useAltGlyphs;
  String _hexString;
  TextEditingController _hexCoordController;

  @override
  void initState() {
    super.initState();
    _hexString = allUpperCase(intArrayToHex(item.codes));
    _hexCoordController = TextEditingController(text: _hexString);
  }

  _PortalPageState(this.item, {this.isEdit = false}) {
    getAnalytics().trackEvent(AnalyticsEvent.addPortalPage);
    this.disableEditBtns = !isEdit;
    this.useAltGlyphs = true;
  }

  _addCode(int code) {
    if (this.item.codes.length >= 12) return;
    setState(() {
      this.item.codes.add(code);
      var tempHexStr = allUpperCase(intArrayToHex(this.item.codes));
      _setHexCoordText(tempHexStr);
      if (this.item.codes.length > 0) this.disableEditBtns = false;
    });
  }

  _setCode(List<int> codes) {
    if (codes.length > 12) codes = codes.take(12);
    setState(() {
      this.item = this.item.copyWith(codes: codes);
      if (this.item.codes.length > 0) this.disableEditBtns = false;
    });
  }

  _addTag(BuildContext context, String tag) {
    setState(() {
      this.item.tags.add(tag);
    });
  }

  _removeTag(BuildContext context, String tag) {
    setState(() {
      this.item.tags.remove(tag);
    });
  }

  _backspaceCode() {
    if (this.item.codes.length <= 0) return;
    setState(() {
      this.item = this.item.copyWith(
            codes: this.item.codes.sublist(0, this.item.codes.length - 1),
          );
      var tempHexStr = allUpperCase(intArrayToHex(this.item.codes));
      _setHexCoordText(tempHexStr);
      if (this.item.codes.length <= 0) this.disableEditBtns = true;
    });
  }

  _clearCode() {
    if (this.item.codes.length <= 0) return;
    setState(() {
      this.item = this.item.copyWith(
        codes: [],
      );
      var tempHexStr = allUpperCase(intArrayToHex(this.item.codes));
      _setHexCoordText(tempHexStr);
      this.disableEditBtns = true;
    });
  }

  _setHexCoordText(String text) {
    _hexCoordController.text = text;
    _hexCoordController.selection =
        TextSelection.collapsed(offset: text.length);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PortalViewModel>(
      converter: (store) => PortalViewModel.fromStore(store),
      builder: (_, viewModel) => basicGenericPageScaffold(
        context,
        title: this.item.name ??
            getTranslations().fromKey(LocaleKey.newPortalEntry),
        actions: [
          editNameInAppBarAction(
            context,
            LocaleKey.name,
            nameIfEmpty: LocaleKey.newPortalEntry,
            currentName: this.item.name ??
                getTranslations().fromKey(LocaleKey.newPortalEntry),
            onEdit: (String newName) => setState(() {
              this.item.name = newName;
            }),
          ),
        ],
        body: getBody(context, viewModel),
        fab: (this.item.codes.length == 12)
            ? FloatingActionButton(
                onPressed: () async {
                  if (this.validationMessage != null) return;
                  var tempCodes = List.from(this.item.codes)
                      .map((cc) => cc as int)
                      .toList(); //So that it isn't passed by reference
                  var tempTags = List.from(this.item.tags)
                      .map((cc) => cc as String)
                      .toList(); //So that it isn't passed by reference
                  Navigator.pop(
                    context,
                    PortalRecord(
                      name: this.item.name ??
                          getTranslations().fromKey(LocaleKey.newPortalEntry),
                      uuid: this.item.uuid,
                      codes: tempCodes,
                      tags: tempTags,
                    ),
                  );
                },
                heroTag: 'AddPortalPage',
                child: Icon(Icons.check),
                foregroundColor:
                    getTheme().fabForegroundColourSelector(context),
                backgroundColor: getTheme().fabColourSelector(context),
              )
            : null,
      ),
    );
  }

  Widget getBody(BuildContext context, PortalViewModel portalViewModel) {
    List<Widget> widgets = List.empty(growable: true);
    final double runSpacing = 1;
    final double spacing = 1;
    final columns = 4;
    final w = (MediaQuery.of(context).size.width - runSpacing * (columns - 1)) /
        columns;
    String color = getTheme().getIsDark(context) ? 'white' : 'black';
    if (portalViewModel.useAltGlyphs) color = 'alt';

    widgets.add(Container(
      margin: const EdgeInsets.all(2.0),
      child: twoLinePortalGlyphList(this.item.codes,
          useAltGlyphs: portalViewModel.useAltGlyphs),
    ));

    widgets.add(Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        child: Center(
          child: TextField(
            controller: _hexCoordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: getTranslations().fromKey(LocaleKey.hexCoordLabel),
            ),
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter(RegExp('[A-F0-9]'), allow: true),
              LengthLimitingTextInputFormatter(12),
            ],
            onChanged: (newHexString) {
              List<int> newCodes = hexToIntArray(newHexString);
              _setCode(newCodes);
              // _setHexCoordText(newHexString);
            },
          ),
        )));

    widgets.add(Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Flexible(
            fit: FlexFit.loose,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red[400]),
                      ),
                      onPressed: this.disableEditBtns
                          ? null
                          : () {
                              _backspaceCode();
                            },
                      child: Icon(
                        Icons.backspace,
                        color: this.disableEditBtns
                            ? Colors.white60
                            : Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red[800]),
                      ),
                      onPressed: this.disableEditBtns
                          ? null
                          : () {
                              _clearCode();
                            },
                      child: Icon(
                        Icons.clear,
                        color: this.disableEditBtns
                            ? Colors.white60
                            : Colors.white,
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Switch.adaptive(
                        value: portalViewModel.useAltGlyphs,
                        activeThumbImage: AssetImage(
                          '${getPath().imageAssetPathPrefix}/portals/alt/0.png',
                        ),
                        inactiveThumbImage: AssetImage(
                          '${getPath().imageAssetPathPrefix}/portals/$color/0.png',
                        ),
                        onChanged: (altGlyph) {
                          portalViewModel.toggleAltGlyphs();
                        },
                      ),
                    )
                  ],
                ),
                Flexible(
                  child: Wrap(
                    runSpacing: runSpacing,
                    spacing: spacing,
                    alignment: WrapAlignment.center,
                    children: List.generate(16, (index) {
                      String hexNum = index.toRadixString(16);
                      return FittedBox(
                        child: RawMaterialButton(
                          onPressed: () => _addCode(index),
                          fillColor: Colors.transparent,
                          constraints:
                              BoxConstraints.tightFor(width: w, height: w),
                          child: localImage(
                            '${getPath().imageAssetPathPrefix}/portals/$color/$hexNum.png',
                            width: w,
                            height: w,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ))
      ],
    ));

    List<Widget> tags = List.empty(growable: true);
    for (var item in this.item.tags) {
      tags.add(genericChip(context, item, onTap: () async {
        _removeTag(context, item);
      }));
    }

    tags.add(
      genericChip(
        context,
        '+' + getTranslations().fromKey(LocaleKey.addTag),
        onTap: () async {
          var availableTags = portalViewModel.availableTags
              .where((at) => !this.item.tags.contains(at))
              .toList();
          String temp = await getNavigation().navigateAsync(
            context,
            navigateTo: (context) => OptionsListPageDialog(
              'Tags',
              availableTags.map((g) => DropdownOption(g.toString())).toList(),
              addOption: (DropdownOption option) {
                portalViewModel.addTag(option.value);
              },
              onDelete: (DropdownOption option) {
                portalViewModel.removeTag(option.value);
              },
            ),
          );
          if (temp == null || temp.length <= 0) return;
          _addTag(context, temp);
        },
      ),
    );
    widgets.add(Wrap(
      alignment: WrapAlignment.center,
      children: tags,
    ));

    widgets.add(Container(
      margin: const EdgeInsets.all(16.0),
    ));

    return listWithScrollbar(
      itemCount: widgets.length,
      itemBuilder: (context, index) => widgets[index],
    );
  }
}
