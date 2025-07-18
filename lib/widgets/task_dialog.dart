import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../models/task_priority.dart';
import '../models/task_category.dart';

class TaskDialog extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const TaskDialog({
    super.key,
    this.task,
    required this.onSave,
  });

  @override
  State<TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  late TextEditingController _titleController;
  late DateTime? _deadline;
  late TaskPriority _priority;
  late TaskCategory _category;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _deadline = widget.task?.deadline;
    _priority = widget.task?.priority ?? TaskPriority.medium;
    _category = widget.task?.category ?? TaskCategory.personal;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.task == null ? 'New Task' : 'Edit Task',
        style: const TextStyle(fontSize: 18),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'Task Title',
                labelStyle: TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(_deadline == null
                    ? 'Set Deadline'
                    : 'Deadline: ${DateFormat('d MMM y').format(_deadline!)}'),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _deadline ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      setState(() => _deadline = date);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskPriority>(
              value: _priority,
              decoration: const InputDecoration(
                labelText: 'Priority',
              ),
              items: TaskPriority.values.map((priority) {
                return DropdownMenuItem(
                  value: priority,
                  child: Text(priority.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _priority = value!);
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<TaskCategory>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
              ),
              items: TaskCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category.label),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _category = value!);
              },
            ),
          ],
        ),
      ),
      contentPadding: const EdgeInsets.all(16),
      actions: [
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(fontSize: 14),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text(
            'Save',
            style: TextStyle(fontSize: 14),
          ),
          onPressed: () {
            if (_titleController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please enter task title')),
              );
              return;
            }
            widget.onSave(Task(
              title: _titleController.text,
              isCompleted: widget.task?.isCompleted ?? false,
              deadline: _deadline,
              priority: _priority,
              category: _category,
            ));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}