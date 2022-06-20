import 'package:cloud_firestore/cloud_firestore.dart';

class Event{
  final int id;
  final String name;
  final String description;
  final DateTime dateTime;
  final int color;
  final int not5Min;
  final int not1Hour;
  final int not1Day;

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.dateTime,
    required this.color,
    required this.not5Min,
    required this.not1Hour,
    required this.not1Day,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'dateTime': dateTime,
    'color': color,
    'not5Min': not5Min,
    'not1Hour': not1Hour,
    'not1Day': not1Day,
  };

  static Event fromJson(Map<String, dynamic> json) => Event(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    dateTime: (json['dateTime'] as Timestamp).toDate(),
    color: json['color'],
    not5Min: json['not5Min'],
    not1Hour: json['not1Hour'],
    not1Day: json['not1Day'],
  );

}