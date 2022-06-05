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
          date DATETIME NOT NULL,
          color INTEGER NOT NULL,
          notificationDay INTEGER NOT NULL,
          notificationWeek INTEGER NOT NULL,
          notificationMonth INTEGER NOT NULL)""",
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

Future<int> createEvent(Event event) async {
  final Database db = await initializeDB();
  final id = await db.insert(
      'events', event.eventToMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);
  return id;
}

Future<List<Event>> getEvents() async {
  final Database db = await initializeDB();
  final List<Map<String, Object?>> queryResult =
  await db.query('events', orderBy: 'date');
  return queryResult.map((e) => Event.eventFromMap(e)).toList();
}

Future<void> deleteEvent(String id) async {
  final Database db = await initializeDB();
  try {
    await db.delete("events", where: "id = ?", whereArgs: [id]);
  } catch (err) {
    debugPrint("[ERR] Could not delete item: $err");
  }
}

class Event{
  final int id;
  final String name;
  String description;
  final int date;
  final int color;
  final int notificationDay;
  final int notificationWeek;
  final int notificationMonth;

  Event({required this.id, required this.name, required this.description, required this.date, required this.color, required this.notificationDay, required this.notificationWeek, required this.notificationMonth});

  Event.eventFromMap(Map<String, dynamic> item):
        id=item["id"], name=item["name"], description= item["description"], date=item["date"], color=item["color"], notificationDay=item["notificationDay"], notificationWeek=item["notificationWeek"], notificationMonth=item["notificationMonth"];

  Map<String, Object> eventToMap(){
    return {'id':id, 'name':name, 'description':description, 'date':date, 'color':color, 'notificationDay':notificationDay, 'notificationWeek':notificationWeek, 'notificationMonth':notificationMonth};
  }
}