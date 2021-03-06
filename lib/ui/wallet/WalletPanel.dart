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

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:illinois/service/Analytics.dart';
import 'package:illinois/service/AppNavigation.dart';
import 'package:illinois/service/Auth.dart';
import 'package:illinois/service/FlexUI.dart';
import 'package:illinois/service/IlliniCash.dart';
import 'package:illinois/service/Localization.dart';
import 'package:illinois/service/NativeCommunicator.dart';
import 'package:illinois/service/NotificationService.dart';
import 'package:illinois/service/Storage.dart';
import 'package:illinois/ui/onboarding/OnboardingLoginPhoneVerifyPanel.dart';
import 'package:illinois/ui/wallet/IDCardPanel.dart';
import 'package:illinois/ui/wallet/MTDBusPassPanel.dart';
import 'package:illinois/ui/settings/SettingsAddIlliniCashPanel.dart';
import 'package:illinois/ui/settings/SettingsIlliniCashPanel.dart';
import 'package:illinois/ui/settings/SettingsMealPlanPanel.dart';
import 'package:illinois/ui/widgets/HeaderBar.dart';
import 'package:illinois/ui/widgets/VerticalTitleContentSection.dart';
import 'package:illinois/ui/widgets/RoundedButton.dart';
import 'package:illinois/service/Styles.dart';

class WalletPanel extends StatefulWidget{

  final ScrollController scrollController;

  WalletPanel({this.scrollController});

  _WalletPanelState createState() => _WalletPanelState();
}

class _WalletPanelState extends State<WalletPanel> implements NotificationsListener{

  bool _authLoading = false;
  String        _libraryCode;
  MemoryImage   _libraryBarcode;

  @override
  void initState() {
    super.initState();
    NotificationService().subscribe(this, [
      Auth.notifyStarted,
      Auth.notifyAuthTokenChanged,
      Auth.notifyCardChanged,
      FlexUI.notifyChanged,
      Storage.notifySettingChanged,
    ]);
    _loadLibraryBarcode();
  }

  @override
  void dispose() {
    NotificationService().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Styles().colors.background,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverHeaderBar(
            context: context,
            backVisible: false,
            onBackPressed: () => Navigator.pop(context),
            backgroundColor: Styles().colors.surface,
            titleWidget: Text(
              Localization().getStringEx( "panel.wallet.label.title", "Wallet"),
              style: TextStyle(
                  fontFamily: Styles().fontFamilies.extraBold,
                  color: Styles().colors.fillColorPrimary,
                  fontSize: 20,
                  letterSpacing: 1.0),
            ),
            actions: <Widget>[
              Visibility(
                visible: widget.scrollController != null,
                child: Semantics(button: true,excludeSemantics: true,label: Localization().getStringEx("panel.wallet.button.close.title", "close"), child:
                  IconButton(
                    icon: Image.asset('images/close-orange.png',excludeFromSemantics: true,),
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                  ),
                )
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _authLoading
                  ? Padding(
                    padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).size.height / 3),
                    child: Center(
                      child: CircularProgressIndicator(),
                    )
                  )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16,),
                      child: Column(
                        children: _buildContentList(),
                    ),
                  )
            ]),
          )
        ],
      ),
    );
  }

  List<Widget> _buildContentList() {
    List<Widget> contentList = [];
    List<dynamic> codes = FlexUI()['wallet'] ?? [];
    for (String code in codes) {
      dynamic widget;
      if (code == 'wallet.connect') {
        widget = _buildConnect();
      }
      else if (code == 'wallet.content') {
        widget = _buildContent();
      }
      else if (code == 'wallet.cards') {
        widget = _buildCards();
      }

      if (widget != null) {
        if (0 < contentList.length) {
          contentList.add(Container(height: 20,));
        }
        if (widget is Widget) {
          contentList.add(widget);
        }
        else if (widget is List) {
          contentList.addAll(widget.cast<Widget>());
        }
      }
    }
    return contentList;
  }

  Widget _buildConnect() {
    List<Widget> contentList = [];
    List<dynamic> codes = FlexUI()['wallet.connect'] ?? [];
    for (String code in codes) {
      Widget widget;
      if (code == 'netid') {
        widget = _buildLoginNetIdButton();
      }
      else if (code == 'phone') {
        widget = _buildLoginPhoneButton();
      }
      if (widget != null) {
        if (0 < contentList.length) {
          contentList.add(Container(height: 20,));
        }
        contentList.add(widget);
      }
    }
    return Padding(padding: EdgeInsets.only(left: 32, right: 32, top: MediaQuery.of(context).size.height / 3),
      child: Column(children: contentList,),
    );
  }

  Widget _buildLoginNetIdButton() {
    return RoundedButton(
      label: Localization().getStringEx('panel.wallet.button.connect.netid.title', 'Connect NetID'),
      hint: Localization().getStringEx('panel.wallet.button.connect.netid.hint', ''),
      backgroundColor: Styles().colors.surface,
      fontSize: 16.0,
      textColor: Styles().colors.fillColorPrimary,
      textAlign: TextAlign.center,
      borderColor: Styles().colors.fillColorSecondary,
      onTap: () {
        Analytics.instance.logSelect(target: "Log in");
        Auth().authenticateWithShibboleth();
      },
    );
  }

  Widget _buildLoginPhoneButton() {
    return RoundedButton(
        label: Localization().getStringEx('panel.wallet.button.connect.phone.title', 'Verify Phone Number'),
        hint: Localization().getStringEx('panel.wallet.button.connect.phone.hint', ''),
        backgroundColor: Styles().colors.surface,
        fontSize: 16.0,
        textColor: Styles().colors.fillColorPrimary,
        textAlign: TextAlign.center,
        borderColor: Styles().colors.fillColorSecondary,
        onTap: () {
          Analytics.instance.logSelect(target: "Log in");
          Navigator.push(context, CupertinoPageRoute(settings: RouteSettings(), builder: (context) => OnboardingLoginPhoneVerifyPanel(onFinish: _didPhoneVer)));
        },
      );
  }

  void _didPhoneVer(_) {
    Navigator.of(context)?.popUntil((Route route){
      Widget _widget = AppNavigation.routeRootWidget(route, context: context);
      return _widget == null || _widget?.runtimeType == widget.runtimeType;
    });
  }

  List<Widget> _buildContent() {

    List<Widget> contentList = [];
    List<dynamic> codes = FlexUI()['wallet.content'] ?? [];
    for (String code in codes) {
      Widget widget;
      if (code == 'illini_cash') {
        widget = _buildIlliniCash();
      }
      else if (code == 'meal_plan') {
        widget = _buildMealPlan();
      }
      if (widget != null) {
        if (0 < contentList.length) {
          contentList.add(Container(height: 20,));
        }
        contentList.add(widget);
      }
    }
    return contentList;
  }

  Widget _buildIlliniCash() {
    return _RoundedWidget(
      onView: (){
        Analytics.instance.logSelect(target: "Illini Cash");
        Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
            settings: RouteSettings(name: SettingsIlliniCashPanel.routeName),
            builder: (context){
              return SettingsIlliniCashPanel();
            }
        ));
      },
      title: Localization().getStringEx( "panel.wallet.label.illini_cash.title","ILLINI CASH"),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: VerticalTitleContentSection(
                title: Localization().getStringEx('panel.settings.illini_cash.label.current_balance','Current Illini Cash Balance'),
                content: IlliniCash().ballance?.balanceDisplayText ?? "\$0.00",
              ),
            ),
            Semantics(
              explicitChildNodes: true,
              child: Container(child:
              Semantics(
              label: Localization().getStringEx("panel.wallet.button.add_illini_cash.title","Add Illini Cash"),
              hint: Localization().getStringEx("panel.wallet.button.add_illini_cash.hint",""),
              button: true,
              excludeSemantics: true,
              child:
              IconButton(
                color: Styles().colors.fillColorPrimary,
                icon: Image.asset('images/button-plus-orange.png', excludeFromSemantics: true,),
                onPressed: (){
                  Analytics.instance.logSelect(target: "Add Illini Cash");
                  Navigator.push(context, CupertinoPageRoute(
                    builder: (context) => SettingsAddIlliniCashPanel()
                  ));
                },
              ))),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMealPlan() {
    return _RoundedWidget(
      onView: (){
        Analytics.instance.logSelect(target: "Meal plan");
        Navigator.of(context, rootNavigator: false).push(CupertinoPageRoute(
            builder: (context){
              return SettingsMealPlanPanel();
            }
        ));
      },
      title: Localization().getStringEx( "panel.wallet.label.meal_plan.title", "MEAL PLAN"),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: VerticalTitleContentSection(
                title: Localization().getStringEx(
                    "panel.settings.meal_plan.label.meals_remaining.text", "Meals Remaining"),
                content: IlliniCash().ballance?.mealBalanceDisplayText ?? "0",
              ),
            ),
            Expanded(
              child: VerticalTitleContentSection(
                title: Localization().getStringEx(
                    "panel.settings.meal_plan.label.dining_dollars.text", "Dining Dollars"),
                content: IlliniCash().ballance?.cafeCreditBalanceDisplayText ?? "0",
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCards() {
    List<Widget> contentList = [];
    List<dynamic> codes = FlexUI()['wallet.cards'] ?? [];
    contentList.add(Container(width: 8,));
    for (String code in codes) {
      Widget widget;
      if (code == 'mtd') {
        widget = _buildMTDBussCard();
      }
      else if (code == 'id') {
        widget = _buildIlliniIdCard();
      }
      else if (code == 'library') {
        widget = _buildLibraryCard();
      }

      if (widget != null) {
        contentList.add(widget);
      }
    }

    contentList.add(Container(width: 8,));

    return Container(
//      height: 180,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: contentList,),
      ),
    );
  }

  Widget _buildMTDBussCard(){
    String expires = Auth()?.authCard?.expirationDate ?? "";
    return _Card(
      title: Localization().getStringEx("panel.wallet.label.mtd.title", "MTD",),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Auth()?.authCard?.role ?? "",
              style: TextStyle(
                color: Styles().colors.fillColorPrimary,
                fontFamily: Styles().fontFamilies.extraBold,
                fontSize: 24,
              ),
            ),
            Text(
              "Card exprires $expires",
              style: TextStyle(
                color: Styles().colors.fillColorPrimary,
                fontFamily: Styles().fontFamilies.medium,
                fontSize: 12,
              ),
            ),
            Container(height: 5,),
            Semantics(explicitChildNodes: true,child:
              RoundedButton(
                label: Localization().getStringEx("panel.wallet.button.use_bus_pass.title", "Use bus pass"),
                hint: Localization().getStringEx("panel.wallet.button.use_bus_pass.hint", ""),
                textColor: Styles().colors.fillColorPrimary,
                backgroundColor: Styles().colors.white,
                borderColor: Styles().colors.fillColorSecondary,
                onTap: (){
                  Analytics.instance.logSelect(target: "MTD Bus Pass");
                  Navigator.push(context, CupertinoPageRoute(
                      builder: (context) => MTDBusPassPanel()
                  ));
                },
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIlliniIdCard(){
    return _Card(
      title: Localization().getStringEx("panel.wallet.label.illini_id.title", "Illini ID",),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              Localization().getStringEx("panel.wallet.label.uin.title", "UIN",),
              style: TextStyle(
                color: Styles().colors.fillColorPrimary,
                fontFamily: Styles().fontFamilies.medium,
                fontSize: 14,
              ),
            ),
            Text(
              Auth()?.authCard?.uin ?? "",
              style: TextStyle(
                color: Styles().colors.fillColorPrimary,
                fontFamily: Styles().fontFamilies.extraBold,
                fontSize: 24,
              ),
            ),
            Container(height: 5,),
            Semantics(explicitChildNodes: true,child:
              RoundedButton(
                label: Localization().getStringEx("panel.wallet.button.use_id.title", "Use ID"),
                hint: Localization().getStringEx("panel.wallet.button.use_id.hint", ""),
                textColor: Styles().colors.fillColorPrimary,
                backgroundColor: Styles().colors.white,
                borderColor: Styles().colors.fillColorSecondary,
                onTap: (){
                  Analytics.instance.logSelect(target: "Use ID");
                  Navigator.push(context, CupertinoPageRoute(
                      builder: (context) => IDCardPanel()
                  ));
                },
              )
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryCard(){
    return _Card(
      title: Localization().getStringEx("panel.wallet.label.library.title", "Library Card",),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(height: 10,),
            Container(
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(fit: BoxFit.fill, image:_libraryBarcode ,),    
              )),
            
            Container(height: 5,),
            Text(
              Auth()?.authCard?.libraryNumber ?? "",
              style: TextStyle(
                  fontFamily: Styles().fontFamilies.light,
                  fontSize: 12,
                  color: Styles().colors.fillColorPrimaryVariant,
                  letterSpacing: 1
              ),
            ),
            Container(height: 18,),
          ],
        ),
      ),
    );
  }

  void _loadLibraryBarcode() {
    String libraryCode = Auth().authCard?.libraryNumber;
    if (0 < (libraryCode?.length ?? 0)) {
      NativeCommunicator().getBarcodeImageData({
        'content': Auth().authCard?.libraryNumber,
        'format': 'codabar',
        'width': 161 * 3,
        'height': 50
      }).then((Uint8List imageData) {
        setState(() {
          _libraryCode = libraryCode;
          _libraryBarcode = (imageData != null) ? MemoryImage(imageData) : null;
        });
      });
    }
    else {
      _libraryCode = null;
      _libraryBarcode = null;
    }
  }

  void _updateLibraryBarcode() {
    String libraryCode = Auth().authCard?.libraryNumber;
    if (((_libraryCode == null) && (libraryCode != null)) ||
        ((_libraryCode != null) && (_libraryCode != libraryCode)))
    {
      _loadLibraryBarcode();
    }
  }

  // NotificationsListener

  void onNotification(String name, dynamic param){
    if( name == Auth.notifyStarted){
      setState(() {_authLoading = true;});
    }
    else if( name == Auth.notifyAuthTokenChanged){
      setState(() {_authLoading = false;});
    }
    else if (name == Auth.notifyCardChanged) {
      _updateLibraryBarcode();
    }
    else if(name == FlexUI.notifyChanged){
      setState(() {});
    }
  }
}

class _RoundedWidget extends StatelessWidget{

  final String title;
  final Widget child;
  final Function onView;

  _RoundedWidget({Key key, this.title, @required this.onView, @required this.child}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Semantics(container: true,child:Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 1.0, color: Styles().colors.surfaceAccent),
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Styles().colors.lightGray,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Styles().colors.fillColorPrimary,
                          fontFamily: Styles().fontFamilies.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Semantics(explicitChildNodes: true, child:
                      _ViewButton(
                        label: Localization().getStringEx( "panel.wallet.button.view.title", "View"),
                        onTap: onView,
                      )
                    ),
                    Container(height: 1, color: Styles().colors.surfaceAccent,)
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Styles().colors.white,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
              ),
              child: child
            ),
          ],
        ),
      ),
    ));
  }
}

class _ViewButton extends StatelessWidget{

  final String label;
  final Function onTap;

  _ViewButton({@required this.label, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            Text(label,
              style: TextStyle(
                color: Styles().colors.fillColorPrimary,
                fontFamily: Styles().fontFamilies.bold,
                fontSize: 16,
              ),
            ),
            Container(width: 10,),
            Image.asset('images/chevron-right.png'),
          ],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget{

  static double width = 240;
  final String title;
  final Color titleTextColor;
  final Color titleBackColor;
  final Color titleIconColor;
  final Widget child;

  final Color _defaultTitleTextColor = Styles().colors.white;
  final Color _defaultTitleBackColor = Styles().colors.fillColorPrimary;

  _Card({@required this.title, this.titleBackColor, this.titleTextColor, this.titleIconColor,  @required this.child});

  @override
  Widget build(BuildContext context) {
    return Semantics(container: true,child:Container(
      width: width,
      margin: new EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Styles().colors.lightGray,
            blurRadius: 2.0,
            spreadRadius: 2.0,
            offset: Offset(0.0, 0.0,),
          )
        ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: titleBackColor ?? _defaultTitleBackColor,
                      //borderRadius: BorderRadius.all(Radius.circular(8),),
                    ),
                    width: width,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: titleTextColor ?? _defaultTitleTextColor,
                          fontFamily: Styles().fontFamilies.extraBold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Styles().colors.white,
                    child: child,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}