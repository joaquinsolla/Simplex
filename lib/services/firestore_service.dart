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
Stream<List<Todo>> readPendingLimitedTodos() {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
      .where('done', isEqualTo: false)
      .where('limited', isEqualTo: true)
      .orderBy('priority', descending: true)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());
}

Stream<List<Todo>> readPendingTodosWithPriority(int priority) {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
      .where('done', isEqualTo: false)
      .where('priority', isEqualTo: priority)
      .orderBy('limited', descending: true)
      .orderBy('limitDate', descending: false)
      .orderBy('name', descending: false)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());
}

Stream<List<Todo>> readPendingTodosWithLimitDate(DateTime date) {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
      .where('done', isEqualTo: false)
      .where('limited', isEqualTo: true)
      .where('limitDate', isEqualTo: date)
      .orderBy('priority', descending: true)
      .orderBy('name', descending: false)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());
}

Stream<List<Todo>> readDoneTodos() {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
      .where('done', isEqualTo: true)
      .orderBy('priority', descending: true)
      .orderBy('limited', descending: true)
      .orderBy('limitDate', descending: false)
      .orderBy('name', descending: false)
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
    'priority': todo.priority,
    'limited': todo.limited,
    'limitDate': todo.limitDate,
    'done': todo.done,
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

updateTodo(Todo todo) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos').doc(todo.id.toString());

  await doc.update({
    'name': todo.name,
    'description': todo.description,
    'priority': todo.priority,
    'limited': todo.limited,
    'limitDate': todo.limitDate,
  });
  debugPrint('[OK] Todo updated');
}

deleteTodoById(int todoId) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos').doc(todoId.toString());

  await doc.delete();
  debugPrint('[OK] Todo deleted');
}

deleteDoneTodos() async {
  await FirebaseFirestore.instance.collection('users').doc(
      FirebaseAuth.instance.currentUser!.uid)
      .collection('todos')
      .where('done', isEqualTo: true)
      .get()
      .then((snapshot) {
    for (DocumentSnapshot ds in snapshot.docs) {
      ds.reference.delete();
    }
  });

  debugPrint('[OK] All done todos deleted');
}

/// NOTES MANAGEMENT
Stream<List<Note>> readAllNotes() {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes')
      .orderBy('modificationDate', descending: true)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());
}