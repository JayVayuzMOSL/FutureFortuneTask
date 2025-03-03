import 'package:future_fortune_task/features/home/data/models/note_model.dart';
import 'package:future_fortune_task/features/home/domain/repositories/note_repository.dart';

class FetchNotesUseCase {
  final NoteRepository repository;
  FetchNotesUseCase(this.repository);
  Future<List<NoteModel>> call() async => repository.fetchNotes();
}