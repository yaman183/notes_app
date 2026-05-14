import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/note_model.dart';
import '../services/notes_storage_service.dart';

final notesProvider =
    StateNotifierProvider<NotesNotifier, AsyncValue<List<NoteModel>>>(
  (ref) => NotesNotifier(),
);

class NotesNotifier extends StateNotifier<AsyncValue<List<NoteModel>>> {
  NotesNotifier() : super(const AsyncLoading()) {
    loadNotes();
  }

  final NotesStorageService _service = NotesStorageService();

  Future<void> loadNotes() async {
    try {
      state = const AsyncLoading();
      final notes = await _service.getNotes();
      final activeNotes = notes.where((note) => !note.isDeleted).toList();
      state = AsyncData(activeNotes);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> addNote(NoteModel note) async {
    final current = state.value ?? [];
    final updated = [note, ...current];
    state = AsyncData(updated);
    await _service.saveNotes(updated);
  }

  Future<void> updateNote(NoteModel note) async {
    final current = state.value ?? [];

    final updated = current.map((item) {
      return item.id == note.id ? note : item;
    }).toList();

    state = AsyncData(updated);
    await _service.saveNotes(updated);
  }

  Future<void> deleteNote(String id) async {
    final current = state.value ?? [];
    final updated = current.where((note) => note.id != id).toList();

    state = AsyncData(updated);
    await _service.saveNotes(updated);
  }
}