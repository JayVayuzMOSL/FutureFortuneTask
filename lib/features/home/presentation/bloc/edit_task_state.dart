part of 'edit_task_cubit.dart';

class EditTaskState {
  final String title;
  final String note;
  final String? date;
  final String? time;
  final bool reminder;

  EditTaskState({
    this.title = '',
    this.note = '',
    this.date,
    this.time,
    this.reminder = false,
  });

  EditTaskState copyWith({
    String? title,
    String? note,
    String? date,
    String? time,
    bool? reminder,
  }) {
    return EditTaskState(
      title: title ?? this.title,
      note: note ?? this.note,
      date: date ?? this.date,
      time: time ?? this.time,
      reminder: reminder ?? this.reminder,
    );
  }
}
