import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_fortune_task/core/constants/app_strings.dart';

import '../../../../core/constants/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearch;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.grey, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: onSearch, // Calls parent function when text changes
              decoration: InputDecoration(
                hintText: AppStrings.searchNotes,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
