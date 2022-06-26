import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/classes/all_classes.dart';


Future createUserDoc() async{
  final user = FirebaseAuth.instance.currentUser!;
  final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

  final json = {
    'userId': user.uid,
    'emailVerified': false,
    'tester': false,
  };

  await doc.set(json);
  debugPrint('[OK] User doc created');
}

/// EVENTS MANAGEMENT
Stream<List<Event>> readAllEvents() {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events')
      .orderBy('dateTime', descending: false)
      .orderBy('color', descending: true).orderBy('id', descending: false).snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());
}

Stream<List<Event>> readEventsOfDate(DateTime date) {
  DateTime selectedDay = DateTime(date.year, date.month, date.day);
  DateTime nextDay = DateTime(date.year, date.month, date.day+1);

  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events')
      .where('dateTime', isGreaterThanOrEqualTo: selectedDay)
      .where('dateTime', isLessThan: nextDay)
      .orderBy('dateTime', descending: false)
      .orderBy('color', descending: true).orderBy('id', descending: false).snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());
}

Future createEvent(Event event) async{
  final user = FirebaseAuth.instance.currentUser!;
  final doc = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('events').doc(event.id.toString());

  final json = {
    'id': event.id,
    'name': event.name,
    'description': event.description,
    'dateTime': event.dateTime,
    'color': event.color,
    'not5Min': event.not5Min,
    'not1Hour': event.not1Hour,
    'not1Day': event.not1Day,
  };

  await doc.set(json);
  debugPrint('[OK] Event created');
}

updateEvent(int eventId, String newName, String newDescription, DateTime newDateTime, int newColor) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('events').doc(eventId.toString());

  await doc.update({
    'name': newName,
    'description': newDescription,
    'dateTime': newDateTime,
    'color': newColor,
  });
  debugPrint('[OK] Event updated');
}

updateEventNotifications(int eventId, int not5Min, int not1Hour, int not1Day) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('events').doc(eventId.toString());

  await doc.update({
    'not5Min': not5Min,
    'not1Hour': not1Hour,
    'not1Day': not1Day,
  });
  debugPrint('[OK] Event notifications updated');
}

deleteEventById(int eventId) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('events').doc(eventId.toString());

  await doc.delete();
  debugPrint('[OK] Event deleted');
}

/// HABITS MANAGEMENT

/// TODOS MANAGEMENT
Stream<List<Todo>> readAllTodos() => FirebaseFirestore.instance.
collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
    .snapshots().map((snapshot) =>
    snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());

Stream<List<Todo>> readPendingTodos() => FirebaseFirestore.instance.
collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
    .where('done', isEqualTo: false)
    .orderBy('name', descending: false)
    .orderBy('color', descending: true)
    .snapshots().map((snapshot) =>
    snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());

Stream<List<Todo>> readDoneTodos() => FirebaseFirestore.instance.
collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
    .where('done', isEqualTo: true)
    .orderBy('name', descending: false)
    .orderBy('color', descending: true)
    .snapshots().map((snapshot) =>
    snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());

Future createTodo(int id, String name, String description, int color, bool done) async{
  final user = FirebaseAuth.instance.currentUser!;
  final doc = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('tods').doc(id.toString());

  final json = {
    'id': id,
    'name': name,
    'description': description,
    'color': color,
    'done':done,
  };

  await doc.set(json);
  debugPrint('[OK] Todo created');
}

updateTodo(int todoId, String newName, String newDescription, int newColor, bool newDone) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos').doc(todoId.toString());

  await doc.update({
    'name': newName,
    'description': newDescription,
    'color': newColor,
    'done': newDone,
  });
  debugPrint('[OK] Todo updated');
}

deleteTodoById(int todoId) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos').doc(todoId.toString());

  await doc.delete();
  debugPrint('[OK] Todo deleted');
}

/// NOTES MANAGEMENT