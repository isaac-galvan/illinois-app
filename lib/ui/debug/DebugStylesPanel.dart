/*
 * Copyright 2020 Board of Trustees of the University of Illinois.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:illinois/service/NotificationService.dart';
import 'package:illinois/service/Styles.dart';
import 'package:illinois/ui/widgets/HeaderBar.dart';
import 'package:illinois/ui/widgets/RoundedButton.dart';
import 'package:illinois/utils/Utils.dart';

class DebugStylesPanel extends StatefulWidget {
  _DebugStylesPanelState createState() => _DebugStylesPanelState();
}

class _DebugStylesPanelState extends State<DebugStylesPanel> implements NotificationsListener {

  TextEditingController _stylesContentController;

  @override
  void initState() {
    NotificationService().subscribe(this, [
      Styles.notifyChanged
    ]);
    _stylesContentController = TextEditingController(text: AppJson.encode(Styles().content, prettify: true) ?? '');
    super.initState();
  }

  @override
  void dispose() {
    NotificationService().unsubscribe(this);
    _stylesContentController.dispose();
    super.dispose();
  }

  @override
  void onNotification(String name, dynamic param) {
    if (name == Styles.notifyChanged) {
      _stylesContentController.text = AppJson.encode(Styles().content, prettify: true) ?? '';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles().colors.surface,
      appBar: SimpleHeaderBarWithBack(
        context: context,
        titleWidget: Text(
          "Styles",
          style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: Styles().fontFamilies.extraBold),
        ),
      ),
      body: Padding(padding: EdgeInsets.all(16), child:
        SafeArea(child:
          Column(children: [
            Expanded(child:
              TextField(
                maxLines: 1024,
                controller: _stylesContentController,
                decoration: InputDecoration(border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black, width: 1.0))),
                style: TextStyle(fontFamily: Styles().fontFamilies.regular, fontSize: 16, color: Styles().colors.textBackground,),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 16), child:
              Wrap(runSpacing: 8, spacing: 16, children: <Widget>[
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  RoundedButton(
                    label: AppString.getDefaultEmptyString(value: 'Debug'),
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    textStyle: TextStyle(fontFamily: Styles().fontFamilies.bold, fontSize: 20, color: Styles().colors.fillColorPrimary, decoration: (Styles().contentMode == StylesContentMode.debug) ? TextDecoration.underline : null),
                    borderColor: Styles().colors.fillColorSecondary,
                    backgroundColor: Styles().colors.white,
                    onTap: _onTapDebug,
                  ),
                ],),
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  RoundedButton(
                    label: AppString.getDefaultEmptyString(value: 'Auto'),
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    textStyle: TextStyle(fontFamily: Styles().fontFamilies.bold, fontSize: 20, color: Styles().colors.fillColorPrimary, decoration: (Styles().contentMode == StylesContentMode.auto) ? TextDecoration.underline : null),
                    borderColor: Styles().colors.fillColorSecondary,
                    backgroundColor: Styles().colors.white,
                    onTap: _onTapAuto,
                  ),
                ],),
                Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  RoundedButton(
                    label: AppString.getDefaultEmptyString(value: 'Assets'),
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    textStyle: TextStyle(fontFamily: Styles().fontFamilies.bold, fontSize: 20, color: Styles().colors.fillColorPrimary, decoration: (Styles().contentMode == StylesContentMode.assets) ? TextDecoration.underline : null),
                    borderColor: Styles().colors.fillColorSecondary,
                    backgroundColor: Styles().colors.white,
                    onTap: _onTapAssets,
                  ),
                ],),

              ]),
              //RoundedButton(label: "Preview", backgroundColor: Styles().colors.background, fontSize: 16.0, textColor: Styles().colors.fillColorPrimary, borderColor: Styles().colors.fillColorPrimary, onTap: _onTapPreview),
            ),
          ],),
        ),
      ),
    );
  }

  void _onTapDebug() {
    String stylesContent = _stylesContentController.text;
    if (AppJson.decode(stylesContent) is Map) {
      Styles().setContentMode(StylesContentMode.debug, _stylesContentController.text);
    }
    else {
      AppAlert.showDialogResult(context, 'Invalid JSON content');
    }
  }

  void _onTapAuto() {
    Styles().setContentMode(StylesContentMode.auto);
  }

  void _onTapAssets() {
    Styles().setContentMode(StylesContentMode.assets);
  }

}


