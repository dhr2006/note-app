import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import '../providers/auth_provider.dart';
import '../providers/notes_provider.dart';
import 'note_form.dart';

class NoteCard extends ConsumerWidget {
  final Note note;
  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(authProvider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(note.title),
        subtitle: Text(note.content),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => NoteForm(note: note),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                await service.deleteNote(note.id);
                // ignore: unused_result
                ref.refresh(notesProvider); // ✅ Warning-free refresh
              },
            ),
          ],
        ),
      ),
    );
  }
}