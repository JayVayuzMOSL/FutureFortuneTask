import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_fortune_task/config/routes/app_route_names.dart';
import 'package:future_fortune_task/core/constants/app_colors.dart';
import 'package:future_fortune_task/core/constants/app_strings.dart';
import 'package:future_fortune_task/features/home/data/models/note_model.dart';
import 'package:future_fortune_task/features/home/presentation/cubit/note_cubit.dart';
import 'package:future_fortune_task/features/home/presentation/cubit/note_state.dart';
import 'package:future_fortune_task/features/home/presentation/widgets/delete_dialog.dart';

class EditTaskPage extends StatefulWidget {
  final NoteModel noteModel;

  const EditTaskPage({super.key, required this.noteModel});

  @override
  State<EditTaskPage> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  String? selectedCategory;
  String? selectedPriority;

  final List<String> categories = ['Work', 'Personal', 'Shopping', 'Other'];
  final List<String> priorities = ['High', 'Medium', 'Low'];

  @override
  void initState() {
    super.initState();
    titleController.text = widget.noteModel.title;
    noteController.text = widget.noteModel.note;
    selectedCategory = widget.noteModel.category;
    selectedPriority = widget.noteModel.priority;
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoteCubit, NoteState>(
      listener: (context, state) {
        if (state is NoteSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.taskUpdatedSuccess)),
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRouteNames.homeRoute, // Ensure this route is correctly defined
                (route) => false, // Removes all previous routes
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.editTask, style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(AppStrings.title, titleController),
                    SizedBox(height: 16.h),
                    _buildTextField(AppStrings.notes, noteController, maxLines: 4),
                    SizedBox(height: 16.h),
                    _buildDropdown(AppStrings.category, categories, selectedCategory, (value) {
                      setState(() => selectedCategory = value);
                    }),
                    SizedBox(height: 16.h),
                    _buildDropdown(AppStrings.priority, priorities, selectedPriority, (value) {
                      setState(() => selectedPriority = value);
                    }),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      color: AppColors.primaryColor,
                      onPressed: _saveTask,
                      child: Text(AppStrings.save, style: TextStyle(color: AppColors.iconColor)),
                    ),
                  ),
                  SizedBox(width: 20.w,),
                  Expanded(child: _buildDeleteButton(context)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextFormField(controller: controller, maxLines: maxLines, decoration: _inputDecoration()),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() => InputDecoration(
    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
  );

  Widget _buildDeleteButton(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        showDeleteDialog(context, () {
          context.read<NoteCubit>().deleteNote(widget.noteModel.id ?? '');
        });
      },
      color: AppColors.grey,
      child: const Text(AppStrings.deleteTask, style: TextStyle(color: Colors.black)),
    );
  }

  void _saveTask() {
    context.read<NoteCubit>().updateNote(
      NoteModel(
        id: widget.noteModel.id,
        title: titleController.text,
        note: noteController.text,
        category: selectedCategory ?? widget.noteModel.category,
        priority: selectedPriority ?? widget.noteModel.priority,
      ),
    );
    Navigator.of(context).pushReplacementNamed(AppRouteNames.homeRoute);
  }
}
