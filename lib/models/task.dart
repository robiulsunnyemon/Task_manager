import 'package:intl/intl.dart';
import 'task_priority.dart';
import 'task_category.dart';

class Task {
  String title;
  bool isCompleted;
  DateTime? deadline;
  TaskPriority priority;
  TaskCategory category;

  Task({
    required this.title,
    required this.isCompleted,
    this.deadline,
    this.priority = TaskPriority.medium,
    this.category = TaskCategory.personal,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
      'deadline': deadline?.toIso8601String(),
      'priority': priority.index,
      'category': category.index,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      isCompleted: json['isCompleted'],
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      priority: TaskPriority.values[json['priority']],
      category: TaskCategory.values[json['category']],
    );
  }
}