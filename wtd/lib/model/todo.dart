import 'package:hive/hive.dart';
part 'todo.g.dart';

@HiveType(typeId: 1)
class ToDo{
  ToDo({
    required this.id,
    required this.todoText,
    this.isDone=false
});

  @HiveField(0)
  String? id;

  @HiveField(1)
  String? todoText;

  @HiveField(2)
  bool? isDone;
}

// class ToDo{
//   String? id;
//   String? todoText;
//   bool? isDone;
//
//   ToDo({
//     required this.id,
//     required this.todoText,
//     this.isDone=false
//   });
//
//   static List<ToDo> todoList(){
//     return [
//       ToDo(id: '01', todoText: 'Morning Excercise', isDone: true),
//       ToDo(id: '02', todoText: 'By Groceries', isDone: true),
//       ToDo(id: '03', todoText: 'Check Email'),
//       ToDo(id: '04', todoText: 'Front-end Meeting'),
//       ToDo(id: '05', todoText: 'App development practice'),
//       ToDo(id: '06', todoText: 'Dinner with Luna'),
//     ];
//   }
// }
