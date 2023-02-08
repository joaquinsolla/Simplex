import 'package:cloud_firestore/cloud_firestore.dart';

class Report{
  final String id;
  final String problem;
  final DateTime date;
  late String? userId;
  late String? userEmail;

  Report({
    required this.id,
    required this.problem,
    required this.date,
    required this.userId,
    required this.userEmail,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'problem': problem,
    'date': date,
    'userId': userId,
    'userEmail': userEmail,
  };

  static Report fromJson(Map<String, dynamic> json) => Report(
    id: json['id'],
    problem: json['problem'],
    date: (json['date'] as Timestamp).toDate(),
    userId: json['userId'],
    userEmail: json['userEmail'],
  );

}