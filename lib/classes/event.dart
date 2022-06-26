import 'package:cloud_firestore/cloud_firestore.dart';

class Event{
  final int id;
  final String name;
  final String description;
  final DateTime dateTime;
  final int color;
  final List<dynamic> notificationsList;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.dateTime,
    required this.color,
    required this.notificationsList,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'dateTime': dateTime,
    'color': color,
    'notificationsList': notificationsList,
  };

  static Event fromJson(Map<String, dynamic> json) => Event(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    dateTime: (json['dateTime'] as Timestamp).toDate(),
    color: json['color'],
    notificationsList: json['notificationsList'],
  );

}