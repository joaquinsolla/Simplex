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

Row customDivider (String label){
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
          // SizedBox(width: deviceWidth*0.01,),
          addButton,
        ],
      ),
      SizedBox(
        height: deviceHeight * 0.03,
      ),
    ],
  );
}

Column pageHeader(BuildContext context, String text) {
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

Container formContainer (List<Widget> formWidgets){
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

Container buttonExplanationContainer(Widget buttonImg, String title, String body){
  return formContainer([
    IntrinsicHeight(child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: deviceWidth*0.0875,
          child: buttonImg,
        ),
        VerticalDivider(color: colorSecondText),
        textExplanation(title, body),
      ],
    ),),
  ]);
}

Container othersExplanationContainer(String title, String body){
  return formContainer([
    Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * 0.0475,
              fontWeight: FontWeight.bold),),
          SizedBox(height: deviceHeight*0.0025,),
          Text(body, style: TextStyle(
              color: colorSecondText,
              fontSize: deviceWidth * 0.0325,
              fontWeight: FontWeight.normal),),
        ],
      ),
    )
  ]);
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

Container actionsButton(IconData icon, Color color, String text, Function() actions){

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

Row settingsRow (String mainText, String secondText, Widget widget) {
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

Container textExplanation(String title, String body){
  return Container(
    width: deviceWidth*0.67,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(
            color: colorMainText,
            fontSize: deviceWidth * 0.0475,
            fontWeight: FontWeight.bold),),
        SizedBox(height: deviceHeight*0.0025,),
        Text(body, style: TextStyle(
            color: colorSecondText,
            fontSize: deviceWidth * 0.0325,
            fontWeight: FontWeight.normal),),
      ],
    ),
  );
}

Container errorContainer(String initialText, double heightProportion){
  return Container(
    height: deviceHeight * heightProportion,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_tethering_error_rounded, color: colorSecondText, size: deviceWidth*0.15,),
        SizedBox(height: deviceHeight*0.025,),
        Text(
          initialText + ' Revisa tu conexión a Internet y reinicia la app.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: deviceWidth * 0.0475, color: colorSecondText),),
      ],
    ),
  );
}

Container loadingContainer(String text, double heightProportion){
  return Container(
      height: deviceHeight*heightProportion,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorSpecialItem),
          SizedBox(height: deviceHeight*0.02,),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: deviceWidth * 0.035, color: colorMainText),),
        ],
      )
  );
}