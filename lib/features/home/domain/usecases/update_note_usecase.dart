import 'package:future_fortune_task/features/home/data/models/note_model.dart';
import 'package:future_fortune_task/features/home/domain/repositories/note_repository.dart';

class UpdateNoteUseCase {
  final NoteRepository repository;
  UpdateNoteUseCase(this.repository);
  Future<void> call(NoteModel note) async => repository.updateNote(note);
}