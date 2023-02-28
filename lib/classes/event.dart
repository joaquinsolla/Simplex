import 'package:cloud_firestore/cloud_firestore.dart';

class Event{
  final int id;
  final String name;
  final String description;
  final DateTime dateTime;
  final int color;
  final List<dynamic> notificationsList;
  final List<dynamic> routinesList;
  final bool routineEvent;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.dateTime,
    required this.color,
    required this.notificationsList,
    required this.routinesList,
    required this.routineEvent,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'dateTime': dateTime,
    'color': color,
    'notificationsList': notificationsList,
    'routinesList': routinesList,
    'routineEvent': routineEvent,
  };

  static Event fromJson(Map<String, dynamic> json) => Event(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    dateTime: (json['dateTime'] as Timestamp).toDate(),
    color: json['color'],
    notificationsList: json['notificationsList'],
    routinesList: json['routinesList'],
    routineEvent: json['routineEvent'],
  );

}