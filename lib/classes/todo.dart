import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
  final int id;
  final String name;
  final String description;
  final int color;
  final bool done;
  final DateTime limitDate;

  Todo({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.done,
    required this.limitDate,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'color': color,
    'done': done,
    'limitDate': limitDate,
  };

  static Todo fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    color: json['color'],
    done: json['done'],
    limitDate: (json['limitDate'] as Timestamp).toDate(),
  );

}