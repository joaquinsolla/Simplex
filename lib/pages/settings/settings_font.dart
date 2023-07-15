import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/common/widgets/all_widgets.dart';

import '../../services/shared_preferences_service.dart';
import '../home.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SettingsFont extends StatefulWidget {
  const SettingsFont({Key? key}) : super(key: key);

  @override
  _SettingsFontState createState() => _SettingsFontState();
}

class _SettingsFontState extends State<SettingsFont> {

  double previewFontSize = fontSize;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    int color = 0xFFFFFFFF;
    if (darkMode) color = 0xff1c1c1f;
    String dateFormat = 'H:mm';
    if (format24Hours == false) dateFormat = 'K:mm';
    DateTime eventDate = DateTime.now();

    return Scaffold(
      backgroundColor: colorMainBackground,
      body: HomeAreaWithFixedFooter(null,
          PageHeader(context, AppLocalizations.of(context)!.fontSize),
          Column(children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: deviceHeight*0.01,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Aa',
                      style: TextStyle(
                          color: colorMainText,
                          fontSize: deviceWidth * 0.85 * 0.03,
                          fontWeight: FontWeight.normal),
                    ),
                    if (previewFontSize == 0.8) Container(
                      width: deviceWidth*0.675,
                      child: Slider(
                        value: previewFontSize,
                        max: 1.2,
                        min: 0.8,
                        divisions: 4,
                        activeColor: Color(0xff40C4FF),
                        label: AppLocalizations.of(context)!.verySmall,
                        onChanged: (val) {
                          setState(() {
                            previewFontSize = val;
                          });
                        },
                      ),
                    ),
                    if (previewFontSize == 0.9) Container(
                      width: deviceWidth*0.675,
                      child: Slider(
                        value: previewFontSize,
                        max: 1.2,
                        min: 0.8,
                        divisions: 4,
                        activeColor: Color(0xff1eb3ff),
                        label: AppLocalizations.of(context)!.small,
                        onChanged: (val) {
                          setState(() {
                            previewFontSize = val;
                          });
                        },
                      ),
                    ),
                    if (previewFontSize == 1.0) Container(
                      width: deviceWidth*0.675,
                      child: Slider(
                        value: previewFontSize,
                        max: 1.2,
                        min: 0.8,
                        divisions: 4,
                        activeColor: colorSpecialItem,
                        label: AppLocalizations.of(context)!.normal,
                        onChanged: (val) {
                          setState(() {
                            previewFontSize = val;
                          });
                        },
                      ),
                    ),
                    if (previewFontSize == 1.1) Container(
                      width: deviceWidth*0.675,
                      child: Slider(
                        value: previewFontSize,
                        max: 1.2,
                        min: 0.8,
                        divisions: 4,
                        activeColor: Color(0xff2164f3),
                        label: AppLocalizations.of(context)!.big,
                        onChanged: (val) {
                          setState(() {
                            previewFontSize = val;
                          });
                        },
                      ),
                    ),
                    if (previewFontSize == 1.2) Container(
                      width: deviceWidth*0.675,
                      child: Slider(
                        value: previewFontSize,
                        max: 1.2,
                        min: 0.8,
                        divisions: 4,
                        activeColor: Color(0xff0347da),
                        label: AppLocalizations.of(context)!.veryBig,
                        onChanged: (val) {
                          setState(() {
                            previewFontSize = val;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Aa',
                      style: TextStyle(
                          color: colorMainText,
                          fontSize: deviceWidth * 1.3 * 0.03,
                          fontWeight: FontWeight.normal),
                    ),
                  ],),
                SizedBox(height: deviceHeight*0.01,),
                MainButton(
                    Icons.check,
                    colorSpecialItem,
                    ' ' + AppLocalizations.of(context)!.confirmChanges + ' ',
                        () {
                      saveSettingDouble('fontSize', previewFontSize);
                      fontSize = previewFontSize;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                            (Route<dynamic> route) => false,
                      );
                      setState(() {
                        homeIndex = 0;
                      });

                      late String stringSize = AppLocalizations.of(context)!.normal;
                      if (previewFontSize == 0.8) stringSize = AppLocalizations.of(context)!.verySmall;
                      else if (previewFontSize == 0.9) stringSize = AppLocalizations.of(context)!.small;
                      else if (previewFontSize == 1.1) stringSize = AppLocalizations.of(context)!.big;
                      else if (previewFontSize == 1.2) stringSize = AppLocalizations.of(context)!.veryBig;
                      showInfoSnackBar(context, AppLocalizations.of(context)!.fontSizeAdjusted + stringSize + '.');
                    }
                ),
              ],
            ),
            FooterCredits(),
          ],),
          [
            Text(AppLocalizations.of(context)!.thisIsAPreview,
              style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * previewFontSize * 0.045,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: deviceHeight * 0.005),

            Column(
              children: [
                SizedBox(height: deviceHeight*0.005,),
                Container(
                  padding: EdgeInsets.all(deviceWidth * 0.0185),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(color),
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(
                          width: deviceWidth*0.175,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(DateFormat(dateFormat).format(eventDate), style: TextStyle(color: colorMainText, fontSize: deviceWidth * previewFontSize * 0.055, fontWeight: FontWeight.bold)),
                              if (format24Hours==false) Text(DateFormat('aa').format(eventDate), style: TextStyle(color: colorSecondText, fontSize: deviceWidth * previewFontSize * 0.034, fontWeight: FontWeight.normal)),
                            ],
                          ),
                        ),
                        VerticalDivider(color: colorSecondText,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: deviceWidth*0.585,
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context)!.event,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: colorMainText, fontSize: deviceWidth * previewFontSize * 0.06, fontWeight: FontWeight.bold))),
                            SizedBox(height: deviceHeight*0.00375,),
                            Container(
                                width: deviceWidth*0.585,
                                alignment: Alignment.centerLeft,
                                child: Text(AppLocalizations.of(context)!.eventDescription,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: colorSecondText, fontSize: deviceWidth * previewFontSize * 0.03, fontWeight: FontWeight.normal))),
                          ],
                        ),
                        SizedBox(width: deviceWidth*0.01,),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: deviceHeight*0.005,),
              ],
            ),

            SizedBox(height: deviceHeight * 0.025),
            Text(AppLocalizations.of(context)!.fontSizeExplanation,
              style: TextStyle(
                color: colorSecondText,
                fontSize: deviceWidth * previewFontSize * 0.0325,
                fontWeight: FontWeight.normal),),

            SizedBox(height: deviceHeight * 0.025),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Icon(Icons.add, color: colorSecondText, size: deviceWidth*previewFontSize*0.085),
                SizedBox(width: deviceWidth * 0.075),
                Icon(Icons.search, color: colorSecondText, size: deviceWidth*previewFontSize*0.085),
                SizedBox(width: deviceWidth * 0.075),
                Icon(Icons.clear_all_rounded, color: colorSecondText, size: deviceWidth*previewFontSize*0.085),
            ],),

          ]
      ),
    );
  }

}

