// lib/screens/add_note_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas1/models/note.dart';
import 'package:uas1/providers/note_provider.dart';
import 'package:uas1/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas1/screens/home_screen.dart';

class AddNoteScreen extends StatefulWidget {
  final Note? note;

  const AddNoteScreen({super.key, this.note});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false; // Tambahkan loading state

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }

    // DEBUG: Uncomment line below for debugging
    // print('AddNoteScreen initialized. Edit mode: ${widget.note != null}');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  // Tambahkan method untuk handle navigation
  void navigateBack({bool success = false}) {
    if (!mounted) return;
    Navigator.pop(context, success);
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      // DEBUG: Uncomment line below for debugging
      // print('Form validation passed. Saving note...');

      setState(() {
        _isLoading = true;
      });

      try {
        final noteProvider = Provider.of<NoteProvider>(context, listen: false);
        final userId = _firestoreService.currentUserId;

        if (userId == null) {
          if (!mounted) return;

          // DEBUG: Uncomment line below for debugging
          // print('Error: User not logged in');

          //Gunakan navigasi yang konsisten
          navigateBack(success: true);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: User not logged in.')),
          );
          return;
        }

        if (widget.note == null) {
          // Mode Create
          // DEBUG: Uncomment line below for debugging
          // print('Creating new note...');

          final newNote = Note(
            id: '',
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
            userId: userId,
            timestamp: Timestamp.now(),
          );

          await noteProvider.addNote(newNote);

          if (!mounted) return;

          // DEBUG: Uncomment line below for debugging
          // print('Note created successfully');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Note added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Mode Update
          // DEBUG: Uncomment line below for debugging
          // print('Updating existing note...');

          final updatedNote = Note(
            id: widget.note!.id,
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
            userId: userId,
            timestamp: Timestamp.now(),
          );

          await noteProvider.updateNote(updatedNote);

          if (!mounted) return;

          // DEBUG: Uncomment line below for debugging
          // print('Note updated successfully');

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Note updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        if (!mounted) return;

        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      // DEBUG: Uncomment line below for debugging
      // print('Form validation failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add New Note' : 'Edit Note'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter note title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        hintText: 'Write your note here...',
                        alignLabelWithHint: true,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Content cannot be empty';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveNote,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              widget.note == null ? 'Save Note' : 'Update Note',
                              style: const TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
