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
import 'package:illinois/service/Auth.dart';
import 'package:illinois/service/IlliniCash.dart';
import 'package:illinois/service/Localization.dart';
import 'package:illinois/service/Analytics.dart';
import 'package:illinois/service/Config.dart';
import 'package:illinois/ui/WebPanel.dart';
import 'package:illinois/ui/widgets/HeaderBar.dart';

import 'package:illinois/ui/widgets/TabBarWidget.dart';
import 'package:illinois/ui/widgets/RoundedButton.dart';
import 'package:illinois/utils/Utils.dart';
import 'package:illinois/service/Styles.dart';
import 'package:circular_check_box/circular_check_box.dart';

class SettingsAddIlliniCashPanel extends StatefulWidget {

  final ScrollController scrollController;

  SettingsAddIlliniCashPanel({this.scrollController});

  @override
  _SettingsAddIlliniCashPanelState createState() =>
      _SettingsAddIlliniCashPanelState();
}

class _SettingsAddIlliniCashPanelState
    extends State<SettingsAddIlliniCashPanel> {

  bool _agreePrivacy = false;
  bool __isLoading = false;

  final TextEditingController _uinController = TextEditingController(text: Auth()?.authInfo?.uin ?? "");
  final FocusNode _uinFocusNode = FocusNode();

  final TextEditingController _firstNameController = TextEditingController(text: Auth()?.authInfo?.firstName ?? "");
  final FocusNode _firstNameFocusNode = FocusNode();

  final TextEditingController _lastNameController = TextEditingController(text: Auth()?.authInfo?.lastName ?? "");
  final FocusNode _lastNameFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController(text: Auth()?.authInfo?.email ?? "");
  final FocusNode _emailFocusNode = FocusNode();

  final TextEditingController _ccController = TextEditingController();
  final FocusNode _ccFocusNode = FocusNode();

  final TextEditingController _expiryController = TextEditingController();
  final FocusNode _expiryFocusNode = FocusNode();

  final TextEditingController _cvvController = TextEditingController();
  final FocusNode _cvvFocusNode = FocusNode();

  final TextEditingController _amountController = TextEditingController();
  final FocusNode _amountFocusNode = FocusNode();

  @override
  void dispose() {
    _unfocus();
    _uinController.dispose();
    _uinFocusNode.dispose();
    _firstNameController.dispose();
    _firstNameFocusNode.dispose();
    _lastNameController.dispose();
    _lastNameFocusNode.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    _ccController.dispose();
    _ccFocusNode.dispose();
    _expiryController.dispose();
    _expiryFocusNode.dispose();
    _cvvController.dispose();
    _cvvFocusNode.dispose();
    _amountController.dispose();
    _amountFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              child: Stack(
                children: <Widget>[
                  CustomScrollView(
                    controller: widget.scrollController,
                    slivers: <Widget>[
                      SliverHeaderBar(
                        context: context,
                        backIconRes: widget.scrollController == null
                            ? 'images/chevron-left-white.png'
                            : 'images/chevron-left-blue.png',
                        titleWidget: Text(
                          Localization().getStringEx("panel.settings.add_illini_cash.header.title", "Add Illini Cash"),
                          style: TextStyle(
                              color: widget.scrollController == null
                                  ? Styles().colors.white
                                  : Styles().colors.fillColorPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.0),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate([
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: (){FocusScope.of(context).requestFocus(new FocusNode());},
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 10,
                                  ),
                                  Semantics(
                                      label: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.recipient_uin.text",
                                          "RECIPIENT'S UIN"),
                                      hint: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.recipient_uin.hint",
                                          ""),
                                      textField: true,
                                      excludeSemantics: true,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              Localization().getStringEx(
                                                  "panel.settings.add_illini_cash.label.recipient_uin.text",
                                                  "RECIPIENT'S UIN"),
                                              style: TextStyle(
                                                  fontFamily: Styles().fontFamilies.medium,
                                                  fontSize: 14,
                                                  color: Styles().colors.textBackground),
                                            ),
                                            TextFormField(
                                              controller: _uinController,
                                              focusNode: _uinFocusNode,
                                              keyboardType: TextInputType.number,
                                              onFieldSubmitted: (_){ FocusScope.of(context).requestFocus(_firstNameFocusNode); },
                                              decoration: new InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorSecondary,
                                                      width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontFamily: Styles().fontFamilies.bold,
                                                fontSize: 20,
                                                color: Styles().colors.fillColorPrimary,
                                              ),
                                            ),
                                          ])),
                                  Container(
                                    height: 20,
                                  ),
                                  Semantics(
                                      label: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.first_name.text",
                                          "RECIPIENT'S FIRST NAME"),
                                      hint: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.first_name.hint",
                                          ""),
                                      textField: true,
                                      excludeSemantics: true,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              Localization().getStringEx(
                                                  "panel.settings.add_illini_cash.label.first_name.text",
                                                  "RECIPIENT'S FIRST NAME"),
                                              style: TextStyle(
                                                  fontFamily: Styles().fontFamilies.medium,
                                                  fontSize: 14,
                                                  color: Styles().colors.textBackground),
                                            ),
                                            TextFormField(
                                              controller: _firstNameController,
                                              keyboardType: TextInputType.text,
                                              textCapitalization: TextCapitalization.words,
                                              focusNode: _firstNameFocusNode,
                                              onFieldSubmitted: (_){ FocusScope.of(context).requestFocus(_lastNameFocusNode); },
                                              decoration: new InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorSecondary,
                                                      width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontFamily: Styles().fontFamilies.bold,
                                                fontSize: 20,
                                                color: Styles().colors.fillColorPrimary,
                                              ),

                                            ),
                                          ])),
                                  Container(
                                    height: 20,
                                  ),
                                  Semantics(
                                      label: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.last_name.text",
                                          "RECIPIENT'S LAST NAME"),
                                      hint: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.last_name.hint",
                                          ""),
                                      textField: true,
                                      excludeSemantics: true,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              Localization().getStringEx(
                                                  "panel.settings.add_illini_cash.label.last_name.text",
                                                  "RECIPIENT'S LAST NAME"),
                                              style: TextStyle(
                                                  fontFamily: Styles().fontFamilies.medium,
                                                  fontSize: 14,
                                                  color: Styles().colors.textBackground),
                                            ),
                                            TextFormField(
                                              controller: _lastNameController,
                                              keyboardType: TextInputType.text,
                                              textCapitalization: TextCapitalization.words,
                                              focusNode: _lastNameFocusNode,
                                              onFieldSubmitted: (_){ FocusScope.of(context).requestFocus(_emailFocusNode); },
                                              decoration: new InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorSecondary,
                                                      width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontFamily: Styles().fontFamilies.bold,
                                                fontSize: 20,
                                                color: Styles().colors.fillColorPrimary,
                                              ),

                                            ),
                                          ])),
                                  Container(
                                    height: 20,
                                  ),
                                  Semantics(
                                      label: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.email_address.text",
                                          "EMAIL RECEIPT TO"),
                                      hint: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.email_address.hint",
                                          ""),
                                      textField: true,
                                      excludeSemantics: true,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              Localization().getStringEx(
                                                  "panel.settings.add_illini_cash.label.email_address.text",
                                                  "EMAIL RECEIPT TO"),
                                              style: TextStyle(
                                                  fontFamily: Styles().fontFamilies.medium,
                                                  fontSize: 14,
                                                  color: Styles().colors.textBackground),
                                            ),
                                            TextFormField(
                                              controller: _emailController,
                                              keyboardType: TextInputType.emailAddress,
                                              focusNode: _emailFocusNode,
                                              onFieldSubmitted: (_){ FocusScope.of(context).requestFocus(_ccFocusNode); },
                                              decoration: new InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorSecondary,
                                                      width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontFamily: Styles().fontFamilies.bold,
                                                fontSize: 20,
                                                color: Styles().colors.fillColorPrimary,
                                              ),
                                            ),
                                          ])),
                                  Container(
                                    height: 20,
                                  ),
                                  Semantics(
                                      label: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.credit_card.text", "CREDIT CARD"),
                                      hint: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.credit_card.hint",
                                          ""),
                                      textField: true,
                                      excludeSemantics: true,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              Localization().getStringEx(
                                                  "panel.settings.add_illini_cash.label.credit_card.text", "CREDIT CARD"),
                                              style: TextStyle(
                                                  fontFamily: Styles().fontFamilies.medium,
                                                  fontSize: 14,
                                                  color: Styles().colors.textBackground),
                                            ),
                                            TextFormField(
                                              focusNode: _ccFocusNode,
                                              controller: _ccController,
                                              keyboardType: TextInputType.number,
                                              textInputAction: TextInputAction.next,
                                              decoration: new InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorSecondary,
                                                      width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                              ),
                                              onFieldSubmitted: (_){ FocusScope.of(context).requestFocus(_expiryFocusNode); },
                                              style: TextStyle(
                                                fontFamily: Styles().fontFamilies.bold,
                                                fontSize: 20,
                                                color: Styles().colors.fillColorPrimary,
                                              ),
                                            ),
                                          ])),
                                  Container(
                                    height: 20,
                                  ),
                                  Semantics(
                                      label: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.expiration_date.text", "EXPIRATION DATE"),
                                      hint: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.expiration_date.hint",
                                          ""),
                                      textField: true,
                                      excludeSemantics: true,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              Localization().getStringEx(
                                                  "panel.settings.add_illini_cash.label.expiration_date.text", "EXPIRATION DATE: (MMYY)"),
                                              style: TextStyle(
                                                  fontFamily: Styles().fontFamilies.medium,
                                                  fontSize: 14,
                                                  color: Styles().colors.textBackground),
                                            ),
                                            TextFormField(
                                              focusNode: _expiryFocusNode,
                                              controller: _expiryController,
                                              keyboardType: TextInputType.number,
                                              textInputAction: TextInputAction.next,
                                              onFieldSubmitted: (_){ FocusScope.of(context).requestFocus(_cvvFocusNode); },
                                              decoration: new InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorSecondary,
                                                      width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontFamily: Styles().fontFamilies.bold,
                                                fontSize: 20,
                                                color: Styles().colors.fillColorPrimary,
                                              ),
                                            ),
                                          ])),
                                  Container(
                                    height: 20,
                                  ),
                                  Semantics(
                                      label: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.cvv.text", "CVV"),
                                      hint: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.cvv.hint",
                                          ""),
                                      textField: true,
                                      excludeSemantics: true,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              Localization().getStringEx(
                                                  "panel.settings.add_illini_cash.label.cvv.text", "CVV"),
                                              style: TextStyle(
                                                  fontFamily: Styles().fontFamilies.medium,
                                                  fontSize: 14,
                                                  color: Styles().colors.textBackground),
                                            ),
                                            TextFormField(
                                              focusNode: _cvvFocusNode,
                                              controller: _cvvController,
                                              keyboardType: TextInputType.number,
                                              textInputAction: TextInputAction.next,
                                              onFieldSubmitted: (_){ FocusScope.of(context).requestFocus(_amountFocusNode); },
                                              decoration: new InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorSecondary,
                                                      width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                                disabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontFamily: Styles().fontFamilies.bold,
                                                fontSize: 20,
                                                color: Styles().colors.fillColorPrimary,
                                              ),
                                            ),
                                          ])),
                                  Container(
                                    height: 20,
                                  ),
                                  Semantics(
                                      label: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.dollar_amount.text",
                                          "DOLLAR AMOUNT"),
                                      hint: Localization().getStringEx(
                                          "panel.settings.add_illini_cash.label.dollar_amount.hint",
                                          "5 dollars minimum purchase"),
                                      textField: true,
                                      excludeSemantics: true,
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              Localization().getStringEx(
                                                  "panel.settings.add_illini_cash.label.dollar_amount.text",
                                                  "DOLLAR AMOUNT"),
                                              style: TextStyle(
                                                  fontFamily: Styles().fontFamilies.medium,
                                                  fontSize: 14,
                                                  color: Styles().colors.textBackground),
                                            ),
                                            TextFormField(
                                              focusNode: _amountFocusNode,
                                              controller: _amountController,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              textInputAction: TextInputAction.done,
                                              onFieldSubmitted: (_){ _unfocus(); },
                                              decoration: new InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorSecondary,
                                                      width: 1.0),
                                                ),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Styles().colors.fillColorPrimary,
                                                      width: 1.0),
                                                ),
                                              ),
                                              style: TextStyle(
                                                fontFamily: Styles().fontFamilies.bold,
                                                fontSize: 20,
                                                color: Styles().colors.fillColorPrimary,
                                              ),
                                            ),
                                            Text(
                                              Localization().getStringEx(
                                                  "panel.settings.add_illini_cash.label.minimum_amount.text",
                                                  "(\$5.00 minimum purchase)"),
                                              style: TextStyle(
                                                  fontFamily: Styles().fontFamilies.medium,
                                                  fontSize: 14,
                                                  color: Styles().colors.textBackground),
                                            ),
                                          ])),
                                  Container(
                                    height: 20,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Semantics(
                                        label: Localization().getStringEx(
                                            "panel.settings.add_illini_cash.label.agree",
                                            "I agree to the") +
                                            Localization().getStringEx(
                                                "panel.settings.add_illini_cash.label.agree",
                                                "terms & conditions"),
                                        hint: Localization().getStringEx(
                                            "panel.settings.add_illini_cash.label.agree.hint",
                                            ""),
                                        checked: _agreePrivacy,
                                        excludeSemantics: true,
                                        child: CircularCheckBox(
                                          value: _agreePrivacy,
                                          onChanged: (dynamic value) {
                                            Analytics.instance.logSelect(target: "Agree");
                                            _agreePrivacy = !_agreePrivacy;
                                            setState(() {});
                                          },
                                          activeColor: Styles().colors.fillColorSecondary,
                                        ),
                                      ),
//                        Container(width: 8,),
                                      Semantics(
                                        excludeSemantics: true,
                                        child: Text(
                                          Localization().getStringEx(
                                              "panel.settings.add_illini_cash.label.agree",
                                              "I agree to the"),
                                          style: TextStyle(
                                              fontFamily: Styles().fontFamilies.regular,
                                              fontSize: 16,
                                              color: Styles().colors.textBackground),
                                        ),
                                      ),
                                      Container(
                                        width: 4,
                                      ),
                                      Semantics(
                                          excludeSemantics: true,
                                          child: Container(
                                              decoration: new BoxDecoration(
                                                  border: new Border(
                                                      bottom: BorderSide(
                                                          color: Styles().colors.fillColorSecondary))),
                                              child: GestureDetector(
                                                onTap: _onTermsAndConditionsTapped,
                                                child: Text(
                                                  Localization().getStringEx(
                                                      "panel.settings.add_illini_cash.label.agree",
                                                      "terms & conditions"),
                                                  style: TextStyle(
                                                    fontFamily: Styles().fontFamilies.regular,
                                                    fontSize: 16,
                                                    color: Styles().colors.fillColorPrimary,
                                                  ),
                                                ),
                                              ))),
                                    ],
                                  ),
                                  Container(
                                    height: 20,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: RoundedButton(
                                          label: Localization().getStringEx(
                                              'panel.settings.add_illini_cash.button.cancel.text',
                                              'Cancel'),
                                          hint: Localization().getStringEx(
                                              'panel.settings.add_illini_cash.button.cancel.hint',
                                              ''),
                                          backgroundColor: Styles().colors.white,
                                          fontSize: 16.0,
                                          textColor: Styles().colors.fillColorPrimary,
                                          borderColor: Styles().colors.fillColorPrimary,
                                          onTap: () {
                                            Analytics.instance.logSelect(target: "Cancel");
                                            Navigator.pop(context,);
                                          },
                                        ),
                                      ),
                                      Container(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: RoundedButton(
                                          label: Localization().getStringEx(
                                              'panel.settings.add_illini_cash.button.submit.text',
                                              'Submit'),
                                          hint: Localization().getStringEx(
                                              'panel.settings.add_illini_cash.button.submit.hint',
                                              ''),
                                          backgroundColor: Styles().colors.white,
                                          fontSize: 16.0,
                                          textColor: Styles().colors.fillColorPrimary,
                                          borderColor: Styles().colors.fillColorSecondary,
                                          onTap: _onSubmitIlliniCash,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      )
                    ],
                  ),
                  _isLoading ? Center(child: CircularProgressIndicator() ,) : Container(),
                ],
              )
          ),
        ],
      ),
      backgroundColor: Styles().colors.background,
      bottomNavigationBar: widget.scrollController == null
          ? TabBarWidget()
          : Container(height: 0,),
    );
  }

  bool get _isLoading{
    return __isLoading;
  }

  set _isLoading(bool loading){
    if(__isLoading != loading){
      __isLoading = loading;
      if(mounted) {
        setState(() {});
      }
    }
  }

  bool get _isUinValid{
    return (_uinController?.text ?? "").isNotEmpty;
  }

  bool get _isFirstNameValid{
    return (_firstNameController?.text ?? "").isNotEmpty;
  }

  bool get _isLastNameValid{
    return (_lastNameController?.text ?? "").isNotEmpty;
  }

  bool get _isEmailValid{
    String email = _emailController?.text ?? "";
    return (email).isNotEmpty && RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email);
  }

  bool get _isCCValid{
    return (_ccController?.text ?? "").isNotEmpty;
  }

  bool get _isExpiryValid{
    return (_expiryController?.text ?? "").isNotEmpty;
  }

  bool get _isCvvValid{
    return (_cvvController?.text ?? "").isNotEmpty;
  }

  bool get _isAmountValid{
    return Config().configEnvironment == ConfigEnvironment.dev ? _amountInDouble > 0 : _amountInDouble > 4.999999;
  }

  double get _amountInDouble{
    return double.tryParse((_amountController?.text ?? "0").replaceAll(",", "."),);
  }

  void _validate(){
    if(!_isUinValid){
      throw _ValidationException(
          focusNode: _uinFocusNode,
          message: Localization().getStringEx("panel.settings.add_illini_cash.error.recipient_uin.text", "Please enter Recipient's UIN")
      );
    }

    if(!_isFirstNameValid){
      throw _ValidationException(
          focusNode: _firstNameFocusNode,
          message: Localization().getStringEx("panel.settings.add_illini_cash.error.first_name.text", "Please enter Recipient's First Name")
      );
    }

    if(!_isLastNameValid){
      throw _ValidationException(
          focusNode: _lastNameFocusNode,
          message: Localization().getStringEx("panel.settings.add_illini_cash.error.last_name.text", "Please enter Recipient's Last Name")
      );
    }

    if(!_isEmailValid){
      throw _ValidationException(
          focusNode: _emailFocusNode,
          message: Localization().getStringEx("panel.settings.add_illini_cash.error.email.text", "Please enter Email receipt to")
      );
    }

    if(!_isCCValid){
      throw _ValidationException(
          focusNode: _ccFocusNode,
          message: Localization().getStringEx("panel.settings.add_illini_cash.error.credit_card.text", "Please enter valid credit card")
      );
    }

    if(!_isExpiryValid){
      throw _ValidationException(
          focusNode: _expiryFocusNode,
          message: Localization().getStringEx("panel.settings.add_illini_cash.error.expiration_date.text", "Please enter valid expiration date")
      );
    }

    if(!_isCvvValid){
      throw _ValidationException(
          focusNode: _cvvFocusNode,
          message: Localization().getStringEx("panel.settings.add_illini_cash.error.cvv.text", "Please enter valid CVV code")
      );
    }

    if(!_isAmountValid){
      throw _ValidationException(
        focusNode: _amountFocusNode,
          message: Localization().getStringEx("panel.settings.add_illini_cash.error.dollar_amount.text", "Please enter amount. \$5 minimum")
      );
    }

    if(!_agreePrivacy){
      throw _ValidationException(
          message: Localization().getStringEx("panel.settings.add_illini_cash.error.agree.text", "Please agree to the terms and conditions.")
      );
    }
  }

  void _unfocus(){
    _ccFocusNode.unfocus();
    _expiryFocusNode.unfocus();
    _cvvFocusNode.unfocus();
    _amountFocusNode.unfocus();
  }

  void _finish(){
    if(mounted ) {
      AppAlert.showCustomDialog(
          context: context,
          contentWidget: Text(
              Localization().getStringEx("panel.settings.add_illini_cash.message.buy_illini_cash_success.text", "Transaction successfully processed.")),
          actions: <Widget>[
            TextButton(
                child: Text(Localization().getStringEx("dialog.ok.title", "Ok")),
                onPressed: _onDismissAlert)
          ]
      ).then((value) {
        Navigator.pop(context);
      });
    }
  }

  void _onSubmitIlliniCash(){
    if(!_isLoading) {
      _isLoading = true;

      Analytics.instance.logSelect(target: "Submit Illini Cash");
      try {
        _unfocus();
        _validate();

        IlliniCash().buyIlliniCash(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          uin: _uinController.text,
          email: _emailController.text,
          cc: _ccController.text,
          expiry: _expiryController.text,
          cvv: _cvvController.text,
          amount: _amountInDouble,
        ).then((_) {
          _isLoading = false;

          Analytics().logIlliniCash(action: Analytics.LogIllniCashPurchaseActionName, attributes: {
            Analytics.LogIllniCashPurchaseAmount: _amountInDouble
          });

          _finish();
        }).catchError((e) {
          _isLoading = false;

          // TBD: MV Analytics add_illini_cash_failed
          if(mounted) {
            AppAlert.showDialogResult(context, e.message);
          }
        });
      } on _ValidationException catch (e) {
        _isLoading = false;
        if(mounted) {
          AppAlert.showCustomDialog(
              context: context,
              contentWidget: Text(e.message),
              actions: <Widget>[
                TextButton(
                    child: Text(Localization().getStringEx("dialog.ok.title", "OK")),
                    onPressed: () {
                      Analytics.instance.logAlert(text: e.message, selection: "Ok");
                      Navigator.pop(context, true);
                      if (e.focusNode != null) {
                        FocusScope.of(context).requestFocus(e.focusNode);
                      }
                    }
                )
              ]
          );
        }
      }
    }
  }

  void _onDismissAlert() {
    Analytics.instance.logAlert(
        text: "Transaction successfully processed.", selection: "Ok");
    Navigator.of(context).pop();
  }

  void _onTermsAndConditionsTapped(){
    if(AppString.isStringNotEmpty(Config().illiniCashTosUrl)) {
      Navigator.push(context, CupertinoPageRoute(
          builder: (context) => WebPanel(url: Config().illiniCashTosUrl)
      ));
    }
  }
}

class _ValidationException implements Exception {
  String message;
  FocusNode focusNode;
  _ValidationException({this.message, this.focusNode});
}
