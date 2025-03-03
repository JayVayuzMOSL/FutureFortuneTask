import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_fortune_task/core/constants/app_colors.dart';
import 'package:future_fortune_task/features/home/data/models/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel notesModel;

  const NoteCard({super.key, required this.notesModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Card(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              child: Text(
                notesModel.title,
                style: TextStyle(color: AppColors.primaryTextColor, fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.w),
              child: Text(
                notesModel.note,
                style: TextStyle(color: AppColors.primaryTextColor, fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
