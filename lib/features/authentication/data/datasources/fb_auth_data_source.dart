import 'package:epaisa_todo_app/core/network/firestore_service.dart';
import 'package:epaisa_todo_app/features/authentication/data/models/fb_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:meta/meta.dart';

class FirebaseAuthDataSource {
  final auth.FirebaseAuth firebaseAuth;

  FirebaseAuthDataSource({@required this.firebaseAuth});

  Future<FbUserModel> signIn(String email, String password) async {
    auth.UserCredential user = (await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password));
    return FbUserModel(uid: user.user.uid, email: user.user.email);
  }

  Future<FbUserModel> createUser(String email, String password) async {
    auth.UserCredential user = (await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password));
    await FirestoreService.addUser(email, user.user.uid);
    return FbUserModel(uid: user.user.uid, email: user.user.email);
  }

  Future<FbUserModel> currentUser() async {
    return firebaseAuth.currentUser != null
        ? FbUserModel(
            uid: firebaseAuth.currentUser.uid,
            email: firebaseAuth.currentUser.email)
        : null;
  }

  Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

  Future<bool> isSignedIn() async {
    print(firebaseAuth.currentUser);
    return firebaseAuth.currentUser != null;
  }
}
