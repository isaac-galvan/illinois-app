
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:illinois/service/Analytics.dart';
import 'package:illinois/service/Config.dart';
import 'package:illinois/service/Localization.dart';
import 'package:illinois/service/Styles.dart';
import 'package:illinois/ui/SavedPanel.dart';
import 'package:illinois/ui/WebPanel.dart';
import 'package:illinois/ui/athletics/AthleticsHomePanel.dart';
import 'package:illinois/ui/debug/DebugStudentsGuideDetailPanel.dart';
import 'package:illinois/ui/explore/ExplorePanel.dart';
import 'package:illinois/ui/groups/GroupsHomePanel.dart';
import 'package:illinois/ui/laundry/LaundryHomePanel.dart';
import 'package:illinois/ui/parking/ParkingEventsPanel.dart';
import 'package:illinois/ui/polls/PollsHomePanel.dart';
import 'package:illinois/ui/settings/SettingsIlliniCashPanel.dart';
import 'package:illinois/ui/settings/SettingsMealPlanPanel.dart';
import 'package:illinois/ui/widgets/HeaderBar.dart';
import 'package:illinois/utils/Utils.dart';
import 'package:url_launcher/url_launcher.dart';

class DebugStudentsGuideSectionsPanel extends StatefulWidget {
  final List<Map<String, dynamic>> entries;
  DebugStudentsGuideSectionsPanel({ this.entries });

  _DebugStudentsGuideSectionsPanelState createState() => _DebugStudentsGuideSectionsPanelState();
}

class _DebugStudentsGuideSectionsPanelState extends State<DebugStudentsGuideSectionsPanel> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleHeaderBarWithBack(
        context: context,
        titleWidget: Text('Involvement', style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: Styles().fontFamilies.extraBold),),
      ),
      body: Column(children: <Widget>[
          Expanded(child:
            SingleChildScrollView(child:
              SafeArea(child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children:
                  _buildContent()
                ),
              ),
            ),
          ),
        ],),
      backgroundColor: Styles().colors.background,
    );
  }

  List<Widget> _buildContent() {
    List<Widget> contentList = <Widget>[];
    if (widget.entries != null) {
      
      // construct sections & involvements
      List<String> sectionsList = <String>[];
      Map<String, List<Map<String, dynamic>>> sectionsMap = Map<String, List<Map<String, dynamic>>>();
      
      List<String> involvementsList = <String>[];
      Set<String> involvementsSet = Set<String>();

      for (Map<String, dynamic> entry in widget.entries) {
        
        String entrySection = AppJson.stringValue(entry['section']) ?? '';
        List<Map<String, dynamic>> sectionEntries = sectionsMap[entrySection];
        if (sectionEntries == null) {
          sectionsMap[entrySection] = sectionEntries = <Map<String, dynamic>>[];
          sectionsList.add(entrySection);
        }
        sectionEntries.add(entry);

        List<dynamic> involvements = AppJson.listValue(entry['involvements']);
        if (involvements != null) {
          for (dynamic involvement in involvements) {
            if ((involvement is String) && !involvementsSet.contains(involvement)) {
              involvementsSet.add(involvement);
              involvementsList.add(involvement);
            }
          }
        }
      }
      
      // build involvements
      if (involvementsList.isNotEmpty) {
        contentList.add(_buildInvolvements(involvementsList: involvementsList));
      }

      // build sections
      contentList.addAll(_buildSections(sectionsList: sectionsList, sectionsMap: sectionsMap));
    }
    return contentList;
  }

  Widget _buildSectionHeading(String section) {
    return Container(color: Styles().colors.fillColorPrimary, child:
      Row(children: [
        Expanded(child:
          Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16), child:
            Text(section, style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: Styles().fontFamilies.bold),)
          ),
        )
      ],),
    );
  }

  Widget _buildInvolvements({ List<String> involvementsList }) {
    List<Widget> rowWidgets = <Widget>[];
    List<Widget> colWidgets = <Widget>[];
    for (String involvement in involvementsList) {
      StudentsGuideInvolvementButton involvementButton = _buildInvolvementButton(involvement);
      if (involvementButton != null) {
        if (rowWidgets.isNotEmpty) {
          rowWidgets.add(Container(width: 6),);
        }
        rowWidgets.add(Expanded(child: involvementButton));
        
        if (rowWidgets.length >= 5) {
          if (colWidgets.isNotEmpty) {
            colWidgets.add(Container(height: 6),);
          }
          colWidgets.add(Row(crossAxisAlignment: CrossAxisAlignment.center, children: rowWidgets));
          rowWidgets = <Widget>[];
        }
      }
    }

    if (0 < rowWidgets.length) {
      while (rowWidgets.length < 5) {
        rowWidgets.add(Container(width: 6),);
        rowWidgets.add(Expanded(child: Container()));
      }
      if (colWidgets.isNotEmpty) {
        colWidgets.add(Container(height: 6),);
      }
      colWidgets.add(Row(children: rowWidgets));
    }

    return Padding(padding: EdgeInsets.all(16), child:
      Column(children: colWidgets,),
    );

    /*return Padding(padding: EdgeInsets.all(16), child:
        Column(children: [
          Row(children: [
            Expanded(child: StudentsGuideInvolvementButton.fromInvolvement('athletics')),
            Container(width: 6),
            Expanded(child: StudentsGuideInvolvementButton.fromInvolvement('events')),
            Container(width: 6),
            Expanded(child: StudentsGuideInvolvementButton.fromInvolvement('dining')),
          ],),
          Container(height: 6),
          Row(children: [
            Expanded(child: StudentsGuideInvolvementButton.fromInvolvement('laundry')),
            Container(width: 6),
            Expanded(child: StudentsGuideInvolvementButton.fromInvolvement('quick-polls')),
            Container(width: 6),
            Expanded(child: Container()),
          ],),
        ],),
      );*/
  }

  StudentsGuideInvolvementButton _buildInvolvementButton(String involvement) {
    
    if (involvement == 'athletics') {
      return StudentsGuideInvolvementButton(title: "Athletics", icon: "images/icon-students-guide-athletics.png", onTap: _navigateAthletics,);
    }
    else if (involvement == 'buss-pass') {
      return StudentsGuideInvolvementButton(title: "Buss Pass", icon: "images/icon-students-guide-buss-pass.png");
    }
    else if (involvement == 'dining') {
      return StudentsGuideInvolvementButton(title: "Dining", icon: "images/icon-students-guide-dining.png", onTap: _navigateDining);
    }
    else if (involvement == 'events') {
      return StudentsGuideInvolvementButton(title: "Events", icon: "images/icon-students-guide-events.png", onTap: _navigateEvents);
    }
    else if (involvement == 'groups') {
      return StudentsGuideInvolvementButton(title: "Groups", icon: "images/icon-students-guide-groups.png", onTap: _navigateGroups);
    }
    else if (involvement == 'illini-cash') {
      return StudentsGuideInvolvementButton(title: "Illini Cash", icon: "images/icon-students-guide-illini-cash.png", onTap: _navigateIlliniCash);
    }
    else if (involvement == 'illini-id') {
      return StudentsGuideInvolvementButton(title: "Illini ID", icon: "images/icon-students-guide-illini-id.png");
    }
    else if (involvement == 'laundry') {
      return StudentsGuideInvolvementButton(title: "Laundry", icon: "images/icon-students-guide-laundry.png", onTap: _navigateLaundry,);
    }
    else if (involvement == 'library') {
      return StudentsGuideInvolvementButton(title: "Library", icon: "images/icon-students-guide-library-card.png");
    }
    else if (involvement == 'meal-plan') {
      return StudentsGuideInvolvementButton(title: "Meal Plan", icon: "images/icon-students-guide-meal-plan.png", onTap: _navigateMealPlan,);
    }
    else if (involvement == 'my-illini') {
      return StudentsGuideInvolvementButton(title: "My Illini", icon: "images/icon-students-guide-my-illini.png", onTap: _navigateMyIllini);
    }
    else if (involvement == 'parking') {
      return StudentsGuideInvolvementButton(title: "Parking", icon: "images/icon-students-guide-parking.png", onTap: _navigateParking);
    }
    else if (involvement == 'quick-polls') {
      return StudentsGuideInvolvementButton(title: "Quick Polls", icon: "images/icon-students-guide-quick-polls.png", onTap: _navigateQuickPolls);
    }
    else if (involvement == 'saved') {
      return StudentsGuideInvolvementButton(title: "Saved", icon: "images/icon-students-guide-saved.png", onTap: _navigateSaved);
    }
    else {
      return null;
    }
  }

  List<Widget> _buildSections({ List<String> sectionsList, Map<String, List<Map<String, dynamic>>> sectionsMap }) {
    List<Widget> sectionsWidgets = <Widget>[];
    for (String section in sectionsList) {
      if (sectionsWidgets.isNotEmpty) {
        sectionsWidgets.add(Container(height: 16,));
      }
      sectionsWidgets.add(_buildSectionHeading(section));
      List<Map<String, dynamic>> sectionEntries = sectionsMap[section];
      for (Map<String, dynamic> entry in sectionEntries) {
        sectionsWidgets.add(
          Padding(padding: EdgeInsets.only(left: 16, right: 16, top: 8), child:
            StudentsGuideEntryCard(entry, entries: widget.entries,)
          )
        );
      }
    }
    return sectionsWidgets;
  }

  void _navigateAthletics() {
    Analytics.instance.logSelect(target: "Athletics");
    Navigator.push(context, CupertinoPageRoute(builder: (context) => AthleticsHomePanel()));
  }

  void _navigateEvents() {
    Analytics.instance.logSelect(target: "Events");
    Navigator.push(context, CupertinoPageRoute(builder: (context) => ExplorePanel(initialTab: ExploreTab.Events, showHeaderBack: true,)));
  }

  void _navigateGroups() {
    Analytics.instance.logSelect(target: "Groups");
    Navigator.push(context, CupertinoPageRoute(builder: (context) => GroupsHomePanel()));
  }

  void _navigateDining() {
    Analytics.instance.logSelect(target: "Dinings");
    Navigator.push(context, CupertinoPageRoute(builder: (context) => ExplorePanel(initialTab: ExploreTab.Dining, showHeaderBack: true,)));
  }

  void _navigateMyIllini() {
    Analytics.instance.logSelect(target: "My Illini");
    Navigator.push(context, CupertinoPageRoute(builder: (context) => WebPanel(url: Config().myIlliniUrl, title: Localization().getStringEx('panel.browse.web_panel.header.schedule_grades_more.title', 'My Illini'),)));
  }

  void _navigateIlliniCash() {
    Analytics.instance.logSelect(target: "Illini Cash");
    Navigator.of(context, rootNavigator: true).push(CupertinoPageRoute(
        settings: RouteSettings(name: SettingsIlliniCashPanel.routeName),
        builder: (context){
          return SettingsIlliniCashPanel();
        }
    ));
  }

  void _navigateMealPlan() {
    Analytics.instance.logSelect(target: "Meal Plan");
    Navigator.of(context, rootNavigator: false).push(CupertinoPageRoute(
        builder: (context){
          return SettingsMealPlanPanel();
        }
    ));
  }

  void _navigateLaundry() {
    Analytics.instance.logSelect(target: "Laundry");
    Navigator.push(context, CupertinoPageRoute(builder: (context) => LaundryHomePanel()));
  }

  void _navigateSaved() {
    Analytics.instance.logSelect(target: "Saved");
    Navigator.push(context, CupertinoPageRoute(builder: (context) => SavedPanel()));
  }

  void _navigateParking() {
    Analytics.instance.logSelect(target: "Parking");
    Navigator.push(context, CupertinoPageRoute(builder: (context) => ParkingEventsPanel()));
  }

  void _navigateQuickPolls() {
    Analytics.instance.logSelect(target: "Quick Polls");
    Navigator.push(context, CupertinoPageRoute(builder: (context) => PollsHomePanel()));
  }
}


class StudentsGuideEntryCard extends StatefulWidget {
  final List<Map<String, dynamic>> entries;
  final Map<String, dynamic> entry;
  StudentsGuideEntryCard(this.entry, {this.entries});

  _StudentsGuideEntryCardState createState() => _StudentsGuideEntryCardState();
}

class _StudentsGuideEntryCardState extends State<StudentsGuideEntryCard> {

  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    String titleHtml = AppJson.stringValue(widget.entry['list_title']) ?? AppJson.stringValue(widget.entry['title']) ?? '';
    String descriptionHtml = AppJson.stringValue(widget.entry['list_description']) ?? AppJson.stringValue(widget.entry['description']) ?? '';
    return Container(
      decoration: BoxDecoration(
          color: Styles().colors.white,
          boxShadow: [BoxShadow(color: Styles().colors.blackTransparent018, spreadRadius: 1.0, blurRadius: 3.0, offset: Offset(1, 1))],
          borderRadius: BorderRadius.all(Radius.circular(4))
      ),
      child: Stack(children: [
        GestureDetector(onTap: _onTapEntry, child:
          Padding(padding: EdgeInsets.all(16), child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Html(data: titleHtml,
                onLinkTap: (url, context, attributes, element) => _onTapLink(url),
                style: { "body": Style(color: Styles().colors.fillColorPrimary, fontFamily: Styles().fontFamilies.bold, fontSize: FontSize(20), padding: EdgeInsets.zero, margin: EdgeInsets.zero), },),
              Container(height: 8,),
              Html(data: descriptionHtml,
                onLinkTap: (url, context, attributes, element) => _onTapLink(url),
                style: { "body": Style(color: Styles().colors.textBackground, fontFamily: Styles().fontFamilies.regular, fontSize: FontSize(16), padding: EdgeInsets.zero, margin: EdgeInsets.zero), },),
            ],),
        ),),
        Align(alignment: Alignment.topRight, child:
          GestureDetector(onTap: _onTapFavorite, child:
            Container(padding: EdgeInsets.all(9), child: 
              Image.asset(_isFavorite ? 'images/icon-star-selected.png' : 'images/icon-star.png')
        ),),),
      ],),
      
    );
  }

  void _onTapLink(String url) {
    if (AppString.isStringNotEmpty(url)) {
      if (AppUrl.launchInternal(url)) {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => WebPanel(url: url)));
      } else {
        launch(url);
      }
    }
  }

  void _onTapFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _onTapEntry() {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => DebugStudentsGuideDetailPanel(entries: widget.entries, entry: widget.entry,)));
  }
}

class StudentsGuideInvolvementButton extends StatefulWidget {
  final String title;
  final String icon;
  final Function onTap;
  StudentsGuideInvolvementButton({this.title, this.icon, this.onTap});

  _StudentsGuideInvolvementButtonState createState() => _StudentsGuideInvolvementButtonState();
}

class _StudentsGuideInvolvementButtonState extends State<StudentsGuideInvolvementButton> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: widget.onTap ?? _nop, child:
      Container(
        decoration: BoxDecoration(
          color: Styles().colors.white,
          boxShadow: [BoxShadow(color: Styles().colors.blackTransparent018, spreadRadius: 1.0, blurRadius: 3.0, offset: Offset(1, 1))],
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ), child:
        Padding(padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6), child:
          Column(children: <Widget>[
            Image.asset(widget.icon),
            Container(height: 12),
            Row(children: [
              Expanded(child:
                Text(widget.title, textAlign: TextAlign.center, style: TextStyle(color: Styles().colors.fillColorPrimary, fontSize: 16, fontFamily: Styles().fontFamilies.semiBold)),
              ),
            ],)
              
          ]),
        ),
    ),);
  }


  void _nop() {}
}