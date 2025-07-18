import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList('tasks') ?? [];
    return tasksJson.map((task) => Task.fromJson(jsonDecode(task))).toList();
  }

  static Future<void> saveThemeMode(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', index);
  }

  static Future<int> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('themeMode') ?? 0;
  }
}