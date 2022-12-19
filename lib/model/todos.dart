import 'dart:convert';


TaskModel taskFromJson(String str) => TaskModel.fromJson(json.decode(str));

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

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
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
}