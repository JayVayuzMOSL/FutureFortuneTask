import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:future_fortune_task/features/home/domain/usecases/logout_usecase.dart';
import 'package:future_fortune_task/features/home/data/models/note_model.dart';
import 'package:future_fortune_task/features/home/domain/usecases/add_note_usecase.dart';
import 'package:future_fortune_task/features/home/domain/usecases/delete_note_usecase.dart';
import 'package:future_fortune_task/features/home/domain/usecases/fetch_note_usecase.dart';
import 'package:future_fortune_task/features/home/domain/usecases/update_note_usecase.dart';
import 'package:future_fortune_task/features/home/presentation/cubit/note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  final AddNoteUseCase addNoteUseCase;
  final UpdateNoteUseCase updateNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;
  final FetchNotesUseCase fetchNotesUseCase;
  final LogoutUseCase logout;

  NoteCubit(this.addNoteUseCase, this.updateNoteUseCase, this.deleteNoteUseCase, this.fetchNotesUseCase, this.logout) : super(NoteInitial());

  void addNote(NoteModel note) async {
    emit(NoteLoading());
    try {
      await addNoteUseCase(note);
      emit(NoteSuccess());
    } catch (e) {
      emit(NoteFailure(e.toString()));
    }
  }

  void updateNote(NoteModel note) async {
    emit(NoteLoading());
    try {
      await updateNoteUseCase(note);
      emit(NoteSuccess());
    } catch (e) {
      emit(NoteFailure(e.toString()));
    }
  }

  void deleteNote(String noteId) async {
    emit(NoteLoading());
    try {
      await deleteNoteUseCase(noteId);
      emit(NoteSuccess());
    } catch (e) {
      emit(NoteFailure(e.toString()));
    }
  }

  void fetchNotes() async {
    emit(NoteLoading());
    try {
      final notes = await fetchNotesUseCase();
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteFailure(e.toString()));
    }
  }

  void searchNotes(String query) async{
    final notes = await fetchNotesUseCase();
    if (query.isEmpty) {
      emit(NoteLoaded(notes)); // Show all notes if search query is empty
    } else {
      final filteredNotes = notes
          .where((note) => note.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(NoteLoaded(filteredNotes));
    }
  }

  Future<void> logoutUser() async {
    await logout();
    emit(NoteLogoutSuccess());
  }
}
