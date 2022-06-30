import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/classes/all_classes.dart';

/// USER DOC
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
      .snapshots().map((snapshot) =>
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
    'notificationsList': event.notificationsList,
  };

  await doc.set(json);
  debugPrint('[OK] Event created');
}

updateEvent(Event event) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('events').doc(event.id.toString());

  await doc.update({
    'name': event.name,
    'description': event.description,
    'dateTime': event.dateTime,
    'color': event.color,
    'notificationsList': event.notificationsList,
  });
  debugPrint('[OK] Event updated');
}

deleteEventById(int eventId) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('events').doc(eventId.toString());

  await doc.delete();
  debugPrint('[OK] Event deleted');
}

/// TODOS MANAGEMENT
Stream<List<Todo>> readPendingTodos() {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection(
      'todos')
      .where('done', isEqualTo: false)
      .orderBy('limitDate', descending: false)
      .orderBy('name', descending: false)
      .orderBy('color', descending: true)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());
}

Stream<List<Todo>> readDoneTodos() {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
      .where('done', isEqualTo: true)
      .orderBy('limitDate', descending: false)
      .orderBy('name', descending: false)
      .orderBy('color', descending: true)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());
}

Future createTodo(Todo todo) async{
  final user = FirebaseAuth.instance.currentUser!;
  final doc = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('todos').doc(todo.id.toString());

  final json = {
    'id': todo.id,
    'name': todo.name,
    'description': todo.description,
    'color': todo.color,
    'done': todo.done,
    'limitDate': todo.limitDate,
  };

  await doc.set(json);
  debugPrint('[OK] Todo created');
}

toggleTodo(int id, bool newDone) async{
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos').doc(id.toString());

  await doc.update({
    'done': newDone,
  });
  debugPrint('[OK] Todo $id toggled: $newDone');
}

updateTodo(int todoId, String newName, String newDescription, int newColor, DateTime newLimitDate) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos').doc(todoId.toString());

  await doc.update({
    'name': newName,
    'description': newDescription,
    'color': newColor,
    'limitDate': newLimitDate,
  });
  debugPrint('[OK] Todo updated');
}

deleteTodoById(int todoId) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos').doc(todoId.toString());

  await doc.delete();
  debugPrint('[OK] Todo deleted');
}
