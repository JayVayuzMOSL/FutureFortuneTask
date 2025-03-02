import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_fortune_task/features/home/presentation/bloc/add_item_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddItemCubit extends Cubit<AddItemState> {
  AddItemCubit() : super(AddItemInitial());

  void addItem(String title, String notes, String imageUrl) async {
    if (title.isEmpty) {
      emit(AddItemFailure("Title cannot be empty"));
      return;
    }

    emit(AddItemLoading());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    if (userId == null) {
      emit(AddItemFailure("User not found. Please log in again."));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('Notes').doc(userId).collection('subNotes').add({
        'title': title,
        'imageurl': imageUrl,
        'note': notes,
      });

      emit(AddItemSuccess());
    } catch (e) {
      emit(AddItemFailure("Failed to add item: ${e.toString()}"));
    }
  }
}
