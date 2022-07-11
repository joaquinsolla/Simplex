import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
  final int id;
  final String name;
  final String description;
  final double priority;
  final bool limited;
  final DateTime limitDate;
  final bool done;


  Todo({
    required this.id,
    required this.name,
    required this.description,
    required this.priority,
    required this.limited,
    required this.limitDate,
    required this.done,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'priority': priority,
    'limited': limited,
    'limitDate': limitDate,
    'done': done,
  };

  static Todo fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    priority: json['priority'].toDouble(),
    limited: json['limited'],
    limitDate: (json['limitDate'] as Timestamp).toDate(),
    done: json['done'],
  );

}