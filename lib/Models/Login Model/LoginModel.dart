class LoginModel {
  String? msg;
  String? userName;
  String? userHandle;
  String? profileImage;
  bool? deactivateStatus;
  String? token;

  LoginModel(
      {this.msg,
      this.userName,
      this.userHandle,
      this.profileImage,
      this.deactivateStatus,
      this.token});

  LoginModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    userName = json['user_name'];
    userHandle = json['user_handle'];
    profileImage = json['profile_image'];
    deactivateStatus = json['deactivate_status'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['profile_image'] = this.profileImage;
    data['deactivate_status'] = this.deactivateStatus;
    data['token'] = this.token;
    return data;
  }
}
