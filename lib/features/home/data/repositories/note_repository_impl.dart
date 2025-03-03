import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:future_fortune_task/features/home/data/models/note_model.dart';
import 'package:future_fortune_task/features/home/domain/repositories/note_repository.dart';
import 'package:future_fortune_task/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NoteRepositoryImpl implements NoteRepository {
  final FirebaseFirestore _firestore;
  final SharedPreferences _prefs;

  NoteRepositoryImpl(this._firestore,this._prefs);
  @override
  Future<void> addNote(NoteModel note) async {
    String? userId = _prefs.getString('user_id');
    if (userId == null) throw Exception("User not found");

    CollectionReference subNotes = FirebaseFirestore.instance
        .collection('Notes')
        .doc(userId)
        .collection('subNotes');

    // Generate a new document reference
    DocumentReference newDoc = subNotes.doc();
    note = note.copyWith(id: newDoc.id);
    await _firestore.collection('Notes').doc(userId).collection('subNotes').doc(newDoc.id).set(note.toJson()).then((value){
      sendPushMessage().then((value){
        flutterLocalNotificationsPlugin.show(
          1,
          note.title,
          note.note,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      });
    });
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    String? userId = _prefs.getString('user_id');
    if (userId == null) throw Exception("User not found");

    await _firestore.collection('Notes').doc(userId).collection('subNotes').doc(note.id).update(note.toJson()).then((value){
      // i have showing local notification because api is not
      sendPushMessage().then((value){
        flutterLocalNotificationsPlugin.show(
          1,
          note.title,
          note.note,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      });
    });
  }

  @override
  Future<void> deleteNote(String noteId) async {
    String? userId = _prefs.getString('user_id');
    if (userId == null) throw Exception("User not found");

    await _firestore.collection('Notes').doc(userId).collection('subNotes').doc(noteId).delete();
  }

  @override
  Future<List<NoteModel>> fetchNotes() async {
    String? userId = _prefs.getString('user_id');
    if (userId == null) throw Exception("User not found");

    final snapshot = await _firestore.collection('Notes').doc(userId).collection('subNotes').get();
    return snapshot.docs.map((doc) => NoteModel.fromJson(doc.data())).toList();
  }

  Future<void> sendPushMessage() async {
    final _token = await FirebaseMessaging.instance.getToken();
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://futurefortune-backend.onrender.com/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  String constructFCMPayload(String? token) {
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging!!!',
        'count': '1',
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification was created via FCM!',
      },
    });
  }

}

