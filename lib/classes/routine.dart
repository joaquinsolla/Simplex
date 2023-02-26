class Routine{
  final int id;
  final List<dynamic> eventsList;
  final List<dynamic> notesList;

  Routine({
    required this.id,
    required this.eventsList,
    required this.notesList,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'eventsList': eventsList,
    'notesList': notesList,
  };

  static Routine fromJson(Map<String, dynamic> json) => Routine(
    id: json['id'],
    eventsList: json['eventsList'],
    notesList: json['notesList'],
  );

}