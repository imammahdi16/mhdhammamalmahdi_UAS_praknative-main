// lib/providers/note_provider.dart
import 'package:flutter/material.dart';
import 'package:uas1/models/note.dart'; // Ganti 'uas1'
import 'package:uas1/services/firestore_service.dart'; // Ganti 'uas1'

class NoteProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Note> _notes = []; // Pastikan tipe List adalah Note

  List<Note> get notes => _notes;

  // Menginisialisasi stream catatan
  void listenToNotes() {
    // Pastikan metode ini ada
    _firestoreService.getNotes().listen((notes) {
      _notes = notes;
      notifyListeners();
    });
  }

  Future<void> addNote(Note note) async {
    // Argumennya adalah objek Note
    await _firestoreService.addNote(note);
  }

  Future<void> updateNote(Note note) async {
    // Argumennya adalah objek Note
    await _firestoreService.updateNote(note);
  }

  Future<void> deleteNote(String noteId) async {
    await _firestoreService.deleteNote(noteId);
  }
}
