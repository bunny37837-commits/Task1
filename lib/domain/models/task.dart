import 'package:isar/isar.dart';

enum RepeatType { none, daily }

@collection
class Task {
  Id id = Isar.autoIncrement;

  @Index(caseSensitive: false)
  late String title;
  String? description;
  late DateTime remindAt;
  bool isEnabled = true;

  @enumerated
  RepeatType repeatType = RepeatType.none;

  DateTime? lastTriggeredAt;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
}
