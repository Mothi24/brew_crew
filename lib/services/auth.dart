
import 'dart:async';

import 'package:brew_crew/models/fb_user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FbUser? _userFromFirebase(User? user){
    return user != null ? FbUser(uid: user.uid) : null;
  }
  //Stream to monitor auth Change
  Stream<FbUser?> get userStream{
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  //Sign In Anonymously
  Future signInAnonymous() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User user = userCredential.user!;
      return _userFromFirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //Sign in with email & password
  Future<FbUser?> signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      return _userFromFirebase(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //Register with email & password
  Future<FbUser?> registerWithEmailAndPassword(String email, String password) async{
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      //Create a new database entry for the user
      DatabaseService(uid: user!.uid).updateUserData('0', 'New Crew Member', 100);

      return _userFromFirebase(user);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }

  //Sign out
  Future<void> signOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){
      print(e.toString());
      return;
    }
  }
}