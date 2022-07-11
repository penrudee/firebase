class UserModel {
  String? uid;
  String? email;
  String? displayName;
  String? avatarUrl;

  UserModel(this.uid, {this.displayName, this.avatarUrl, this.email});
}
