// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas1/models/note.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan ID pengguna saat ini
  String? get currentUserId => _auth.currentUser?.uid;

  // CREATE: Menambahkan catatan baru
  Future<void> addNote(Note note) async {
    // Argumennya adalah objek Note
    if (currentUserId == null) {
      throw Exception("User not logged in.");
    }
    await _db
        .collection('notes')
        .add(note.toFirestore()); // Memanggil toFirestore()
  }

  // READ: Mendapatkan stream catatan untuk pengguna saat ini
  Stream<List<Note>> getNotes() {
    if (currentUserId == null) {
      return Stream.value([]); // Jika tidak ada user, kembalikan stream kosong
    }
    return _db
        .collection('notes')
        .where('userId', isEqualTo: currentUserId) // Filter berdasarkan userId
        .orderBy('timestamp', descending: true) // Urutkan berdasarkan waktu
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Note.fromFirestore(doc),
              ) // Memanggil fromFirestore()
              .toList(),
        );
  }

  // UPDATE: Memperbarui catatan yang sudah ada
  Future<void> updateNote(Note note) async {
    // Argumennya adalah objek Note
    if (currentUserId == null) {
      throw Exception("User not logged in.");
    }
    await _db
        .collection('notes')
        .doc(note.id)
        .update(note.toFirestore()); // Memanggil toFirestore()
  }

  // DELETE: Menghapus catatan
  Future<void> deleteNote(String noteId) async {
    if (currentUserId == null) {
      throw Exception("User not logged in.");
    }
    await _db.collection('notes').doc(noteId).delete();
  }
}
