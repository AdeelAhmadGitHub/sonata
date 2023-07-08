class UserModel {
  String? userName;
  String? userHandle;
  String? profileImage;
  bool isFollowing; // add this line

  UserModel(
      {this.userName,
      this.userHandle,
      this.profileImage,
      this.isFollowing = false});
}
