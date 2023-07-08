class FollowsModel {
  String? username;
  List<Following>? following;

  FollowsModel({this.username, this.following});

  FollowsModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    if (json['following'] != null) {
      following = <Following>[];
      json['following'].forEach((v) {
        following!.add(new Following.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    if (this.following != null) {
      data['following'] = this.following!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Following {
  String? profileImage;
  String? userName;
  String? userHandle;
  String? profileTagline;
  int? userFollowStatus;
  bool? isLoggedIn;

  Following(
      {this.profileImage,
      this.userName,
      this.userHandle,
      this.profileTagline,
      this.userFollowStatus,
      this.isLoggedIn});

  Following.fromJson(Map<String, dynamic> json) {
    profileImage = json['profile_image'];
    userName = json['user_name'];
    userHandle = json['user_handle'];
    profileTagline = json['profile_tagline'];
    userFollowStatus = json['user_follow_status'];
    isLoggedIn = json['is_logged_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_image'] = this.profileImage;
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['profile_tagline'] = this.profileTagline;
    data['user_follow_status'] = this.userFollowStatus;
    data['is_logged_in'] = this.isLoggedIn;
    return data;
  }
}
