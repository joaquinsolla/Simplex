import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

Container MainButton(IconData icon, Color color, String text, Function() actions){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: colorSecondBackground,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [ SizedBox(
        width: deviceHeight,
        height: deviceHeight*0.07,
        child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: deviceWidth * 0.06),
              Text(
                text,
                style: TextStyle(
                    color: color,
                    fontSize: deviceWidth * fontSize * 0.05,
                    fontWeight: FontWeight.normal),
              ),
              Icon(icon, color: Colors.transparent, size: deviceWidth * 0.06),
            ],
          ),
          onPressed: actions,
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(color.withOpacity(0.1)),
          ),
        ),
      ),],
    ),
  );
}

Container SecondaryButton(Color color, String text, Function() actions){
  return Container(
    width: deviceHeight,
    height: deviceHeight * 0.05,
    child: TextButton(
      child: Text(
        text,
        style: TextStyle(
            color: color,
            fontSize: deviceWidth * fontSize * 0.04,
            fontWeight: FontWeight.normal),
      ),
      onPressed: actions,
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(color.withOpacity(0.1)),
      ),
    ),
  );
}

Container VisibilityButton(String text, bool visibility, Function() actions){
  return Container(
    child: TextButton(
      child: Row(children: [
        if (visibility) Icon(Icons.keyboard_arrow_down_rounded, color: colorSpecialItem,),
        if (!visibility) Icon(Icons.keyboard_arrow_up_rounded, color: colorSpecialItem,),
        SizedBox(width: deviceWidth*0.02,),
        Text(text,
            style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * fontSize * 0.05,
                fontWeight: FontWeight.bold)
        )
      ],),
      onPressed: actions,
    ),
  );
}