// lib/models/note.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String title;
  final String content;
  final String userId; // Untuk mengaitkan catatan dengan pengguna
  final Timestamp
  timestamp; // Menggunakan 'timestamp' seperti yang saya berikan

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.userId,
    required this.timestamp,
  });

  // Factory constructor untuk membuat objek Note dari Firestore DocumentSnapshot
  factory Note.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      userId: data['userId'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Mengubah objek Note menjadi Map untuk disimpan di Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'userId': userId,
      'timestamp': timestamp,
    };
  }
}
