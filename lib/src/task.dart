class Task {
  Task({
    required this.id,
    required this.title,
    required this.hour,
    required this.minute,
    this.enabled = true,
  });

  final String id;
  final String title;
  final int hour;
  final int minute;
  final bool enabled;

  Task copyWith({
    String? id,
    String? title,
    int? hour,
    int? minute,
    bool? enabled,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      enabled: enabled ?? this.enabled,
    );
  }
}
