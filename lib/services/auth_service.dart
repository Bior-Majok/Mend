import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'firebase_service.dart';

class AuthService {
  final FirebaseAuth? _auth =
      FirebaseService.isInitialized ? FirebaseAuth.instance : null;
  final FirebaseFirestore? _firestore =
      FirebaseService.isInitialized ? FirebaseFirestore.instance : null;

  // Mock users for offline testing
  final Map<String, UserModel> _mockUsers = {
    'amina.hassan@alustudent.com': UserModel(
      uid: 'user_amina_123',
      email: 'amina.hassan@alustudent.com',
      fullName: 'Amina Hassan',
      role: 'student',
      department: 'Computer Science',
      campus: 'Kigali, Rwanda',
    ),
    'estate.admin@alueducation.com': UserModel(
      uid: 'user_admin_999',
      email: 'estate.admin@alueducation.com',
      fullName: 'Campus Facilities Lead',
      role: 'staff',
      department: 'Operations & Facilities',
      campus: 'Kigali, Rwanda',
    ),
  };

  UserModel? _currentMockUser;
  final _mockUserStreamController = StreamController<UserModel?>.broadcast();

  AuthService() {
    _currentMockUser = _mockUsers['amina.hassan@alustudent.com'];
  }

  // Validate ALU email domain
  static bool isValidAluEmail(String email) {
    final lower = email.trim().toLowerCase();
    return lower.endsWith('@alustudent.com') ||
        lower.endsWith('@alueducation.com') ||
        lower.endsWith('@alu.edu');
  }

  Stream<UserModel?> get userStream {
    final auth = _auth;
    final firestore = _firestore;
    if (FirebaseService.isInitialized && auth != null && firestore != null) {
      return auth.authStateChanges().asyncMap((firebaseUser) async {
        if (firebaseUser == null) return null;
        try {
          final doc =
              await firestore.collection('users').doc(firebaseUser.uid).get();
          if (doc.exists && doc.data() != null) {
            return UserModel.fromMap(doc.data()!, doc.id);
          }
          return UserModel(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            fullName: firebaseUser.displayName ?? 'ALU Member',
            role: 'student',
          );
        } catch (e) {
          return null;
        }
      });
    } else {
      return _mockUserStreamController.stream;
    }
  }

  UserModel? get currentUser => _currentMockUser;

  Future<UserModel> signUp({
    required String email,
    required String password,
    required String fullName,
    required String role,
    String department = 'Computer Science',
    String campus = 'Kigali, Rwanda',
  }) async {
    final trimmedEmail = email.trim().toLowerCase();

    // Enforce ALU institutional email
    if (!isValidAluEmail(trimmedEmail)) {
      throw Exception(
        'Access Restricted: You must use a verified ALU email address (@alustudent.com or @alueducation.com).',
      );
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters long.');
    }

    final auth = _auth;
    final firestore = _firestore;
    if (FirebaseService.isInitialized && auth != null && firestore != null) {
      try {
        final credential = await auth.createUserWithEmailAndPassword(
          email: trimmedEmail,
          password: password,
        );
        final uid = credential.user!.uid;

        // Send verification email
        await credential.user?.sendEmailVerification();

        final newUser = UserModel(
          uid: uid,
          email: trimmedEmail,
          fullName: fullName,
          role: role,
          department: department,
          campus: campus,
        );

        await firestore.collection('users').doc(uid).set(newUser.toMap());
        return newUser;
      } on FirebaseAuthException catch (e) {
        throw Exception(e.message ?? 'Registration failed.');
      }
    } else {
      // Local fallback
      final uid = 'user_${DateTime.now().millisecondsSinceEpoch}';
      final newUser = UserModel(
        uid: uid,
        email: trimmedEmail,
        fullName: fullName,
        role: role,
        department: department,
        campus: campus,
      );
      _mockUsers[trimmedEmail] = newUser;
      _currentMockUser = newUser;
      _mockUserStreamController.add(newUser);
      return newUser;
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim().toLowerCase();

    if (!isValidAluEmail(trimmedEmail)) {
      throw Exception(
        'Only ALU community members with @alustudent.com or @alueducation.com emails may log in.',
      );
    }

    final auth = _auth;
    final firestore = _firestore;
    if (FirebaseService.isInitialized && auth != null && firestore != null) {
      try {
        final credential = await auth.signInWithEmailAndPassword(
          email: trimmedEmail,
          password: password,
        );
        final uid = credential.user!.uid;
        final doc = await firestore.collection('users').doc(uid).get();
        if (doc.exists && doc.data() != null) {
          return UserModel.fromMap(doc.data()!, doc.id);
        }
        return UserModel(
          uid: uid,
          email: trimmedEmail,
          fullName: credential.user?.displayName ?? 'ALU User',
          role: 'student',
        );
      } on FirebaseAuthException catch (e) {
        throw Exception(e.message ?? 'Authentication failed.');
      }
    } else {
      // Local fallback
      if (_mockUsers.containsKey(trimmedEmail)) {
        final user = _mockUsers[trimmedEmail]!;
        _currentMockUser = user;
        _mockUserStreamController.add(user);
        return user;
      } else {
        // Auto-create local user
        final isStaff = trimmedEmail.contains('staff') ||
            trimmedEmail.contains('admin') ||
            trimmedEmail.endsWith('@alueducation.com');
        final user = UserModel(
          uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
          email: trimmedEmail,
          fullName: trimmedEmail.split('@').first.replaceAll('.', ' ').toUpperCase(),
          role: isStaff ? 'staff' : 'student',
          department: isStaff ? 'Facilities & Security' : 'Software Engineering',
          campus: 'Kigali, Rwanda',
        );
        _mockUsers[trimmedEmail] = user;
        _currentMockUser = user;
        _mockUserStreamController.add(user);
        return user;
      }
    }
  }

  Future<void> signOut() async {
    final auth = _auth;
    if (FirebaseService.isInitialized && auth != null) {
      await auth.signOut();
    }
    _currentMockUser = null;
    _mockUserStreamController.add(null);
  }

  void switchUserForDemo(UserModel user) {
    _currentMockUser = user;
    _mockUserStreamController.add(user);
  }
}
