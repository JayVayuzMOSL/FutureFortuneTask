import 'package:future_fortune_task/features/home/data/models/note_model.dart';
import 'package:future_fortune_task/features/home/domain/repositories/note_repository.dart';

class AddNoteUseCase {
  final NoteRepository repository;
  AddNoteUseCase(this.repository);
  Future<void> call(NoteModel note) async => repository.addNote(note);
}