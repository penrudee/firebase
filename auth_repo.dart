import 'package:firebase_auth/firebase_auth.dart';

//model
import '../models/user_models.dart';

class AuthRepo {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthRepo();

  // Future<void> signInWithEmailAndPassword(
  //     {required String email, required String password}) async {
  //   await _auth.signInWithEmailAndPassword(email: email, password: password);
  // }

  Future<UserModel> getUser() async {
    final firebaseUser = await _auth.currentUser;
    final uid = firebaseUser!.uid;
    final email = firebaseUser.email;
    final displayName = firebaseUser.displayName;
    return UserModel(uid, displayName: displayName, email: email);
  }

  Future<UserModel> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    var authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return UserModel(authResult.user?.uid,
        displayName: authResult.user?.displayName);
  }
}
