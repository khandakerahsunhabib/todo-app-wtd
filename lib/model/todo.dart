import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class ToDo extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? todoText;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4) // New field for description
  String? description;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
    required this.createdAt,
    this.description, // Make description optional initially
  });
}
