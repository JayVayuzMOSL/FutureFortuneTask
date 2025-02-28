import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_task_state.dart';

class EditTaskCubit extends Cubit<EditTaskState> {
  EditTaskCubit()
      : super(EditTaskState(
    title: '',
    note: '',
    date: '',
    time: '',
    reminder: false,
  ));

  void saveTask(String title, String note) {
    emit(state.copyWith(title: title, note: note));
  }

  Future<void> pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      emit(state.copyWith(date: pickedDate.toLocal().toString().split(' ')[0]));
    }
  }

  Future<void> pickTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      emit(state.copyWith(time: pickedTime.format(context)));
    }
  }

  void toggleReminder(bool value) {
    emit(state.copyWith(reminder: value));
  }

  void deleteTask() {
    emit(EditTaskState(
      title: '',
      note: '',
      date: '',
      time: '',
      reminder: false,
    ));
  }
}
