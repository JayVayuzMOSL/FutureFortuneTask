import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_fortune_task/features/home/presentation/bloc/add_item_cubit.dart';
import 'package:future_fortune_task/features/home/presentation/bloc/add_item_state.dart';

class AddItemPage extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddItemCubit(),
      child: Scaffold(
        appBar: AppBar(title: Text("New Task")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: notesController,
                decoration: InputDecoration(labelText: "Notes"),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              BlocConsumer<AddItemCubit, AddItemState>(
                listener: (context, state) {
                  if (state is AddItemSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Task Added Successfully!")),
                    );
                    Navigator.pop(context);
                  } else if (state is AddItemFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error)),
                    );
                  }
                },
                builder: (context, state) {
                  return state is AddItemLoading
                      ? CircularProgressIndicator()
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          String title = titleController.text.trim();
                          String notes = notesController.text.trim();
                          context.read<AddItemCubit>().addItem(title, notes);
                        },
                        child: Text("Add Task"),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text("Schedule"),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
