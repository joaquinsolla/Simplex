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
        fontSize: deviceWidth * 0.0375,
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
                fontSize: deviceWidth * 0.0475,
                fontWeight: FontWeight.bold),),
            SizedBox(height: deviceHeight*0.0025,),
            Text(secondText, style: TextStyle(
                color: colorSecondText,
                fontSize: deviceWidth * 0.0325,
                fontWeight: FontWeight.normal),),
          ],
        ),
      ),
      Expanded(child: Text(''),),
      widget
    ],);
}

Column FormTextField(TextEditingController controller, String fieldName, String hintText, FocusNode focusNode) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(fieldName, style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.045, fontWeight: FontWeight.bold),),
      SizedBox(height: deviceHeight*0.005),
      TextField(
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        maxLines: null,
        focusNode: focusNode,
        style: TextStyle(color: colorMainText),
        controller: controller,
        decoration: InputDecoration(
          fillColor: colorThirdBackground,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorThirdBackground, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: colorSpecialItem, width: 2),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: colorThirdText, fontStyle: FontStyle.italic),
        ),
      ),
      SizedBox(height: deviceHeight*0.025),
    ],
  );
}
