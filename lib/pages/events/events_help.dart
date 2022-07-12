import 'package:flutter/material.dart';
import 'package:simplex/common/all_common.dart';

class EventsHelp extends StatefulWidget {
  const EventsHelp({Key? key}) : super(key: key);

  @override
  _EventsHelpState createState() => _EventsHelpState();
}

class _EventsHelpState extends State<EventsHelp> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: colorMainBackground,
        body: homeArea([
          pageHeader(context, 'Acerca del calendario'),
        ])
    );
  }

}

