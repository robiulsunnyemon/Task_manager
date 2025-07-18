import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../enums/sort_by.dart';
import '../models/task_category.dart';
import '../models/task_priority.dart';
import '../widgets/stat_item.dart';
import '../widgets/task_dialog.dart';
import '../services/storage_service.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({
    super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  String _searchQuery = '';
  TaskPriority? _filterPriority;
  TaskCategory? _filterCategory;
  SortBy _sortBy = SortBy.deadline;

  List<Task> get _sortedAndFilteredTasks {
    List<Task> tasks = List.from(_tasks);

    if (_searchQuery.isNotEmpty) {
      tasks = tasks
          .where((task) =>
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    if (_filterPriority != null) {
      tasks = tasks.where((task) => task.priority == _filterPriority).toList();
    }

    if (_filterCategory != null) {
      tasks = tasks.where((task) => task.category == _filterCategory).toList();
    }

    switch (_sortBy) {
      case SortBy.deadline:
        tasks.sort((a, b) {
          if (a.deadline == null) return 1;
          if (b.deadline == null) return -1;
          return a.deadline!.compareTo(b.deadline!);
        });
      case SortBy.priority:
        tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));
      case SortBy.title:
        tasks.sort((a, b) => a.title.compareTo(b.title));
    }

    return tasks;
  }

  Widget _buildStatistics() {
    final total = _tasks.length;
    final completed = _tasks.where((t) => t.isCompleted).length;
    final urgent = _tasks.where((t) => t.priority == TaskPriority.high).length;
    final dueToday = _tasks
        .where((t) =>
    t.deadline?.day == DateTime.now().day &&
        t.deadline?.month == DateTime.now().month &&
        t.deadline?.year == DateTime.now().year)
        .length;

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Wrap(
              spacing: 32,
              runSpacing: 24,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                StatItem(
                  label: 'Total',
                  value: total.toString(),
                  icon: Icons.task,
                ),
                StatItem(
                  label: 'Completed',
                  value: completed.toString(),
                  icon: Icons.done_all,
                  color: Colors.green,
                ),
                StatItem(
                  label: 'Urgent',
                  value: urgent.toString(),
                  icon: Icons.priority_high,
                  color: Colors.red,
                ),
                StatItem(
                  label: 'Due Today',
                  value: dueToday.toString(),
                  icon: Icons.today,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: total > 0 ? completed / total : 0,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList('tasks') ?? [];

    setState(() {
      _tasks = tasksJson.map((task) => Task.fromJson(jsonDecode(task))).toList();
    });
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        onSave: (Task task) {
          setState(() {
            _tasks.add(task);
            _saveTasks();
          });
        },
      ),
    );
  }

  void _editTask(int index) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(
        task: _tasks[index],
        onSave: (Task task) {
          setState(() {
            _tasks[index] = task;
            _saveTasks();
          });
        },
      ),
    );
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
      _saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {

    final filteredTasks = _sortedAndFilteredTasks;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Task Manager'),
        actions: [
          PopupMenuButton<SortBy>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort By',
            onSelected: (SortBy value) {
              setState(() => _sortBy = value);
            },
            itemBuilder: (context) => SortBy.values
                .map(
                  (sort) => PopupMenuItem(
                value: sort,
                child: Row(
                  children: [
                    Icon(
                      _sortBy == sort
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(sort.label),
                  ],
                ),
              ),
            )
                .toList(),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            itemBuilder: (context) => [
              const PopupMenuItem(
                enabled: false,
                child: Text('Priority'),
              ),
              ...TaskPriority.values.map((p) => PopupMenuItem(
                onTap: () => setState(() => _filterPriority = p),
                child: Row(
                  children: [
                    Icon(
                      _filterPriority == p
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(p.label),
                  ],
                ),
              )),
              const PopupMenuItem(
                enabled: false,
                child: Text('Category'),
              ),
              ...TaskCategory.values.map((c) => PopupMenuItem(
                onTap: () => setState(() => _filterCategory = c),
                child: Row(
                  children: [
                    Icon(
                      _filterCategory == c
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(c.label),
                  ],
                ),
              )),
              const PopupMenuItem(
                enabled: false,
                child: Divider(),
              ),
              PopupMenuItem(
                onTap: () => setState(() {
                  _filterPriority = null;
                  _filterCategory = null;
                }),
                child: const Text('Clear Filters'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildStatistics(),
          Expanded(
            child: filteredTasks.isEmpty
                ? Center(
              child: Text(
                _searchQuery.isEmpty
                    ? 'No tasks yet'
                    : 'No tasks found',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
                : ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: task.isCompleted,
                        onChanged: (bool? value) {
                          setState(() {
                            task.isCompleted = value!;
                            _saveTasks();
                          });
                        },
                      ),
                    ),
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.isCompleted
                            ? Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color
                            ?.withOpacity(0.6)
                            : null,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.label,
                                color: task.priority.color, size: 16),
                            Text(' ${task.priority.label}'),
                            const SizedBox(width: 8),
                            Text('• ${task.category.label}'),
                          ],
                        ),
                        if (task.deadline != null)
                          Text(
                            'Deadline: ${DateFormat('d MMM y').format(task.deadline!)}',
                            style: TextStyle(
                              color:
                              task.deadline!.isBefore(DateTime.now())
                                  ? Colors.red
                                  : null,
                            ),
                          ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editTask(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        width: 56,
        height: 56,
        child: FloatingActionButton(
          onPressed: _addTask,
          tooltip: 'Add Task',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}