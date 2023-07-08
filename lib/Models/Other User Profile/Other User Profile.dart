class OtherUserProfileModel {
  String? userName;
  String? userHandle;
  String? dateOfBirth;
  String? profileImage;
  String? coverImage;
  String? userEmail;
  String? profileLocation;
  String? address;
  String? profileWork;
  String? userProfileDescription;
  String? profileTagline;
  String? userCreationDate;
  int? totalFollower;
  int? totalFollowing;
  String? linkListName;
  int? followStatus;
  bool? autoFollowChannels;
  bool? followAllChannels;
  bool? userMute;
  bool? userBlock;
  String? linkListStatus;

  OtherUserProfileModel(
      {this.userName,
        this.userHandle,
        this.dateOfBirth,
        this.profileImage,
        this.coverImage,
        this.userEmail,
        this.profileLocation,
        this.address,
        this.profileWork,
        this.userProfileDescription,
        this.profileTagline,
        this.userCreationDate,
        this.totalFollower,
        this.totalFollowing,
        this.linkListName,
        this.followStatus,
        this.autoFollowChannels,
        this.followAllChannels,
        this.userMute,
        this.userBlock,
        this.linkListStatus,});

  OtherUserProfileModel.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    userHandle = json['user_handle'];
    dateOfBirth = json['date_of_birth'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    userEmail = json['user_email'];
    profileLocation = json['profile_location'];
    address = json['address'];
    profileWork = json['profile_work'];
    userProfileDescription = json['user_profile_description'];
    profileTagline = json['profile_tagline'];
    userCreationDate = json['user_creation_date'];
    totalFollower = json['total_follower'];
    totalFollowing = json['total_following'];
    linkListName = json['link_list_name'];
    followStatus = json['follow_status'];
    autoFollowChannels = json['auto_follow_channels'];
    followAllChannels = json['follow_all_channels'];
    userMute = json['user_mute'];
    userBlock = json['user_block'];
    linkListStatus = json['link_list_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['date_of_birth'] = this.dateOfBirth;
    data['profile_image'] = this.profileImage;
    data['cover_image'] = this.coverImage;
    data['user_email'] = this.userEmail;
    data['profile_location'] = this.profileLocation;
    data['address'] = this.address;
    data['profile_work'] = this.profileWork;
    data['user_profile_description'] = this.userProfileDescription;
    data['profile_tagline'] = this.profileTagline;
    data['user_creation_date'] = this.userCreationDate;
    data['total_follower'] = this.totalFollower;
    data['total_following'] = this.totalFollowing;
    data['link_list_name'] = this.linkListName;
    data['follow_status'] = this.followStatus;
    data['auto_follow_channels'] = this.autoFollowChannels;
    data['follow_all_channels'] = this.followAllChannels;
    data['user_mute'] = this.userMute;
    data['user_block'] = this.userBlock;
    data['link_list_status'] = this.linkListStatus;
    return data;
  }
}

