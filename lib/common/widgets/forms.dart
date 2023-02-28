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