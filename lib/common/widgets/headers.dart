import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

Column AuthHeader(){
  return Column(
    children: [
      SizedBox(
        height: deviceHeight * 0.01,
      ),
      Row(
        children: [
          Image.asset('assets/icon_no_background.png', scale: deviceWidth*0.0175,),
          SizedBox(width: deviceWidth*0.02,),
          Container(
            width: deviceWidth*0.625,
            child: Text('Bienvenido a Simplex',
                style: TextStyle(
                    color: colorMainText,
                    fontSize: deviceWidth * fontSize * 0.1,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ],
  );
}

Column HomeHeader(String text, List<Widget> buttons) {

  List<Widget> headerItems = [
    HeaderText(text),
    const Expanded(child: Text('')),
  ];
  if (buttons.length > 0){
    for (var i = 0; i < buttons.length; i++) {
      headerItems.add(SizedBox(width: deviceWidth*0.01,));
      headerItems.add(buttons[i]);
    }
  }

  return Column(
    children: [
      SizedBox(
        height: deviceHeight * 0.01,
      ),
      Row(
        children: headerItems,
      ),
    ],
  );
}

Column PageHeader(BuildContext context, String text) {
  return Column(
    children: [
      SizedBox(height: deviceHeight * 0.01),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_circle_left_outlined,
                color: colorSpecialItem, size: deviceWidth * 0.08),
            splashRadius: 0.001,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          SizedBox(width: deviceWidth*0.0075,),
          Container(
            width: deviceWidth*0.72,
            child: HeaderText(text),
          ),
        ],
      ),
    ],
  );
}

Text HeaderText(String content) {
  return Text(content,
      style: TextStyle(
          color: colorMainText,
          fontSize: deviceWidth * fontSize * 0.1,
          fontWeight: FontWeight.bold));
}
