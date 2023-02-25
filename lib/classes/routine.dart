import 'event.dart';
import 'todo.dart';
import 'note.dart';

class Routine{
  final int id;
  final List<Event> eventsList;
  final List<Todo> todosList;
  final List<Note> notesList;

  Routine({
    required this.id,
    required this.eventsList,
    required this.todosList,
    required this.notesList,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'eventsList': eventsList,
    'todosList': todosList,
    'notesList': notesList,
  };

  static Routine fromJson(Map<String, dynamic> json) => Routine(
    id: json['id'],
    eventsList: json['eventsList'],
    todosList: json['todosList'],
    notesList: json['notesList'],
  );

}