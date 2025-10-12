import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_card.dart';
import '../widgets/note_form.dart';
import '../providers/auth_provider.dart';
import 'auth_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              final service = ref.read(authProvider);
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await service.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const AuthScreen()),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final notesAsync = ref.watch(notesProvider);
          return notesAsync.when(
            data: (notes) => ListView(
              children: notes.map((note) => NoteCard(note: note)).toList(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (_) => const NoteForm(),
        ),
      ),
    );
  }
}