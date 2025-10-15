import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/note_model.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final SupabaseService _supabase = SupabaseService();
  List<Note> notes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => isLoading = true);
    try {
      final data = await _supabase.fetchUserNotes();
      notes = data.map((json) => Note.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading notes: $e');
    }
    setState(() => isLoading = false);
  }

  Future<void> _createNote() async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();
    int selectedPriority = 1;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content')),
            DropdownButton<int>(
              value: selectedPriority,
              items: [1, 2, 3].map((p) => DropdownMenuItem(value: p, child: Text('Priority $p'))).toList(),
              onChanged: (val) => setState(() => selectedPriority = val ?? 1),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                final newNote = await _supabase.createNote(
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  priority: selectedPriority,
                );
                setState(() => notes.insert(0, Note.fromJson(newNote)));
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              } catch (e) {
                debugPrint('Create error: $e');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _updateNote(Note note) async {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);
    int selectedPriority = note.priority;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content')),
            DropdownButton<int>(
              value: selectedPriority,
              items: [1, 2, 3].map((p) => DropdownMenuItem(value: p, child: Text('Priority $p'))).toList(),
              onChanged: (val) => setState(() => selectedPriority = val ?? 1),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                final updated = await _supabase.updateNote(
                  noteId: note.id, // ✅ UUID as String
                  title: titleController.text.trim(),
                  content: contentController.text.trim(),
                  priority: selectedPriority,
                );
                final index = notes.indexWhere((n) => n.id == note.id);
                setState(() => notes[index] = Note.fromJson(updated));
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              } catch (e) {
                debugPrint('Update error: $e');
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteNote(String id) async {
    try {
      await _supabase.deleteNote(id);
      setState(() => notes.removeWhere((n) => n.id == id));
    } catch (e) {
      debugPrint('Delete error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(onPressed: _createNote, icon: const Icon(Icons.add)),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notes.isEmpty
              ? const Center(child: Text('No notes found'))
              : ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (_, index) {
                    final note = notes[index];
                    return ListTile(
                      title: Text(note.title),
                      subtitle: Text('Priority: ${note.priority}\n${note.content}'),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _updateNote(note);
                          } else if (value == 'delete') {
                            _deleteNote(note.id); // ✅ UUID as String
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(value: 'edit', child: Text('Edit')),
                          const PopupMenuItem(value: 'delete', child: Text('Delete')),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}