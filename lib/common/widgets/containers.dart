import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

/// HOME AREAS
Container HomeArea(ScrollController? scrollController,
    Widget header, Widget footer, List<Widget> body) {
  List<Widget> widgets = [SizedBox(height: deviceHeight*0.0325,)];
  widgets += body;
  widgets += [footer];

  return Container(
    color: colorMainBackground,
    alignment: Alignment.topLeft,
    margin: EdgeInsets.fromLTRB(
        deviceWidth * 0.075, deviceHeight * 0.075, deviceWidth * 0.075, 0.0),
    child: Column(children: [
      header,
      Expanded(child:
      ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorMainBackground, Colors.transparent],
            stops: [0.0, 0.035], // 3.5% colorMainBackground, 96.5% transparent
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: ListView(
          padding: EdgeInsets.zero,
          addAutomaticKeepAlives: true,
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          controller: scrollController,
          children: widgets,
        ),
      )),
    ],),
  );
}

Container HomeAreaWithSearchbar(ScrollController? scrollController, bool showSearchbar,
    Widget header, Widget searchbar, Widget footer, List<Widget> body) {
  List<Widget> widgets = [
    if (!showSearchbar) SizedBox(height: deviceHeight*0.0325,),
    if (showSearchbar) SizedBox(height: deviceHeight*0.01,),
  ];
  widgets += body;
  widgets += [footer];

  return Container(
    color: colorMainBackground,
    alignment: Alignment.topLeft,
    margin: EdgeInsets.fromLTRB(
        deviceWidth * 0.075, deviceHeight * 0.075, deviceWidth * 0.075, 0.0),
    child: Column(children: [
      header,
      if (showSearchbar) SizedBox(height: deviceHeight*0.015,),
      if (showSearchbar) searchbar,
      if (showSearchbar) SizedBox(height: deviceHeight*0.01,),
      Expanded(child:
      ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorMainBackground, Colors.transparent],
            stops: [0.0, 0.035], // 3.5% colorMainBackground, 96.5% transparent
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: ListView(
          padding: EdgeInsets.zero,
          addAutomaticKeepAlives: true,
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          controller: scrollController,
          children: widgets,
        ),
      ),
      ),
    ],),
  );
}

Container HomeAreaWithFixedFooter(ScrollController? scrollController,
    Widget header, Widget footer, List<Widget> body) {
  List<Widget> widgets = [SizedBox(height: deviceHeight*0.0325,)];
  widgets += body;

  return Container(
    color: colorMainBackground,
    alignment: Alignment.topLeft,
    margin: EdgeInsets.fromLTRB(
        deviceWidth * 0.075, deviceHeight * 0.075, deviceWidth * 0.075, 0.0),
    child: Column(children: [
      header,
      Expanded(child:
      ShaderMask(
        shaderCallback: (Rect rect) {
          return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [colorMainBackground, Colors.transparent],
            stops: [0.0, 0.035], // 3.5% colorMainBackground, 96.5% transparent
          ).createShader(rect);
        },
        blendMode: BlendMode.dstOut,
        child: ListView(
          padding: EdgeInsets.zero,
          addAutomaticKeepAlives: true,
          physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
          controller: scrollController,
          children: widgets,
        ),
      )),
      footer,
    ],),
  );
}

/// CONTAINERS
Container FormContainer (List<Widget> formWidgets){
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

Container ButtonExplanationContainer(Widget buttonImg, String title, String body){
  return FormContainer([
    IntrinsicHeight(child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: deviceWidth*0.0875,
          child: buttonImg,
        ),
        VerticalDivider(color: colorSecondText),
        Container(
          width: deviceWidth*0.67,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(
                  color: colorMainText,
                  fontSize: deviceWidth * fontSize * 0.0475,
                  fontWeight: FontWeight.bold),),
              SizedBox(height: deviceHeight*0.0025,),
              Text(body, style: TextStyle(
                  color: colorSecondText,
                  fontSize: deviceWidth * fontSize * 0.0325,
                  fontWeight: FontWeight.normal),),
            ],
          ),
        ),
      ],
    ),),
  ]);
}

Container TextExplanationContainer(String title, String body){
  return FormContainer([
    Container(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(
              color: colorMainText,
              fontSize: deviceWidth * fontSize * 0.0475,
              fontWeight: FontWeight.bold),),
          SizedBox(height: deviceHeight*0.0025,),
          Text(body, style: TextStyle(
              color: colorSecondText,
              fontSize: deviceWidth * fontSize * 0.0325,
              fontWeight: FontWeight.normal),),
        ],
      ),
    )
  ]);
}

Container ErrorContainer(String text, double heightProportion){
  return Container(
    height: deviceHeight * heightProportion,
    alignment: Alignment.center,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_tethering_error_rounded, color: colorSecondText, size: deviceWidth*0.15,),
        SizedBox(height: deviceHeight*0.025,),
        Text(
          text + ' Revisa tu conexión a Internet y reinicia la app.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: deviceWidth * fontSize * 0.0475, color: colorSecondText),),
      ],
    ),
  );
}

Container LoadingContainer(String text, double heightProportion){
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
                fontSize: deviceWidth * fontSize * 0.035, color: colorMainText),),
        ],
      )
  );
}

Container NoItemsContainer(String items, double heightProportion){
  return Container(
    height: deviceHeight*heightProportion,
    alignment: Alignment.center,
    child: Text('Sin ' + items,
        style: TextStyle(
            color: colorSecondText,
            fontSize: deviceWidth * fontSize * 0.05,
            fontWeight: FontWeight.normal)),
  );
}

Container NoResultsContainer(double heightProportion){
  return Container(
    height: deviceHeight*heightProportion,
    alignment: Alignment.center,
    child: Text("Sin resultados...",
        style: TextStyle(
            color: colorSecondText,
            fontSize: deviceWidth * fontSize * 0.05,
            fontWeight: FontWeight.normal)
    ),
  );
}

Container ExpandedRow(Widget expandedWidget, Widget nonExpandedWidget){
  return Container(
    child: Row(
      children: <Widget>[
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: expandedWidget),
              nonExpandedWidget
            ],
          ),
        )
      ],
    ),
  );
}