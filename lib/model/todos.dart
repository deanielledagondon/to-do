import 'dart:convert';


TaskModel taskFromMap(String str) => TaskModel.fromMap(json.decode(str));

String taskToJson(TaskModel data) => json.encode(data.toJson());

class TaskModel {
  TaskModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  int? userId;
  int? id;
  String? title;
  bool? completed;

  factory TaskModel.fromMap(Map<String, dynamic> json) => TaskModel(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "completed": completed,
  };

  Map<String, dynamic> toMap() =>
      {"id": id, "title": title, "completed": completed};
}