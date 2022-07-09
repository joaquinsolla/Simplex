import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
  final int id;
  final String name;
  final String description;
  final bool done;
  final DateTime limitDate;
  final int priority;

  Todo({
    required this.id,
    required this.name,
    required this.description,
    required this.done,
    required this.limitDate,
    required this.priority,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'done': done,
    'limitDate': limitDate,
    'priority': priority,
  };

  static Todo fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    done: json['done'],
    limitDate: (json['limitDate'] as Timestamp).toDate(),
    priority: json['priority'],
  );

}