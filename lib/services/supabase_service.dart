import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;

  // 🔐 Authentication
  Future<void> signIn({required String email, required String password}) async {
    final response = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Sign up failed');
    }
  }

  bool isAuthenticated() {
    return supabase.auth.currentUser != null;
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  // 📝 Notes CRUD
  Future<Map<String, dynamic>> createNote({
    required String title,
    required String content,
    required int priority,
  }) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    final response = await supabase
        .from('notes')
        .insert({
          'user_id': userId,
          'title': title,
          'content': content,
          'priority': priority,
        })
        .select()
        .single();

    return response;
  }

  Future<Map<String, dynamic>> updateNote({
    required String noteId, // ✅ Changed from int to String
    required String title,
    required String content,
    required int priority,
  }) async {
    final response = await supabase
        .from('notes')
        .update({
          'title': title,
          'content': content,
          'priority': priority,
        })
        .eq('id', noteId) // ✅ UUID match
        .select()
        .single();

    return response;
  }

  Future<List<Map<String, dynamic>>> fetchUserNotes() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    final response = await supabase
        .from('notes')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return response;
  }

  Future<void> deleteNote(String id) async { // ✅ Changed from int to String
    await supabase.from('notes').delete().eq('id', id);
  }
}