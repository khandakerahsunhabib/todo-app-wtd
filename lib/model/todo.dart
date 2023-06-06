import 'package:hive/hive.dart';
part 'todo.g.dart';

@HiveType(typeId: 1)
class ToDo {
  ToDo({required this.id, required this.todoText, this.isDone = false});

  @HiveField(0)
  String? id;

  @HiveField(1)
  String? todoText;

  @HiveField(2)
  bool? isDone;
}
