import 'package:cloud_firestore/cloud_firestore.dart';

class Report{
  final String id;
  final String problem;
  final DateTime date;
  late String? userId;
  late String? userEmail;
  late bool active;

  Report({
    required this.id,
    required this.problem,
    required this.date,
    required this.userId,
    required this.userEmail,
    required this.active,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'problem': problem,
    'date': date,
    'userId': userId,
    'userEmail': userEmail,
    'active': active,
  };

  static Report fromJson(Map<String, dynamic> json) => Report(
    id: json['id'],
    problem: json['problem'],
    date: (json['date'] as Timestamp).toDate(),
    userId: json['userId'],
    userEmail: json['userEmail'],
    active: json['active'],
  );

}