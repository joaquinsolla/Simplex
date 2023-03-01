import 'package:cloud_firestore/cloud_firestore.dart';

class Note{
  final int id;
  final String name;
  final String content;
  final bool onCalendar;
  final DateTime calendarDate;
  final DateTime modificationDate;
  final List<dynamic> routinesList;
  final bool routineNote;

  Note({
    required this.id,
    required this.name,
    required this.content,
    required this.onCalendar,
    required this.calendarDate,
    required this.modificationDate,
    required this.routinesList,
    required this.routineNote,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'content': content,
    'onCalendar': onCalendar,
    'calendarDate': calendarDate,
    'modificationDate': modificationDate,
    'routinesList': routinesList,
    'routineNote': routineNote,
  };

  static Note fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    name: json['name'],
    content: json['content'],
    onCalendar: json['onCalendar'],
    calendarDate: (json['calendarDate'] as Timestamp).toDate(),
    modificationDate: (json['modificationDate'] as Timestamp).toDate(),
    routinesList: json['routinesList'],
    routineNote: json['routineNote'],
  );

}