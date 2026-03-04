import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/task.dart';
import 'src/task_controller.dart';

void main() {
  runApp(const ProviderScope(child: TaskRemindApp()));
}

class TaskRemindApp extends ConsumerWidget {
  const TaskRemindApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkMode = ref.watch(darkModeProvider);

    return MaterialApp(
      title: 'TaskRemind Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _titleController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListProvider);
    final globalEnabled = ref.watch(globalRemindersProvider);
    final darkMode = ref.watch(darkModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('TaskRemind Pro')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Enable all reminders'),
              value: globalEnabled,
              onChanged: (value) =>
                  ref.read(globalRemindersProvider.notifier).state = value,
            ),
            SwitchListTile(
              title: const Text('Dark mode'),
              value: darkMode,
              onChanged: (value) =>
                  ref.read(darkModeProvider.notifier).state = value,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Task title'),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );
                    if (picked != null) {
                      setState(() => _selectedTime = picked);
                    }
                  },
                  child: Text(_selectedTime.format(context)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () {
                final title = _titleController.text.trim();
                if (title.isEmpty) return;
                ref
                    .read(taskListProvider.notifier)
                    .addTask(title, _selectedTime.hour, _selectedTime.minute);
                _titleController.clear();
              },
              child: const Text('Add task'),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _TaskTile(task: task);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends ConsumerWidget {
  const _TaskTile({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time =
        '${task.hour.toString().padLeft(2, '0')}:${task.minute.toString().padLeft(2, '0')}';

    return Card(
      child: ListTile(
        title: Text(task.title),
        subtitle: Text('Daily at $time'),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => ref.read(taskListProvider.notifier).deleteTask(task.id),
        ),
      ),
    );
  }
}
