import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

Row CustomDivider (String label){
  return Row(children: <Widget>[
    Expanded(
      child: new Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Divider(
            color: colorThirdText,
          )),
    ),

    Text(label, style: TextStyle(
        color: colorSecondText,
        fontSize: deviceWidth * fontSize * 0.03,
        fontWeight: FontWeight.normal),),

    Expanded(
      child: new Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Divider(
            color: colorThirdText,
          )),
    ),
  ]);
}

Row SettingsRow (String mainText, String secondText, Widget widget) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: deviceWidth * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mainText, style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * fontSize * 0.0475,
                fontWeight: FontWeight.bold),),
            SizedBox(height: deviceHeight*0.0025,),
            Text(secondText, style: TextStyle(
                color: colorSecondText,
                fontSize: deviceWidth * fontSize * 0.0325,
                fontWeight: FontWeight.normal),),
          ],
        ),
      ),
      Expanded(child: Text(''),),
      widget
    ],);
}
