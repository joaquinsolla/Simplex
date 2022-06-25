class Todo{
  final int id;
  final String name;
  final String description;
  final int color;
  final bool done;

  Todo({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.done,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'color': color,
    'done': done,
  };

  static Todo fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    color: json['color'],
    done: json['done'],
  );

}