import 'package:future_fortune_task/features/home/data/models/note_model.dart';

abstract class NoteRepository {
  Future<void> addNote(NoteModel note);
  Future<void> updateNote(NoteModel note);
  Future<void> deleteNote(String noteId);
  Future<List<NoteModel>> fetchNotes();
}