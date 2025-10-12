import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/note.dart';

class SupabaseService {
  final client = Supabase.instance.client;

  // 🔐 Authentication
  Future<void> signUp(String email, String password) async {
    await client.auth.signUp(email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // 📄 Fetch notes for current user
  Future<List<Note>> fetchNotes() async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return [];

    final response = await client
        .from('notes')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    try {
      final data = response as List<dynamic>;
      return data.map((e) => Note.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error parsing notes: $e');
      return [];
    }
  }

  // ➕ Add new note
  Future<void> addNote(String title, String content) async {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    await client.from('notes').insert({
      'title': title,
      'content': content,
      'user_id': userId,
    });
  }

  // ✏️ Update existing note
  Future<void> updateNote(String id, String title, String content) async {
    await client
        .from('notes')
        .update({'title': title, 'content': content})
        .eq('id', id);
  }

  // 🗑️ Delete note
  Future<void> deleteNote(String id) async {
    await client.from('notes').delete().eq('id', id);
  }
  
  void debugPrint(String s) {}
}