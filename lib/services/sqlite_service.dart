import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


Future<Database> initializeDB() async {
  String path = await getDatabasesPath();

  return openDatabase(
    join(path, 'simplex.db'),
    onCreate: (database, version) async {
      await database.execute(
          """CREATE TABLE events (
          id INTEGER PRIMARY KEY, 
          name TEXT NOT NULL,
          description TEXT,
          dateTime DATETIME NOT NULL,
          color INTEGER NOT NULL,
          notification5Min INTEGER NOT NULL,
          notification1Hour INTEGER NOT NULL,
          notification1Day INTEGER NOT NULL)""",
      );
      // TODO: create habits database
      await database.execute(
        """CREATE TABLE habits (
          id INTEGER PRIMARY KEY)""",
      );
      // TODO: create to-do database
      await database.execute(
        """CREATE TABLE todo (
          id INTEGER PRIMARY KEY)""",
      );
    },
    version: 1,
  );
}

/// EVENTS MANAGEMENT HERE
Future<int> createEvent(Event event) async {
  final Database db = await initializeDB();
  final id = await db.insert(
      'events', event.eventToMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
  debugPrint("[OK] Event created/updated: $id");
  return id;
}

Future<List<Event>> getEventById(int id) async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult =
  await db.query('events', where: "id = ?", whereArgs: [id]);
  debugPrint('[OK] Read event');
  return queryResult.map((e) => Event.eventFromMap(e)).toList();
}

Future<List<Event>> getAllEvents() async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult =
  await db.query('events', orderBy: 'dateTime, color, id');
  debugPrint('[OK] Read all events');
  return queryResult.map((e) => Event.eventFromMap(e)).toList();
}

Future<List<Event>> getTodayEvents() async {
  int today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch;
  int tomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1).millisecondsSinceEpoch;

  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult =
  await db.query('events', orderBy: 'dateTime, color, id', where: "dateTime >= ? AND dateTime < ?", whereArgs: [today, tomorrow]);
  return queryResult.map((e) => Event.eventFromMap(e)).toList();
}

Future<List<Event>> getTomorrowEvents() async {
  int tomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+1).millisecondsSinceEpoch;
  int pastTomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+2).millisecondsSinceEpoch;

  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult =
  await db.query('events', orderBy: 'dateTime, color, id', where: "dateTime >= ? AND dateTime < ?", whereArgs: [tomorrow, pastTomorrow]);
  return queryResult.map((e) => Event.eventFromMap(e)).toList();
}

Future<List<Event>> getThisMonthEvents() async {

  int pastTomorrow = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day+2).millisecondsSinceEpoch;
  int nextMonth = DateTime(DateTime.now().year, DateTime.now().month+1, 1).millisecondsSinceEpoch;

  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult =
  await db.query('events', orderBy: 'dateTime, color, id', where: "dateTime >= ? AND dateTime < ?", whereArgs: [pastTomorrow, nextMonth]);
  return queryResult.map((e) => Event.eventFromMap(e)).toList();
}

Future<List<Event>> getRestOfEvents() async {

  int nextMonth = DateTime(DateTime.now().year, DateTime.now().month+1, 1).millisecondsSinceEpoch;

  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult =
  await db.query('events', orderBy: 'dateTime, color, id', where: "dateTime >= ?", whereArgs: [nextMonth]);
  return queryResult.map((e) => Event.eventFromMap(e)).toList();
}

Future<void> deleteEventById(int id) async {
  final Database db = await initializeDB();
  try {
    await db.delete("events", where: "id = ?", whereArgs: [id]);
  } catch (err) {
    debugPrint("[ERR] Could not delete event: $err");
  }
  debugPrint("[OK] Event deleted");
}

Future<void> deleteExpiredEvents() async {

  int now = DateTime.now().millisecondsSinceEpoch;

  final Database db = await initializeDB();
  try {
    await db.delete("events", where: "dateTime < ?", whereArgs: [now]);
    debugPrint("[OK] Expired event deleted");
  } catch (err) {
    debugPrint("[ERR] Could not delete expired event: $err");
  }
}

/// HABITS MANAGEMENT HERE

/// TO-DOS MANAGEMENT HERE

/// CLASSES HERE

class Event{
  final int id;
  final String name;
  String description;
  final int dateTime;
  final int color;
  final int notification5Min;
  final int notification1Hour;
  final int notification1Day;

  Event({required this.id, required this.name, required this.description, required this.dateTime, required this.color, required this.notification5Min, required this.notification1Hour, required this.notification1Day});

  Event.eventFromMap(Map<String, dynamic> item):
        id=item["id"], name=item["name"], description= item["description"], dateTime=item["dateTime"], color=item["color"], notification5Min=item["notification5Min"], notification1Hour=item["notification1Hour"], notification1Day=item["notification1Day"];

  Map<String, Object> eventToMap(){
    return {'id':id, 'name':name, 'description':description, 'dateTime':dateTime, 'color':color, 'notification5Min':notification5Min, 'notification1Hour':notification1Hour, 'notification1Day':notification1Day};
  }
}