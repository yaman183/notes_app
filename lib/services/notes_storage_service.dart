import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note_model.dart';

class NotesStorageService {
  static const String _key = 'notes';

  Future<List<NoteModel>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) return [];

    final List decoded = jsonDecode(data);
    return decoded.map((e) => NoteModel.fromJson(e)).toList();
  }

  Future<void> saveNotes(List<NoteModel> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(notes.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }
}