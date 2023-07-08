class UserData {
  String? msg;
  String? userName;
  String? userHandle;
  String? profileImage;
  String? accountStatus;
  String? remainingTime;
  dynamic token;

  UserData(
      {this.msg,
      this.userName,
      this.userHandle,
      this.profileImage,
      this.accountStatus,
      this.remainingTime,
      this.token});
  UserData.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    userName = json['user_name'];
    userHandle = json['user_handle'];
    profileImage = json['profile_image'];
    accountStatus = json['account_status'];
    remainingTime = json['remaining_time'];
    token = json['token'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['profile_image'] = this.profileImage;
    data['account_status'] = this.accountStatus;
    data['remaining_time'] = this.remainingTime;
    data['token'] = this.token;
    return data;
  }
}
