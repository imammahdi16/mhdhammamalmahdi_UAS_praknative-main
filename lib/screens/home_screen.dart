// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas1/providers/note_provider.dart';
import 'package:uas1/screens/add_note_screen.dart';
import 'package:uas1/models/note.dart'; // Tambahkan import ini

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    // Remove authProvider if AuthProvider doesn't exist
    // final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh notes if method exists in NoteProvider
              // noteProvider.refreshNotes();
            },
            tooltip: 'Refresh Notes',
          ),
          // Remove sign out button if AuthProvider doesn't exist
          /*
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _handleSignOut(authProvider);
            },
            tooltip: 'Sign Out',
          ),
          */
        ],
      ),
      body: noteProvider.notes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No notes yet',
                    style: TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first note',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: noteProvider.notes.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final note = noteProvider.notes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        note.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _navigateToEditNote(note),
                          tooltip: 'Edit Note',
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _handleDeleteNote(noteProvider, note),
                          tooltip: 'Delete Note',
                        ),
                      ],
                    ),
                    onTap: () => _showNoteDetails(note),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNote,
        backgroundColor: Colors.blue,
        tooltip: 'Add New Note',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _navigateToAddNote() async {
    if (!mounted) return;

    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const AddNoteScreen()),
    );

    // Refresh manual jika diperlukan (opsional karena Provider sudah auto-refresh)
    if (result == true && mounted) {
      // Bisa tambahkan refresh manual jika Provider tidak auto-update
      // Provider.of<NoteProvider>(context, listen: false).fetchNotes();

      // Atau tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Operation completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _navigateToEditNote(Note note) async {
    if (!mounted) return;

    // DEBUG: Uncomment line below for debugging
    // print('Navigating to edit note: ${note.title}');

    final _ = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => AddNoteScreen(note: note)),
    );

    // DEBUG: Uncomment line below for debugging
    // print('Returned from edit note screen with result: $result');

    // The HomeScreen will automatically update because it listens to NoteProvider
    // No need for manual refresh if Provider is working correctly
  }

  /*
  // Remove this method if AuthProvider doesn't exist
  Future<void> _handleSignOut(AuthProvider authProvider) async {
    try {
      await authProvider.signOut();
    } catch (e) {
      if (!mounted) return;
      // DEBUG: Uncomment line below for debugging
      // print('Sign out error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: $e')),
        );
      }
    }
  }
  */

  Future<void> _handleDeleteNote(NoteProvider noteProvider, Note note) async {
    if (!mounted) return;

    // DEBUG: Uncomment line below for debugging
    // print('Attempting to delete note: ${note.title}');

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted || confirm != true) return;

    try {
      await noteProvider.deleteNote(note.id);

      if (!mounted) return;
      // DEBUG: Uncomment line below for debugging
      // print('Note deleted successfully: ${note.title}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // DEBUG: Uncomment line below for debugging
      // print('Error deleting note: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting note: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showNoteDetails(Note note) {
    if (!mounted) return;

    // DEBUG: Uncomment line below for debugging
    // print('Showing note details: ${note.title}');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          note.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Text(note.content, style: const TextStyle(fontSize: 16)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToEditNote(note);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}
