import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

Container homeArea(List<Widget> children) {
  return Container(
    color: colorMainBackground,
    alignment: Alignment.topLeft,
    margin: EdgeInsets.fromLTRB(
        deviceWidth * 0.075, deviceHeight * 0.075, deviceWidth * 0.075, 0.0),
    child: ListView(
      addAutomaticKeepAlives: true,
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

Column addHeader(BuildContext context, String text, List<Widget> formWidgets) {
  return Column(
    children: [
      Row(
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
          headerText(text),
        ],
      ),
      SizedBox(height: deviceHeight*0.03,),
      Container(
        padding: EdgeInsets.all(deviceWidth * 0.025),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: colorSecondBackground,
        ),
        child: Column(
          children: formWidgets,
        ),
      ),
    ],
  );
}

Container alternativeFormContainer (List<Widget> formWidgets){
  return Container(
    padding: EdgeInsets.all(deviceWidth * 0.025),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: colorSecondBackground,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: formWidgets,
    ),
  );
}

Container checkBoxContainer(CheckboxListTile checkbox){
  return Container(padding: EdgeInsets.all(0),
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: colorThirdBackground,),
    child: checkbox,
  );
}

Column eventBox(String eventName, String eventDescription, DateTime eventDate, int color) {

  if (color == -1 && darkMode == false) color = 0xFFFFFFFF;
  if (color == -1 && darkMode == true) color = 0xff1c1c1f;

  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(deviceWidth * 0.005),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(color),
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
                    if (DateTime.now().year != eventDate.year) Text(eventDate.year.toString(), style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.034, fontWeight: FontWeight.normal)),
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
                            style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.06, fontWeight: FontWeight.bold))),
                    if (eventDescription.isNotEmpty && color == -1) Container(
                        width: deviceWidth*0.6475,
                        alignment: Alignment.centerLeft,
                        child: Text(eventDescription,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colorSecondText, fontSize: deviceWidth * 0.03, fontWeight: FontWeight.normal))),
                    if (eventDescription.isNotEmpty && color != -1) Container(
                        width: deviceWidth*0.6475,
                        alignment: Alignment.centerLeft,
                        child: Text(eventDescription,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.03, fontWeight: FontWeight.normal))),
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

Column formTextField(TextEditingController controller, String fieldName, String hintText, FocusNode focusNode) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(fieldName, style: TextStyle(color: colorMainText,fontSize: deviceWidth*0.045, fontWeight: FontWeight.bold),),
      SizedBox(height: deviceHeight*0.005),
      TextField(
        focusNode: focusNode,
        style: TextStyle(color: colorMainText),
        controller: controller,
        decoration: InputDecoration(
          fillColor: colorThirdBackground,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorThirdBackground, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
            BorderSide(color: colorSpecialItem, width: 2),
          ),

          hintText: hintText,
          hintStyle: TextStyle(color: colorThirdText),
        ),
      ),
      SizedBox(height: deviceHeight*0.025),
    ],
  );
}
