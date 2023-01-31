import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

Row authHeader(){
  return Row(
    children: [
      Image.asset('assets/app_icon_preview.png', scale: deviceWidth*0.0175,),
      SizedBox(width: deviceWidth*0.02,),
      Container(
        width: deviceWidth*0.625,
        child: Text('Bienvenido a Simplex',
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * 0.1,
                fontWeight: FontWeight.bold)),
      ),
    ],
  );
}

Text headerText(String content) {
  return Text(content,
      style: TextStyle(
          color: colorMainText,
          fontSize: deviceWidth * 0.1,
          fontWeight: FontWeight.bold));
}

Container headerTextBox(String content) {
  return Container(
    width: deviceWidth*0.72,
    child: headerText(content),
  );
}

Column homeHeaderSimple(String text, Widget addButton) {
  return Column(
    children: [
      Row(
        children: [
          headerText(text),
          const Expanded(child: Text('')),
          addButton,
        ],
      ),
      SizedBox(
        height: deviceHeight * 0.03,
      ),
    ],
  );
}

Column homeHeaderDouble(String text, Widget specialButton, Widget addButton) {
  return Column(
    children: [
      Row(
        children: [
          headerText(text),
          const Expanded(child: Text('')),
          specialButton,
          SizedBox(width: deviceWidth*0.01,),
          addButton,
        ],
      ),
      SizedBox(
        height: deviceHeight * 0.03,
      ),
    ],
  );
}

Column homeHeaderTriple(String text, Widget specialButton1, Widget specialButton2, Widget addButton) {
  return Column(
    children: [
      Row(
        children: [
          headerText(text),
          const Expanded(child: Text('')),
          specialButton1,
          SizedBox(width: deviceWidth*0.01,),
          specialButton2,
          SizedBox(width: deviceWidth*0.01,),
          addButton,
        ],
      ),
      SizedBox(
        height: deviceHeight * 0.03,
      ),
    ],
  );
}

Column pageHeaderWithBackArrow(BuildContext context, String text) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_rounded,
                color: colorSpecialItem, size: deviceWidth * 0.08),
            splashRadius: 0.001,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          SizedBox(width: deviceWidth*0.0075,),
          headerTextBox(text),
        ],
      ),
      SizedBox(height: deviceHeight*0.03,)
    ],
  );
}