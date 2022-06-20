import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/classes/event.dart';


Future createUserDoc() async{
  final user = FirebaseAuth.instance.currentUser!;
  final doc = FirebaseFirestore.instance.collection('users').doc(user.uid);

  final json = {
    'userId': user.uid,
  };

  await doc.set(json);
  debugPrint('[OK] User doc created');
}

/// EVENTS MANAGEMENT
Stream<List<Event>> readTodayEvents() => FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events')
    .where('dateTime', isGreaterThanOrEqualTo: DateTime.now())
    .where('dateTime', isLessThan: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1))
    .orderBy('dateTime', descending: false)
    .orderBy('color', descending: true).orderBy('id', descending: false).snapshots().map((snapshot) =>
    snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());

Stream<List<Event>> readTomorrowEvents() => FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events')
    .where('dateTime', isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1))
    .where('dateTime', isLessThan: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+2))
    .orderBy('dateTime', descending: false)
    .orderBy('color', descending: true).orderBy('id', descending: false).snapshots().map((snapshot) =>
    snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());

Stream<List<Event>> readThisMonthEvents() => FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events')
    .where('dateTime', isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+2))
    .where('dateTime', isLessThan: DateTime(DateTime.now().year, DateTime.now().month + 1, 1))
    .orderBy('dateTime', descending: false)
    .orderBy('color', descending: true).orderBy('id', descending: false).snapshots().map((snapshot) =>
    snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());

Stream<List<Event>> readRestOfEvents() => FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events')
    .where('dateTime', isGreaterThanOrEqualTo: DateTime(DateTime.now().year, DateTime.now().month + 1, 1))
    .orderBy('dateTime', descending: false)
    .orderBy('color', descending: true).orderBy('id', descending: false).snapshots().map((snapshot) =>
    snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());

Stream<List<Event>> readExpiredEvents() => FirebaseFirestore.instance.
collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events')
    .where('dateTime', isLessThan: DateTime.now())
    .orderBy('dateTime', descending: false)
    .orderBy('color', descending: true).orderBy('id', descending: false).snapshots().map((snapshot) =>
    snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());

Future createEvent(int id, String name, String description, DateTime dateTime, int color, int not5Min, int not1Hour, int not1Day) async{
  final user = FirebaseAuth.instance.currentUser!;
  final doc = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('events').doc(id.toString());

  final json = {
    'id': id,
    'name': name,
    'description': description,
    'dateTime': dateTime,
    'color': color,
    'not5Min': not5Min,
    'not1Hour': not1Hour,
    'not1Day': not1Day,
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

/// NOTES MANAGEMENT