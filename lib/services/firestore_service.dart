import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simplex/classes/all_classes.dart';
import 'package:simplex/classes/stats/usage_stat.dart';
import 'package:simplex/classes/stats/users_stat.dart';
import 'package:simplex/common/all_common.dart';

import '../classes/stats/reports_stat.dart';

//#region User doc
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
//#endregion

//#region Stats
addElement(String element) async {
  /** ELEMENTS:
   *  - events
   *  - todos
   *  - notes
   * */

  final doc = FirebaseFirestore.instance.collection('stats').doc(element);
  final total = (await doc.get())['total'];
  final active = (await doc.get())['active'];

  await doc.update({
    'total': (total+1),
    'active': (active+1),
  });
  debugPrint('[OK] $element stats updated');
}

subtractElement(String element) async {
  /** ELEMENTS:
   *  - events
   *  - todos
   *  - notes
   * */

  final doc = FirebaseFirestore.instance.collection('stats').doc(element);
  final active = (await doc.get())['active'];
  final deleted = (await doc.get())['deleted'];

  await doc.update({
    'active': (active-1),
    'deleted': (deleted+1),
  });
  debugPrint('[OK] $element stats updated');
}

Stream<UsersStat> readUsersStats() {
  final _controller = BehaviorSubject<UsersStat>();

  int total = 0;
  int verified = 0;
  int tester = 0;

  void updateUsersStat() {
    final usersStat = UsersStat(
        total: total,
        verified: verified,
        tester: tester,
    );

    _controller.add(usersStat);
  }

  FirebaseFirestore.instance.collection('users').get().then((querySnapshot) {
    total = querySnapshot.size -1;
    updateUsersStat();
  });

  FirebaseFirestore.instance.collection('users')
      .where('emailVerified', isEqualTo: true)
      .get().then((querySnapshot) {
    verified = querySnapshot.size;
    updateUsersStat();
  });

  FirebaseFirestore.instance.collection('users')
      .where('tester', isEqualTo: true)
      .get().then((querySnapshot) {
    tester = querySnapshot.size;
    updateUsersStat();
  });

  return _controller.stream;
}

Stream<UsageStat> readUsageStats(String name) {
  final _controller = BehaviorSubject<UsageStat>();

  int total = 0;
  int active = 0;
  int deleted = 0;

  void updateUsageStat() {
    final usageStat = UsageStat(
      name: name,
      total: total,
      active: active,
      deleted: deleted,
    );

    _controller.add(usageStat);
  }

  FirebaseFirestore.instance
      .collection('stats')
      .doc(name)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      total = documentSnapshot.get('total');
      active = documentSnapshot.get('active');
      deleted = documentSnapshot.get('deleted');
      updateUsageStat();
    } else {
      debugPrint('[ERR] Usage stats for $name do not exist.');
    }
  });

  return _controller.stream;
}

Stream<ReportsStat> readReportsStats(bool active) {
  final _controller = BehaviorSubject<ReportsStat>();

  int quantity = 0;

  String status = 'active';
  if (active == false) status = 'closed';

  void updateReportsStat() {
    final reportsStat = ReportsStat(
      status: status,
      quantity: quantity,
    );

    _controller.add(reportsStat);
  }

  FirebaseFirestore.instance.collection('reports')
      .where('active', isEqualTo: active)
      .get().then((querySnapshot) {
    quantity = querySnapshot.size;
    updateReportsStat();
  });

  return _controller.stream;
}

//#endregion

//#region Events
Stream<List<Event>> readAllEvents() {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events')
      .where('routineEvent', isEqualTo: false)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());
}

Stream<List<Event>> readEventsOfDate(DateTime date) {
  DateTime selectedDay = DateTime(date.year, date.month, date.day);
  DateTime nextDay = DateTime(date.year, date.month, date.day+1);

  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events')
      .where('routineEvent', isEqualTo: false)
      .where('date', isGreaterThanOrEqualTo: selectedDay)
      .where('date', isLessThan: nextDay)
      .orderBy('date', descending: false)
      .orderBy('time', descending: false)
      .orderBy('color', descending: true)
      .orderBy('id', descending: false)
      .snapshots().map((snapshot) => snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());
}

Future createEvent(Event event) async{
  final user = FirebaseAuth.instance.currentUser!;
  final doc = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('events').doc(event.id.toString());

  final json = {
    'id': event.id,
    'name': event.name,
    'description': event.description,
    'date': event.date,
    'time': event.time,
    'color': event.color,
    'notificationsList': event.notificationsList,
    'routinesList': event.routinesList,
    'routineEvent': event.routineEvent,
  };

  await doc.set(json);
  debugPrint('[OK] Event created');
  await addElement("events");
}

updateEvent(Event event) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('events').doc(event.id.toString());

  await doc.update({
    'name': event.name,
    'description': event.description,
    'date': event.date,
    'time': event.time,
    'color': event.color,
    'notificationsList': event.notificationsList,
    'routinesList': event.routinesList,
    'routineEvent': event.routineEvent,
  });
  debugPrint('[OK] Event updated');
}

deleteEventById(int eventId) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('events').doc(eventId.toString());

  await doc.delete();
  debugPrint('[OK] Event deleted');
  await subtractElement("events");
}
//#endregion

//#region Todos
Stream<List<Todo>> readPendingLimitedTodos() {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
      .where('done', isEqualTo: false)
      .where('limited', isEqualTo: true)
      .orderBy('priority', descending: true)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());
}

Stream<List<Todo>> readPendingLimitedTodosByDateTime(DateTime date) {
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

Stream<List<Todo>> readPendingTodosByPriorityAndName(int priority, String content) {
  if (content == "") return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
      .where('done', isEqualTo: false)
      .where('priority', isEqualTo: priority)
      .orderBy('limited', descending: true)
      .orderBy('limitDate', descending: false)
      .orderBy('name', descending: false)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());

  // Cannot use orderBy
  else return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
      .where('done', isEqualTo: false)
      .where('priority', isEqualTo: priority)
      .where('name', isGreaterThanOrEqualTo: content)
      .where('name', isLessThanOrEqualTo: content+ '\uf8ff')
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());

}

Stream<List<Todo>> readDoneTodosByName(String content) {
  if (content == "") return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
      .where('done', isEqualTo: true)
      .orderBy('priority', descending: true)
      .orderBy('limited', descending: true)
      .orderBy('limitDate', descending: false)
      .orderBy('name', descending: false)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Todo.fromJson(doc.data())).toList());

  // Cannot use orderBy
  else return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('todos')
      .where('done', isEqualTo: true)
      .where('name', isGreaterThanOrEqualTo: content)
      .where('name', isLessThanOrEqualTo: content+ '\uf8ff')
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
  await addElement("todos");
}

toggleTodo(int id, String name, bool limited, DateTime limitDate, bool newDone) async{
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('todos').doc(id.toString());

  if (limited){
    if (newDone) cancelAllTodoNotifications(id);
    else if (limitDate.isAfter(DateTime.now())) buildTodoNotifications(id, 'Tarea pendiente: ' + name, limitDate);
  }

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
  await subtractElement("todos");
}

deleteDoneTodos() async {
  await FirebaseFirestore.instance.collection('users').doc(
      FirebaseAuth.instance.currentUser!.uid)
      .collection('todos')
      .where('done', isEqualTo: true)
      .get()
      .then((snapshot) async {
    for (DocumentSnapshot ds in snapshot.docs) {
      ds.reference.delete();
      await subtractElement("todos");
    }
  });

  debugPrint('[OK] All done todos deleted');
}
//#endregion

//#region Notes
Stream<List<Note>> readCalendarNotes() {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes')
      .where('onCalendar', isEqualTo: true)
      .orderBy('modificationDate', descending: true)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());
}

Stream<List<Note>> readCalendarNotesByDateTime(DateTime date) {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes')
      .where('onCalendar', isEqualTo: true)
      .where('calendarDate', isEqualTo: date)
      .orderBy('modificationDate', descending: true)
      .orderBy('name', descending: false)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());
}

Stream<List<Note>> readNotesByTitle(String content) {
  if (content == "") return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes')
      .orderBy('modificationDate', descending: true)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());

  // Cannot use orderBy
  else return FirebaseFirestore.instance.
    collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes')
        .where('name', isGreaterThanOrEqualTo: content)
        .where('name', isLessThanOrEqualTo: content+ '\uf8ff')
        .snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());
}

Future createNote(Note note) async{
  final user = FirebaseAuth.instance.currentUser!;
  final doc = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('notes').doc(note.id.toString());

  final json = {
    'id': note.id,
    'name': note.name,
    'content': note.content,
    'onCalendar': note.onCalendar,
    'calendarDate': note.calendarDate,
    'modificationDate': note.modificationDate,
    'routinesList': note.routinesList,
    'routineNote': note.routineNote,
  };

  await doc.set(json);
  debugPrint('[OK] Note created');
  await addElement("notes");
}

updateNote(Note note) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes').doc(note.id.toString());

  await doc.update({
    'name': note.name,
    'content': note.content,
    'onCalendar': note.onCalendar,
    'calendarDate': note.calendarDate,
    'modificationDate': note.modificationDate,
    'routinesList': note.routinesList,
    'routineNote': note.routineNote,
  });
  debugPrint('[OK] Note updated');
}

deleteNoteById(int noteId) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes').doc(noteId.toString());

  await doc.delete();
  debugPrint('[OK] Note deleted');
  await subtractElement("notes");
}
//#endregion

//#region Routines
Stream<List<Note>> readNotesOfRoutine(int day) {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('notes')
      .where('routineNote', isEqualTo: true)
      .where('routinesList', arrayContains: day)
      .orderBy('modificationDate', descending: true)
      .orderBy('name', descending: false)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Note.fromJson(doc.data())).toList());
}

Stream<List<Event>> readEventsOfRoutine(int day) {
  return FirebaseFirestore.instance.
  collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('events')
      .where('routineEvent', isEqualTo: true)
      .where('routinesList', arrayContains: day)
      .orderBy('time', descending: false)
      .orderBy('color', descending: true)
      .orderBy('id', descending: false)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Event.fromJson(doc.data())).toList());
}
//#endregion

//#region Reports
Stream<List<Report>> readReports() {
  return FirebaseFirestore.instance.
  collection('reports')
      .orderBy('date', descending: false)
      .snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Report.fromJson(doc.data())).toList());
}

Future sendReport(Report report, bool sendAccountData) async{
  final user = FirebaseAuth.instance.currentUser!;
  final doc = FirebaseFirestore.instance.collection('reports').doc(report.id);

  if (sendAccountData){
    report.userId = user.uid;
    report.userEmail = user.email;
  }

  final json = {
    'id': report.id,
    'problem': report.problem,
    'date': report.date,
    'userId': report.userId,
    'userEmail': report.userEmail,
    'active': report.active,
  };

  await doc.set(json);
  debugPrint('[OK] Report sent');
}
//#endregion
