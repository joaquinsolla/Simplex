import 'dart:ui';

import 'package:flutter/material.dart';

import 'all_common.dart';

Container homeArea(List<Widget> children){
  return Container(
    color: colorMainBackground,
    alignment: Alignment.topLeft,
    margin: EdgeInsets.fromLTRB(deviceWidth*0.075, deviceHeight*0.075, deviceWidth*0.075, 0.0),
    child: ListView(
      physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
      children: children,
    ),
  );
}

Text headerText(String content){
  return Text(content, style: TextStyle(color: colorMainText, fontSize: deviceWidth*0.1, fontWeight: FontWeight.bold),);
}