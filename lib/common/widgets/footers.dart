import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';


SizedBox FooterEmpty(){
  return SizedBox(height: deviceHeight * 0.05);
}

Column FooterCredits(){
  return Column(
    children: [
      SizedBox(height: deviceHeight * 0.01),
      TextButton(
        child: Text.rich(
          TextSpan(
            text: '\u00a9 Simplex 2023 - ',
            style: TextStyle(
              color: colorSecondText,
              fontSize: deviceWidth * fontSize * 0.025,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: 'Joaquín Solla Vázquez',
                  style: TextStyle(
                    color: colorSecondText,
                    fontSize: deviceWidth * fontSize * 0.025,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline,
                  )
              ),
            ],
          ),
        ),
        onPressed: () {
          tryLaunchUrl(joaquinSollaUrl);
        },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
      ),
      SizedBox(height: deviceHeight * 0.01),
    ],
  );
}

Column FooterPrivacyPolicy(BuildContext context){
  return Column(
    children: [
      SizedBox(height: deviceHeight * 0.01),
      TextButton(
        child: Text.rich(
          TextSpan(
            text: AppLocalizations.of(context)!.checkOutOur,
            style: TextStyle(
              color: colorSecondText,
              fontSize: deviceWidth * fontSize * 0.025,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                  text: AppLocalizations.of(context)!.privacyPolicy,
                  style: TextStyle(
                    color: colorSecondText,
                    fontSize: deviceWidth * fontSize * 0.025,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.underline,
                  )
              ),
            ],
          ),
        ),
        onPressed: () {
          tryLaunchUrl(privacyPolicyUrl);
        },
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
      ),
      SizedBox(height: deviceHeight * 0.01),
    ],
  );
}