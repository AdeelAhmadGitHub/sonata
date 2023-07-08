class UserUsingSonataModel {
  List<JsonSideArray>? jsonSideArray;

  UserUsingSonataModel({this.jsonSideArray});

  UserUsingSonataModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      jsonSideArray = <JsonSideArray>[];
      json['data'].forEach((v) {
        jsonSideArray!.add(new JsonSideArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jsonSideArray != null) {
      data['data'] =
          this.jsonSideArray!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JsonSideArray {
  String? userName;
  String? userHandle;
  String? profileTagline;
  String? profileImage;
  int? userFollowStatus;
  bool? isFollowing;
  JsonSideArray(
      {this.userName,
      this.userHandle,
      this.profileTagline,
      this.profileImage,
      this.userFollowStatus,
      this.isFollowing});

  JsonSideArray.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    userHandle = json['user_handle'];
    profileTagline = json['profile_tagline'];
    profileImage = json['profile_image'];
    userFollowStatus = json['user_follow_status'];
    isFollowing = json['is_following'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['profile_tagline'] = this.profileTagline;
    data['profile_image'] = this.profileImage;
    data['user_follow_status'] = this.userFollowStatus;
    data['is_following'] = this.isFollowing;
    return data;
  }
}
