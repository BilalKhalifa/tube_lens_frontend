import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  // Grab the single instance of the Supabase Client we initialized in main.dart
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Get the currently logged-in user details (returns null if logged out)
  User? get currentUser => _supabase.auth.currentUser;

  // 2. Get the active session (holds the active login tokens)
  Session? get currentSession => _supabase.auth.currentSession;

  // 3. Listen to authentication changes in real-time (e.g. logging in, logging out)
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // 4. Register a new user with Email and Password
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // 5. Log in an existing user with Email and Password
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // 6. Sign Out (Wipes cached session token from local storage)
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }
}