import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_fortune_task/config/routes/app_route_names.dart';
import 'package:future_fortune_task/core/constants/app_colors.dart';
import 'package:future_fortune_task/core/constants/app_strings.dart';
import 'package:future_fortune_task/features/home/data/models/note_model.dart';
import 'package:future_fortune_task/features/home/presentation/cubit/note_cubit.dart';
import 'package:future_fortune_task/features/home/presentation/cubit/note_state.dart';

class AddItemPage extends StatefulWidget {
  @override
  _AddItemPageState createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key for validation

  String _selectedPriority = "Medium"; // Default priority
  String _selectedCategory = "Work"; // Default category
  bool _isCompleted = false; // Default status

  final List<String> priorityLevels = ["Low", "Medium", "High"];
  final List<String> categories = ["Work", "Personal", "Shopping", "Others"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.newTask, style: TextStyle(
          color: AppColors.iconColor
        )),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.h),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.titleEmptyError;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: AppStrings.title,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: notesController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppStrings.notesEmptyError;
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: AppStrings.notes,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 10.h),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: InputDecoration(
                  labelText: "Priority",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                items: priorityLevels.map((String priority) {
                  return DropdownMenuItem<String>(
                    value: priority,
                    child: Text(priority),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
              ),
              SizedBox(height: 10.h),

              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: "Category",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              SizedBox(height: 10.h),

              // Completed Checkbox
              CheckboxListTile(
                title: Text("Mark as Completed"),
                value: _isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    _isCompleted = value!;
                  });
                },
              ),
              SizedBox(height: 20.h),

              BlocConsumer<NoteCubit, NoteState>(
                listener: (context, state) {
                  if (state is NoteSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(AppStrings.taskAddedSuccess)),
                    );
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouteNames.homeRoute, // Ensure this route is correctly defined
                          (route) => false, // Removes all previous routes
                    );
                  } else if (state is NoteFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  return state is NoteLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonColor,
                      foregroundColor: AppColors.iconColor,
                    ),
                    child: Text(AppStrings.addItem),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addTask() {
    if (_formKey.currentState!.validate()) {
      String title = titleController.text.trim();
      String notes = notesController.text.trim();

      NoteModel newNote = NoteModel(
        title: title,
        note: notes,
        priority: _selectedPriority, // Selected priority
        category: _selectedCategory, // Selected category
        isCompleted: _isCompleted, // Checkbox value
      );

      context.read<NoteCubit>().addNote(newNote);
    }
  }
}
