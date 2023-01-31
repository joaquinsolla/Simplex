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
