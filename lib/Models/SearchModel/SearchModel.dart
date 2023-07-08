class SearchModel {
  String? userName;
  String? userHandle;
  String? profileTagline;
  String? profileImage;

  SearchModel(
      {this.userName, this.userHandle, this.profileTagline, this.profileImage});

  SearchModel.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    userHandle = json['user_handle'];
    profileTagline = json['profile_tagline'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['profile_tagline'] = this.profileTagline;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
