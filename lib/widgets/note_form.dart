import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notes_provider.dart';
import '../providers/auth_provider.dart';
import '../models/note.dart';

class NoteForm extends ConsumerStatefulWidget {
  final Note? note;
  const NoteForm({super.key, this.note});

  @override
  ConsumerState<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends ConsumerState<NoteForm> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Note' : 'New Note'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Title')),
          TextField(controller: _contentController, decoration: const InputDecoration(labelText: 'Content')),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final service = ref.read(authProvider);
            final title = _titleController.text.trim();
            final content = _contentController.text.trim();

            if (isEditing) {
              await service.updateNote(widget.note!.id, title, content);
            } else {
              await service.addNote(title, content);
            }

            // ignore: unused_result
            ref.refresh(notesProvider); // ✅ Fix unused_result

            if (context.mounted) {
              Navigator.pop(context); // ✅ Fix use_build_context_synchronously
            }
          },
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}