import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

// Cubit
class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeCubit() : super(HomeInitial());

  // Fetch items from Firestore
  Future<void> fetchItems() async {
    emit(HomeLoading());
    try {
      final snapshot = await _firestore.collection('items').get();
      final items = snapshot.docs.map((doc) => {"id": doc.id, ...doc.data()}).toList();
      emit(HomeLoaded(items));
    } catch (e) {
      emit(HomeError("Failed to load items"));
    }
  }

  // Add new item
  Future<void> addItem(String title, String imageUrl) async {
    try {
      await _firestore.collection('items').add({"title": title, "imageUrl": imageUrl});
      fetchItems(); // Refresh list
    } catch (e) {
      emit(HomeError("Failed to add item"));
    }
  }

  // Update item
  Future<void> updateItem(String id, String newTitle) async {
    try {
      await _firestore.collection('items').doc(id).update({"title": newTitle});
      fetchItems();
    } catch (e) {
      emit(HomeError("Failed to update item"));
    }
  }

  // Delete item
  Future<void> deleteItem(String id) async {
    try {
      await _firestore.collection('items').doc(id).delete();
      fetchItems();
    } catch (e) {
      emit(HomeError("Failed to delete item"));
    }
  }
}
