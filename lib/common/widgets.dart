import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

Container homeArea(List<Widget> children) {
  return Container(
    color: colorMainBackground,
    alignment: Alignment.topLeft,
    margin: EdgeInsets.fromLTRB(
        deviceWidth * 0.075, deviceHeight * 0.075, deviceWidth * 0.075, 0.0),
    child: ListView(
      physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
      children: children,
    ),
  );
}

Text headerText(String content) {
  return Text(content,
      style: TextStyle(
          color: colorMainText,
          fontSize: deviceWidth * 0.1,
          fontWeight: FontWeight.bold));
}

Column homeHeader(String text, Function() buttonFunction) {
  return Column(
    children: [
      Row(
        children: [
          headerText(text),
          const Expanded(child: Text('')),
          IconButton(
            icon: Icon(Icons.add_rounded,
                color: colorSpecialItem, size: deviceWidth * 0.085),
            splashRadius: 0.001,
            onPressed: buttonFunction,
          ),
        ],
      ),
      SizedBox(
        height: deviceHeight * 0.03,
      ),
    ],
  );
}

Column eventBox(String eventName, String? eventDescription, DateTime eventDate) {

  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(deviceWidth * 0.005),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorSecondBackground,
        ),
        child: TextButton(
          child: IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(width: deviceWidth*0.0125,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(eventDate.day.toString(), style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.0625, fontWeight: FontWeight.bold)),
                    Text(monthConversor(eventDate), style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.04, fontWeight: FontWeight.normal)),
                  ],
                ),
                SizedBox(width: deviceWidth*0.0125,),
                VerticalDivider(color: colorSecondText,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: deviceWidth*0.6475,
                        alignment: Alignment.centerLeft,
                        child: Text(eventName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.0625, fontWeight: FontWeight.bold))),
                    if (eventDescription != null) Container(
                        width: deviceWidth*0.6475,
                        alignment: Alignment.centerLeft,
                        child: Text(eventDescription,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colorSecondText, fontSize: deviceWidth * 0.03, fontWeight: FontWeight.normal))),
                  ],
                ),
              ],
            ),
          ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.5),
                  )
              )),
          onLongPress: (){
            // TODO: onPressed pop-up actions menu
          },
          onPressed: (){
            // TODO: onPressed manage event
          },
        ),
      ),
      SizedBox(height: deviceHeight*0.0125,),
    ],
  );
}
