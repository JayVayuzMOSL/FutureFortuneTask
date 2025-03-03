import 'package:flutter/material.dart';
import 'package:future_fortune_task/core/constants/app_colors.dart';
import 'package:future_fortune_task/core/constants/app_strings.dart';

void showDeleteDialog(BuildContext context, VoidCallback onDelete) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          AppStrings.deleteTask,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          AppStrings.confirmDelete,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close dialog
            child: const Text(
              AppStrings.cancel,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete(); // Call delete function
              Navigator.of(context).pop(); // Close dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor, // Match button color
            ),
            child: const Text(AppStrings.delete, style: TextStyle(
              color: AppColors.iconColor
            )),
          ),
        ],
      );
    },
  );
}
