import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taskremind_pro/domain/models/task.dart';
import 'package:taskremind_pro/features/settings/settings_screen.dart';
import 'package:taskremind_pro/features/tasks/task_controller.dart';
import 'package:taskremind_pro/features/tasks/task_editor_sheet.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskRemind Pro'),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
            ),
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: tasks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed: $err')),
        data: (items) {
          if (items.isEmpty) return const Center(child: Text('No reminders yet'));
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) => _TaskTile(task: items[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => TaskEditorSheet(
            onSave: ({required title, description, required remindAt, required repeatType}) {
              return ref.read(taskControllerProvider.notifier).createTask(
                    title: title,
                    description: description,
                    remindAt: remindAt,
                    repeatType: repeatType,
                  );
            },
          ),
        ),
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Colors.primaries[task.title.hashCode.abs() % Colors.primaries.length];
    return Card(
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 5)),
          ),
          child: ListTile(
            title: Text(task.title),
            subtitle: Text('${task.remindAt} • ${task.repeatType.name}'),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'done') ref.read(taskControllerProvider.notifier).done(task);
                if (value == 'snooze') ref.read(taskControllerProvider.notifier).snooze(task);
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'done', child: Text('Done')),
                PopupMenuItem(value: 'snooze', child: Text('Snooze 10 min')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
