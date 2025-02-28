import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_fortune_task/features/home/presentation/bloc/add_item_state.dart';

class AddItemCubit extends Cubit<AddItemState> {
  AddItemCubit() : super(AddItemInitial());

  void addItem(String title, String notes) async {
    if (title.isEmpty) {
      emit(AddItemFailure("Title cannot be empty"));
      return;
    }

    emit(AddItemLoading());

    try {
      // Simulate adding item (replace with database or API call)
      await Future.delayed(Duration(seconds: 1));

      emit(AddItemSuccess());
    } catch (e) {
      emit(AddItemFailure("Failed to add item"));
    }
  }
}
