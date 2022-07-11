//locator
import 'dart:io';

import 'package:learn_layout/locator.dart';
import 'package:learn_layout/repository/storage_repo.dart';
//user model
import '../models/user_models.dart';

//auth_repo
import '../repository/auth_repo.dart';

class UserController {
  late UserModel _currentUser;
  late AuthRepo _authRepo = locator.get<AuthRepo>();
  late StorageRepo _storageRepo = locator.get<StorageRepo>();
  late Future init;

  UserController() {
    init = initUser();
  }

  Future<UserModel> initUser() async {
    _currentUser = await _authRepo.getUser();

    return _currentUser;
  }

  UserModel get currentUser => _currentUser;

  Future<void> uploadProfilePicture(File image) async {
    _currentUser.avatarUrl = await _storageRepo.uploadFile(image);
  }

  Future<String> getDownloadUrl() async {
    return await _storageRepo.getUserProfileImage(currentUser.uid);
  }

  Future<void> getDownloadUrlVoid() async {
    _currentUser.avatarUrl = await getDownloadUrl();
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    _authRepo.signInWithEmailAndPassword(email: email, password: password);
    _currentUser = await _authRepo.signInWithEmailAndPassword(
        email: email, password: password);

    _currentUser.avatarUrl = await getDownloadUrl();
  }
}
