class FollowersModel {
  String? username;
  List<Followers>? followers;

  FollowersModel({this.username, this.followers});

  FollowersModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    if (json['followers'] != null) {
      followers = <Followers>[];
      json['followers'].forEach((v) {
        followers!.add(new Followers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    if (this.followers != null) {
      data['followers'] = this.followers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Followers {
  String? profileImage;
  String? userName;
  String? userHandle;
  String? profileTagline;
  int? userFollowStatus;

  Followers(
      {this.profileImage,
        this.userName,
        this.userHandle,
        this.profileTagline,
        this.userFollowStatus});

  Followers.fromJson(Map<String, dynamic> json) {
    profileImage = json['profile_image'];
    userName = json['user_name'];
    userHandle = json['user_handle'];
    profileTagline = json['profile_tagline'];
    userFollowStatus = json['user_follow_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_image'] = this.profileImage;
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['profile_tagline'] = this.profileTagline;
    data['user_follow_status'] = this.userFollowStatus;
    return data;
  }
}
