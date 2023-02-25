import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simplex/classes/all_classes.dart';
import 'package:simplex/common/all_common.dart';

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

  createAllRoutines();
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
    'modificationDate': note.modificationDate
  };

  await doc.set(json);
  debugPrint('[OK] Note created');
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
  });
  debugPrint('[OK] Note updated');
}

deleteNoteById(int noteId) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes').doc(noteId.toString());

  await doc.delete();
  debugPrint('[OK] Note deleted');
}

/// ROUTINES MANAGEMENT
/** Routines ids:
 *    1 Monday
 *    2 Tuesday
 *    3 Wednesday
 *    4 Thursday
 *    5 Friday
 *    6 Saturday
 *    7 Sunday
 */

Future createAllRoutines() async{

  final user = FirebaseAuth.instance.currentUser!;
  late dynamic doc;

  debugPrint('[OK] Creating routines:');

  for (int i=1; i<=7; i++){
    doc = FirebaseFirestore.instance.collection('users').doc(user.uid).collection('routines').doc(i.toString());

    final json = {
      'id': i,
      'eventsList': [],
      'todosList': [],
      'notesList': [],
    };

    await doc.set(json);
    debugPrint('   - Routine $i created');
  }

  debugPrint('[OK] All routines created');
}

updateRoutine(Routine routine) async {
  final doc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes').doc(routine.id.toString());

  await doc.update({
    'eventsList': routine.eventsList,
    'todosList': routine.todosList,
    'notesList': routine.notesList,
  });

  debugPrint('[OK] Routine ' + routine.id.toString() + ' updated');
}

/// REPORTS MANAGEMENT
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
  };

  await doc.set(json);
  debugPrint('[OK] Report sent');
}
