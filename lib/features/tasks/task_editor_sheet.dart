import 'package:flutter/material.dart';
import 'package:taskremind_pro/domain/models/task.dart';

class TaskEditorSheet extends StatefulWidget {
  const TaskEditorSheet({super.key, required this.onSave});

  final Future<void> Function({
    required String title,
    String? description,
    required DateTime remindAt,
    required RepeatType repeatType,
  }) onSave;

  @override
  State<TaskEditorSheet> createState() => _TaskEditorSheetState();
}

class _TaskEditorSheetState extends State<TaskEditorSheet> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  DateTime _when = DateTime.now().add(const Duration(minutes: 30));
  RepeatType _repeat = RepeatType.none;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 8),
          TextField(controller: _desc, decoration: const InputDecoration(labelText: 'Description')),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: Text('Reminder: ${_when.toLocal()}')),
              TextButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (date == null || !context.mounted) return;
                  final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (time == null) return;
                  setState(() {
                    _when = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                  });
                },
                child: const Text('Pick'),
              ),
            ],
          ),
          DropdownButtonFormField<RepeatType>(
            initialValue: _repeat,
            items: const [
              DropdownMenuItem(value: RepeatType.none, child: Text('No repeat')),
              DropdownMenuItem(value: RepeatType.daily, child: Text('Daily')),
            ],
            onChanged: (value) => setState(() => _repeat = value ?? RepeatType.none),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              if (_title.text.trim().isEmpty) return;
              await widget.onSave(
                title: _title.text.trim(),
                description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
                remindAt: _when,
                repeatType: _repeat,
              );
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Save task'),
          ),
        ],
      ),
    );
  }
}
