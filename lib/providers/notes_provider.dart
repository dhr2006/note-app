import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/note.dart';
import 'supabase_service_provider.dart';

final notesProvider = FutureProvider<List<Note>>((ref) async {
  final service = ref.read(supabaseServiceProvider);
  return service.fetchNotes();
});