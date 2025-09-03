import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthState extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;
  Stream<User?> get changes => _auth.authStateChanges();

  AuthState() {
    changes.listen((_) => notifyListeners());
  }

  Future<void> signOut() async => _auth.signOut();

  // Email / Password
  Future<UserCredential> signInWithEmail(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUpWithEmail(String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    // Send verification email (optional but recommended)
    await cred.user?.sendEmailVerification();
    return cred;
  }

  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> resendVerificationEmail() async {
    final u = _auth.currentUser;
    if (u != null && !u.emailVerified) {
      await u.sendEmailVerification();
    }
  }

  // Refresh user from server (needed to read updated emailVerified)
  Future<User?> reloadUser() async {
    final u = _auth.currentUser;
    await u?.reload();
    return _auth.currentUser;
  }

  // Google Sign-In
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      return _auth.signInWithPopup(googleProvider);
    } else {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) throw Exception('Google sign-in aborted');
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      return _auth.signInWithCredential(credential);
    }
  }
}
