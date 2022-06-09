import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';
import 'package:simplex/services/sqlite_service.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';


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

Container headerText(String content) {
  return Container(
    width: deviceWidth*0.7,
    child: Text(content,
        style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * 0.1,
            fontWeight: FontWeight.bold)),
  );
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

Column pageHeader(BuildContext context, String text, String route) {
  return Column(
    children: [
      Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_rounded,
                color: colorSpecialItem, size: deviceWidth * 0.08),
            splashRadius: 0.001,
            onPressed: (){
              Navigator.pushReplacementNamed(context, route);
            },
          ),
          SizedBox(width: deviceWidth*0.0075,),
          headerText(text),
        ],
      ),
      SizedBox(height: deviceHeight*0.03,)
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

FocusedMenuHolder eventBox(BuildContext context, Event event) {

  late int color;
  if (event.color == -1 && darkMode == false) {
    color = 0xFFFFFFFF;
  } else if (event.color == -1 && darkMode == true) {
    color = 0xff1c1c1f;
  } else {
    color = event.color;
  }

  DateTime eventDate = DateTime.fromMicrosecondsSinceEpoch(event.date * 1000);

  Color backgroundColor = colorThirdBackground;
  if (darkMode) backgroundColor = colorSecondBackground;

  return FocusedMenuHolder(
    onPressed: (){
      selectedEvent = event;
      Navigator.pushReplacementNamed(context, '/events/event_details');
    },
    menuItems: <FocusedMenuItem>[
      FocusedMenuItem(
        backgroundColor: backgroundColor,
        title: Container(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.open_in_new_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
              SizedBox(width: deviceWidth*0.025,),
              Text('Ver detalles', style: TextStyle(
                  color: colorSpecialItem,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal),),
            ],
          ),
        ),
        onPressed: (){
          selectedEvent = event;
          Navigator.pushReplacementNamed(context, '/events/event_details');
        },
      ),
      FocusedMenuItem(
        backgroundColor: backgroundColor,
        title: Container(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, color: colorSpecialItem, size: deviceWidth * 0.06),
              SizedBox(width: deviceWidth*0.025,),
              Text('Editar', style: TextStyle(
                  color: colorSpecialItem,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal),),
            ],
          ),
        ),
        onPressed: (){
          selectedEvent = event;
          Navigator.pushReplacementNamed(context, '/events/edit_event');
        },
      ),
      FocusedMenuItem(
        backgroundColor: backgroundColor,
        title: Container(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.share_rounded, color: colorSpecialItem, size: deviceWidth * 0.06),
              SizedBox(width: deviceWidth*0.025,),
              Text('Compartir', style: TextStyle(
                  color: colorSpecialItem,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal),),
            ],
          ),
        ),
        onPressed: (){
          // TODO: Share events
        },
      ),
      FocusedMenuItem(
        backgroundColor: backgroundColor,
        title: Container(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delete_outline_rounded, color: Colors.red, size: deviceWidth * 0.06),
              SizedBox(width: deviceWidth*0.025,),
              Text('Eliminar', style: TextStyle(
                  color: Colors.red,
                  fontSize: deviceWidth * 0.04,
                  fontWeight: FontWeight.normal),),
            ],
          ),
        ),
        onPressed: (){
          selectedEvent = event;
          if (selectedEvent!.notificationDay != -1) cancelNotification(selectedEvent!.notificationDay);
          if (selectedEvent!.notificationWeek != -1) cancelNotification(selectedEvent!.notificationWeek);
          if (selectedEvent!.notificationMonth != -1) cancelNotification(selectedEvent!.notificationMonth);
          deleteEventById(selectedEvent!.id);
          Navigator.pushReplacementNamed(context, '/home');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Evento eliminado"),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ));
        },
      ),
    ],
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(deviceWidth * 0.018),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Color(color),
          ),
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
                        child: Text(event.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.06, fontWeight: FontWeight.bold))),
                    if (event.description.isNotEmpty && color == -1) Container(
                        width: deviceWidth*0.6475,
                        alignment: Alignment.centerLeft,
                        child: Text(event.description,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colorSecondText, fontSize: deviceWidth * 0.03, fontWeight: FontWeight.normal))),
                    if (event.description.isNotEmpty && color != -1) Container(
                        width: deviceWidth*0.6475,
                        alignment: Alignment.centerLeft,
                        child: Text(event.description,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colorMainText, fontSize: deviceWidth * 0.03, fontWeight: FontWeight.normal))),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: deviceHeight*0.0125,),
      ],
    ),
  );
}

Column formTextField(TextEditingController controller, String fieldName, String hintText, FocusNode focusNode) {
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

Container eventActionsButton(IconData icon, Color color, String text, Function() actions){

  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: colorSecondBackground,
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [ SizedBox(
        width: deviceWidth*0.8,
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
                    fontSize: deviceWidth * 0.05,
                    fontWeight: FontWeight.normal),
              ),
              Icon(icon, color: Colors.transparent, size: deviceWidth * 0.06),
            ],
          ),
          onPressed: actions,
        ),
      ),],
    ),
  );
}



