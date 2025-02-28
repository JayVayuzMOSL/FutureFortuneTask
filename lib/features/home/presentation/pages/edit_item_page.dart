import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_fortune_task/features/home/presentation/bloc/edit_task_cubit.dart';

class EditTaskPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditTaskCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit task', style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            TextButton(
              onPressed: () {
                context.read<EditTaskCubit>().saveTask(
                  titleController.text,
                  noteController.text,
                );
              },
              child: const Text('Save', style: TextStyle(color: Colors.blue)),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Title'),
              TextField(controller: titleController, decoration: _inputDecoration()),
              const SizedBox(height: 16),
              const Text('Note'),
              TextField(controller: noteController, maxLines: 4, decoration: _inputDecoration()),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildDateField(context)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTimeField(context)),
                ],
              ),
              const SizedBox(height: 16),
              _buildReminderSwitch(context),
              const Spacer(),
              _buildDeleteButton(context),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration() => const InputDecoration(
    filled: true,
    fillColor: Colors.grey,
    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
  );

  Widget _buildDateField(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<EditTaskCubit>().pickDate(context),
      child: AbsorbPointer(
        child: TextField(
          decoration: _inputDecoration().copyWith(hintText: 'Date'),
          controller: TextEditingController(text: context.watch<EditTaskCubit>().state.date.toString()),
        ),
      ),
    );
  }

  Widget _buildTimeField(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<EditTaskCubit>().pickTime(context),
      child: AbsorbPointer(
        child: TextField(
          decoration: _inputDecoration().copyWith(hintText: 'Time'),
          controller: TextEditingController(text: context.watch<EditTaskCubit>().state.time.toString()),
        ),
      ),
    );
  }

  Widget _buildReminderSwitch(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Reminder'),
            Text('At time of event', style: TextStyle(color: Colors.grey)),
          ],
        ),
        Switch(
          value: context.watch<EditTaskCubit>().state.reminder,
          onChanged: (value) => context.read<EditTaskCubit>().toggleReminder(value),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () => context.read<EditTaskCubit>().deleteTask(),
        icon: const Icon(Icons.delete, color: Colors.black),
        label: const Text('Delete task', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
