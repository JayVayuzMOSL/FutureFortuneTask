import 'package:future_fortune_task/features/home/domain/repositories/note_repository.dart';

class DeleteNoteUseCase {
  final NoteRepository repository;
  DeleteNoteUseCase(this.repository);
  Future<void> call(String noteId) async => repository.deleteNote(noteId);
}