import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

SizedBox FormSeparator(){
  return SizedBox(height: deviceHeight * 0.025);
}

Column FormTextField(TextEditingController controller, String fieldName, String hintText, FocusNode focusNode, bool isLast) {
  late TextInputAction textInputAction;
  if (isLast) textInputAction = TextInputAction.done;
  else textInputAction = TextInputAction.next;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(fieldName, style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.045, fontWeight: FontWeight.bold),),
      SizedBox(height: deviceHeight*0.005),
      TextField(
        cursorColor: colorSpecialItem,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: textInputAction,
        maxLines: null,
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.035),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 7.5, 10.0, 7.5),
          fillColor: colorThirdBackground,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorThirdBackground, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: colorSpecialItem, width: 1),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: colorThirdText, fontSize: deviceWidth * fontSize * 0.035, fontStyle: FontStyle.italic),
        ),
      ),
      if(!isLast) SizedBox(height: deviceHeight*0.025),
    ],
  );
}

Column FormTextFieldMultiline(TextEditingController controller, String fieldName, String hintText, FocusNode focusNode, bool isLast) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(fieldName, style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.045, fontWeight: FontWeight.bold),),
      SizedBox(height: deviceHeight*0.005),
      TextField(
        cursorColor: colorSpecialItem,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.newline,
        maxLines: null,
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.035),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 7.5, 10.0, 7.5),
          fillColor: colorThirdBackground,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorThirdBackground, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: colorSpecialItem, width: 1),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: colorThirdText, fontSize: deviceWidth * fontSize * 0.035, fontStyle: FontStyle.italic),
        ),
      ),
      if(!isLast) SizedBox(height: deviceHeight*0.025),
    ],
  );






}

Column FormTextFieldEmail(TextEditingController controller, String fieldName, String hintText, FocusNode focusNode, bool isLast) {
  late TextInputAction textInputAction;
  if (isLast) textInputAction = TextInputAction.done;
  else textInputAction = TextInputAction.next;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(fieldName, style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.045, fontWeight: FontWeight.bold),),
      SizedBox(height: deviceHeight*0.005),
      TextField(
        cursorColor: colorSpecialItem,
        keyboardType: TextInputType.emailAddress,
        textCapitalization: TextCapitalization.none,
        textInputAction: textInputAction,
        maxLines: null,
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.035),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 7.5, 10.0, 7.5),
          fillColor: colorThirdBackground,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorThirdBackground, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: colorSpecialItem, width: 1),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: colorThirdText, fontSize: deviceWidth * fontSize * 0.035, fontStyle: FontStyle.italic),
        ),
      ),
      if(!isLast) SizedBox(height: deviceHeight*0.025),
    ],
  );
}

Column FormTextFieldPassword(TextEditingController controller, String fieldName, String hintText, FocusNode focusNode, bool isLast) {
  late TextInputAction textInputAction;
  if (isLast) textInputAction = TextInputAction.done;
  else textInputAction = TextInputAction.next;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(fieldName, style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.045, fontWeight: FontWeight.bold),),
      SizedBox(height: deviceHeight*0.005),
      TextField(
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        cursorColor: colorSpecialItem,
        keyboardType: TextInputType.visiblePassword,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: textInputAction,
        controller: controller,
        focusNode: focusNode,
        style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.035),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 7.5, 10.0, 7.5),
          fillColor: colorThirdBackground,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorThirdBackground, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: colorSpecialItem, width: 1),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: colorThirdText, fontSize: deviceWidth * fontSize * 0.035, fontStyle: FontStyle.italic),
        ),
      ),
      if(!isLast) SizedBox(height: deviceHeight*0.025),
    ],
  );
}

Column FormDateTimeSelector(TextEditingController controller, String fieldName, String hintText, FocusNode focusNode, Function() actions, bool isLast) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(fieldName, style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.045, fontWeight: FontWeight.bold),),
      SizedBox(height: deviceHeight * 0.005),
      TextField(
        readOnly: true,
        onTap: actions,
        cursorColor: colorSpecialItem,
        focusNode: focusNode,
        controller: controller,
        style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.035),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(10.0, 7.5, 10.0, 7.5),
          fillColor: colorThirdBackground,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: colorThirdBackground, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: colorSpecialItem, width: 1),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: colorThirdText, fontSize: deviceWidth * fontSize * 0.035, fontStyle: FontStyle.italic),
        ),
      ),
      if(!isLast) SizedBox(height: deviceHeight*0.025),
    ],
  );
}

Column FormCustomField(String fieldName, List<Widget> widgets, bool isLast){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(fieldName, style: TextStyle(color: colorMainText, fontSize: deviceWidth * fontSize * 0.045, fontWeight: FontWeight.bold),),
      SizedBox(height: deviceHeight * 0.005),
      Column(children: widgets),
      if(!isLast) SizedBox(height: deviceHeight*0.025),
    ],
  );
}

Column FormColorPicker(BuildContext context, String fieldName, String dialogTitle, int colorCode, List<Widget> widgets, bool isLast) {
  String colorName = 'Por defecto';

  if(colorCode == -1 && darkMode == false) colorCode = 0xffe3e3e9;
  else if(colorCode == -1 && darkMode == true) colorCode = 0xff706e74;

  switch (colorCode) {
    case 0xffF44336:
      colorName = 'Rojo';
      break;
    case 0xffFF9800:
      colorName = 'Naranja';
      break;
    case 0xffFFCC00:
      colorName = 'Amarillo';
      break;
    case 0xff4CAF50:
      colorName = 'Verde';
      break;
    case 0xff448AFF:
      colorName = 'Azul';
      break;
    case 0xff7C4DFF:
      colorName = 'Violeta';
      break;
    default:
      colorName = 'Por defecto';
      break;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(fieldName, style: TextStyle(color: colorMainText,
          fontSize: deviceWidth * fontSize * 0.045,
          fontWeight: FontWeight.bold),),
      SizedBox(height: deviceHeight * 0.005),

      TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.radio_button_checked_rounded, color: Color(colorCode),
              size: deviceWidth * 0.055,),
            Text(' $colorName ', style: TextStyle(
                color: colorMainText,
                fontSize: deviceWidth * fontSize * 0.04,
                fontWeight: FontWeight.normal),),
            Icon(Icons.radio_button_checked_rounded, color: Colors.transparent,
              size: deviceWidth * 0.055,),
          ],
        ),
        onPressed: (){
          showWidgetDialog(
              context,
              dialogTitle,
              widgets,
              'Listo',
                  () {
                Navigator.pop(context);
              },
          );
        },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(colorMainText.withOpacity(0.1)),
        ),
      ),

      if(!isLast) SizedBox(height: deviceHeight * 0.025),
    ],
  );
}