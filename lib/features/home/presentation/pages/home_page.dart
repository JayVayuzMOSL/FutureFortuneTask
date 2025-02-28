import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_fortune_task/features/home/presentation/bloc/home_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:future_fortune_task/features/home/presentation/widgets/note_card_widget.dart';
import 'package:future_fortune_task/features/home/presentation/widgets/search_bar_widget.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    GetIt.I<HomeCubit>().fetchItems(); // Fetch items on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes", style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, size: 24.sp),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            const SearchBarWidget(),
            SizedBox(height: 20.h),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                bloc: GetIt.I<HomeCubit>(),
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeLoaded) {
                    return ListView.builder(
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return NoteCard(
                          imageUrl: item["imageUrl"], // Assuming image URL is provided
                          title: item["title"],
                        );
                      },
                    );
                  } else if (state is HomeError) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(child: Text("No notes available"));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Add note functionality
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, size: 28.sp, color: Colors.white),
      ),
    );
  }
}
