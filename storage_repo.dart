import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:learn_layout/locator.dart';
import '../models/user_models.dart';
import 'package:learn_layout/repository/auth_repo.dart';

class StorageRepo {
  FirebaseStorage _storage =
      FirebaseStorage.instanceFor(bucket: 'gs://dden-217ec.appspot.com');
  AuthRepo _authRepo = locator.get<AuthRepo>();

  Future<String> uploadFile(File file) async {
    UserModel user = await _authRepo.getUser();
    var userId = user.uid;
    var storageRef = _storage.ref().child("user/profile/$userId");
    var uploadTask = storageRef.putFile(file);
    var completedTask = await (await uploadTask).ref.getDownloadURL();
    // String downloadUrl = await completedTask.ref.getDownloadURL();
    // https://stackoverflow.com/questions/64880675/flutter-uploadtask-method-oncomplete-does-not-exists
    String downloadUrl = completedTask.toString();
    print("from storage_repo.dart download url ######## $downloadUrl");
    return downloadUrl;
  }

  Future<String> getUserProfileImage(String? uid) async {
    return await _storage.ref().child("user/profile/$uid").getDownloadURL();
  }

  // Future<String> getUserProfileImageDownloadUrl(String? uid) async {
  //   var storageRef = _storage.ref().child("user/profile/$uid");
  //   print("from storage repo ######## ${storageRef.getDownloadURL()}");
  //   return await storageRef.getDownloadURL();
  // }
}
