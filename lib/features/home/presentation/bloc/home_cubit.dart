import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'home_state.dart';

// Cubit
class HomeCubit extends Cubit<HomeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  HomeCubit() : super(HomeInitial());

  // Fetch items from Firestore
  Future<void> fetchItems() async {
    emit(HomeLoading());
    try {
      // Retrieve userId from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      print('User ID: $userId');
      if (userId == null) {
        emit(HomeError("User ID not found"));
        return;
      }

      // Fetch notes from Firestore
      final snapshot = await _firestore
          .collection('Notes')
          .doc(userId)
          .collection('subNotes')
          .get();

      if (snapshot.docs.isEmpty) {
        emit(HomeLoaded([])); // No items found
        return;
      }

      // Convert documents into a list of maps
      final items = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();

      print('Fetched items: $items');
      emit(HomeLoaded(items));
    } catch (e) {
      print('Error fetching items: $e');
      emit(HomeError("Failed to load items: ${e.toString()}"));
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
