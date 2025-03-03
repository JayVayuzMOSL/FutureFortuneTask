import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_fortune_task/config/routes/app_route_names.dart';
import 'package:future_fortune_task/core/constants/app_strings.dart';
import 'package:future_fortune_task/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_fortune_task/features/home/presentation/cubit/note_cubit.dart';
import 'package:future_fortune_task/features/home/presentation/cubit/note_state.dart';
import 'package:future_fortune_task/features/home/presentation/widgets/note_card_widget.dart';
import 'package:future_fortune_task/features/home/presentation/widgets/search_bar_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    context.read<NoteCubit>().fetchNotes(); // Fetch items on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.notes,
            style: TextStyle(
                fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColors.iconColor)),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 24.sp, color: AppColors.iconColor),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout, size: 24.sp, color: AppColors.iconColor),
            onPressed: () {
              context.read<NoteCubit>().logoutUser();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            SearchBarWidget(
              searchController: _searchController,
              onSearch: (query) {
                context.read<NoteCubit>().searchNotes(query);
              },
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocConsumer<NoteCubit, NoteState>(
                bloc: context.watch<NoteCubit>(),
                builder: (context, state) {
                  if (state is NoteLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NoteLoaded) {
                    if (state.notes.isEmpty) {
                      return const Center(child: Text(AppStrings.noNotesAvailable));
                    }
                    return ListView.builder(
                      itemCount: state.notes.length,
                      itemBuilder: (context, index) {
                        final item = state.notes[index];

                        return Visibility(
                          visible: item.title.isNotEmpty,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, AppRouteNames.editItemRoute,
                                  arguments: item);
                            },
                            child: NoteCard(
                              notesModel: item,
                            ),
                          ),
                        );
                      },
                    );
                  } else if (state is NoteFailure) {
                    return Center(child: Text(state.error));
                  }
                  return const Center(child: Text(AppStrings.noNotesAvailable));
                }, listener: (BuildContext context, NoteState state) {
                  if(state is NoteLogoutSuccess){
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRouteNames.loginRoute, // Ensure this route is correctly defined
                          (route) => false, // Removes all previous routes
                    );
                  }
              },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRouteNames.addItemRoute);
        },
        backgroundColor: AppColors.fabColor,
        child: Icon(Icons.add, size: 28.sp, color: AppColors.iconColor),
      ),
    );
  }
}
