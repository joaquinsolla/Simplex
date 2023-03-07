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

Container FormSwitchButton(String text1, String text2, bool secondPage, Function() actions){
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: colorThirdBackground,
    ),
    padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!secondPage) Expanded(child: TextButton(
          child: Text(
            text1,
            style: TextStyle(
                color: colorSpecialItem,
                fontSize: deviceWidth * fontSize * 0.04,
                fontWeight: FontWeight.normal),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(colorMainBackground),
            overlayColor: MaterialStateProperty.all(colorSpecialItem.withOpacity(0.1)),
          ),
          onPressed: (){},
        )),
        if (secondPage) Expanded(child: TextButton(
          child: Text(
            text1,
            style: TextStyle(
                color: colorSpecialItem,
                fontSize: deviceWidth * fontSize * 0.04,
                fontWeight: FontWeight.normal),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(colorThirdBackground),
            overlayColor: MaterialStateProperty.all(colorSpecialItem.withOpacity(0.1)),
          ),
          onPressed: actions,
        )),

        if (!secondPage) Expanded(child: TextButton(
          child: Text(
            text2,
            style: TextStyle(
                color: colorSpecialItem,
                fontSize: deviceWidth * fontSize * 0.04,
                fontWeight: FontWeight.normal),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(colorThirdBackground),
            overlayColor: MaterialStateProperty.all(colorSpecialItem.withOpacity(0.1)),
          ),
          onPressed: actions,
        )),
        if (secondPage) Expanded(child: TextButton(
          child: Text(
            text2,
            style: TextStyle(
                color: colorSpecialItem,
                fontSize: deviceWidth * fontSize * 0.04,
                fontWeight: FontWeight.normal),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(colorMainBackground),
            overlayColor: MaterialStateProperty.all(colorSpecialItem.withOpacity(0.1)),
          ),
          onPressed: (){},
        )),
        ],
    ),
  );
}

Container RoutineWeekDaysButton(int index, List<dynamic> actions) {

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.0),
      color: colorThirdBackground,
    ),
    padding: EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        if(index == 1) Expanded(
            child: TextButton(
              child: Text(
                'L',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colorMainBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: () {},
            )
        ),
        if(index != 1 && weekDay != 1) Expanded(
            child: OutlinedButton(
              child: Text(
                'L',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: Colors.transparent)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[0],
            )),
        if(index != 1 && weekDay == 1) Expanded(
            child: OutlinedButton(
              child: Text(
                'L',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: colorSpecialItem)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[0],
            )),
        SizedBox(width: deviceWidth * 0.035,),
        if(index == 2) Expanded(
            child: TextButton(
              child: Text(
                'M',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colorMainBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: () {},
            )
        ),
        if(index != 2 && weekDay != 2) Expanded(
            child: OutlinedButton(
              child: Text(
                'M',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: Colors.transparent)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[1],
            )),
        if(index != 2 && weekDay == 2) Expanded(
            child: OutlinedButton(
              child: Text(
                'M',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: colorSpecialItem)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[1],
            )),
        SizedBox(width: deviceWidth * 0.035,),
        if(index == 3) Expanded(
            child: TextButton(
              child: Text(
                'X',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colorMainBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: () {},
            )
        ),
        if(index != 3 && weekDay != 3) Expanded(
            child: OutlinedButton(
              child: Text(
                'X',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: Colors.transparent)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[2],
            )),
        if(index != 3 && weekDay == 3) Expanded(
            child: OutlinedButton(
              child: Text(
                'X',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: colorSpecialItem)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[2],
            )),
        SizedBox(width: deviceWidth * 0.035,),
        if(index == 4) Expanded(
            child: TextButton(
              child: Text(
                'J',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colorMainBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: () {},
            )
        ),
        if(index != 4 && weekDay != 4) Expanded(
            child: OutlinedButton(
              child: Text(
                'J',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: Colors.transparent)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[3],
            )),
        if(index != 4 && weekDay == 4) Expanded(
            child: OutlinedButton(
              child: Text(
                'J',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: colorSpecialItem)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[3],
            )),
        SizedBox(width: deviceWidth * 0.035,),
        if(index == 5) Expanded(
            child: TextButton(
              child: Text(
                'V',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colorMainBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: () {},
            )
        ),
        if(index != 5 && weekDay != 5) Expanded(
            child: OutlinedButton(
              child: Text(
                'V',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: Colors.transparent)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[4],
            )),
        if(index != 5 && weekDay == 5) Expanded(
            child: OutlinedButton(
              child: Text(
                'V',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: colorSpecialItem)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[4],
            )),
        SizedBox(width: deviceWidth * 0.035,),
        if(index == 6) Expanded(
            child: TextButton(
              child: Text(
                'S',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colorMainBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: () {},
            )
        ),
        if(index != 6 && weekDay != 6) Expanded(
            child: OutlinedButton(
              child: Text(
                'S',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: Colors.transparent)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[5],
            )),
        if(index != 6 && weekDay == 6) Expanded(
            child: OutlinedButton(
              child: Text(
                'S',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: colorSpecialItem)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[5],
            )),
        SizedBox(width: deviceWidth * 0.035,),
        if(index == 7) Expanded(
            child: TextButton(
              child: Text(
                'D',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(colorMainBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: () {},
            )
        ),
        if(index != 7 && weekDay != 7) Expanded(
            child: OutlinedButton(
              child: Text(
                'D',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: Colors.transparent)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[6],
            )),
        if(index != 7 && weekDay == 7) Expanded(
            child: OutlinedButton(
              child: Text(
                'D',
                style: TextStyle(
                    color: colorSpecialItem,
                    fontSize: deviceWidth * fontSize * 0.04,
                    fontWeight: FontWeight.normal),
              ),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                side: MaterialStateProperty.all(BorderSide(color: colorSpecialItem)),
                backgroundColor: MaterialStateProperty.all(
                    colorThirdBackground),
                overlayColor: MaterialStateProperty.all(
                    colorSpecialItem.withOpacity(0.1)),
              ),
              onPressed: actions[6],
            )),

      ],
    ),
  );
}

Container ShareButton(Function() actions){
  return Container(
    child: IconButton(
      icon: Icon(Icons.share_rounded,
          color: colorSpecialItem, size: deviceWidth * 0.05),
      splashRadius: 0.001,
      onPressed: actions,
    ),
  );
}