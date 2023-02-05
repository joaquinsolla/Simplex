import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

SizedBox EmptyFooter(){
  return SizedBox(height: deviceHeight * 0.025);
}

Column FooterWithUrl(){
  return Column(
    children: [
      SizedBox(height: deviceHeight * 0.01),
      TextButton(
        child: Text.rich(
          TextSpan(
            text: '\u00a9 Simplex 2023 - ',
            style: TextStyle(
              color: colorSecondText,
              fontSize: deviceWidth * 0.025,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: 'Joaquín Solla Vázquez',
                  style: TextStyle(
                    color: colorSecondText,
                    fontSize: deviceWidth * 0.025,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline,
                  )
              ),
              // can add more TextSpans here...
            ],
          ),
        ),
        onPressed: () {
          tryLaunchUrl("https://www.joaquinsolla.com");
        },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
      ),
      SizedBox(height: deviceHeight * 0.01),
    ],
  );
}
