import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:owpet/src/models/user.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? _user;

  // Register a new user
  Future<void> register(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      final userData = User(
        id: user!.uid,
        email: email,
        name: name,
        password: password,
        telephone: '',
        description: '',
        photo: '',
      );

      await _firestore.collection('users').doc(user.uid).set(userData.toJson());
      _user = userData;
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print(e.message);
      }
    } catch (e) {
      print(e);
    }
  }

  // Log in an existing user
  Future<void> login(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      final doc = await _firestore.collection('users').doc(user!.uid).get();
      _user = User.fromJson({'id': user.uid, ...doc.data() ?? {}});
    } on auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e.message);
      }
    } catch (e) {
      print(e);
    }
  }

  // Get user details by ID
  Future<User> getUser(String id) async {
    final doc = await _firestore.collection('users').doc(id).get();
    return User.fromJson({'id': id, ...doc.data() ?? {}});
  }

  // Update user details
  Future<void> updateUser(User user) async {
    final userData = user.toJson();
    userData.remove('id');
    final photoUrl = await uploadProfilePicture(user.id, user.photo);
    userData['photo'] = photoUrl;
    await _firestore.collection('users').doc(user.id).update(userData);
    _user = user;
  }

  // Upload profile picture
  Future<String> uploadProfilePicture(String id, String path) async {
    final ref = _storage.ref().child('users/$id/profile.jpg');
    final result = ref.putFile(File(path));
    final url = await result.snapshot.ref.getDownloadURL();    
    return url;
  }

  // Get the currently active user
  Future<User> getActiveUser() async {
    if (_user == null) {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        _user = User.fromJson({'id': user.uid, ...doc.data() ?? {}});
      }
    }
    return _user!;
  }

  // Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
  }
}
