class UserRenotesModel {
  bool? threadStart;
  int? threadLength;
  String? profileImage;
  String? userName;
  String? userHandle;
  String? noteImage;
  int? noteId;
  String? noteBody;
  int? channelsId;
  String? channelsName;
  String? renotedProfileImage;
  String? renotedUserName;
  String? renotedUserHandle;
  String? renotedImage;
  int? renotedId;
  String? renotedBody;
  int? renotedChannelId;
  String? renotedChannelName;
  String? noteTimeAgo;
  int? userFollowStatus;
  int? likeStatus;
  int? noteSavedStatus;
  int? noteRepliedStatus;
  int? noteRenotedStatus;
  int? totalNoteReply;
  int? totalNoteRepost;
  int? totalNoteLikes;

  UserRenotesModel(
      {this.threadStart,
      this.threadLength,
      this.profileImage,
      this.userName,
      this.userHandle,
      this.noteImage,
      this.noteId,
      this.noteBody,
      this.channelsId,
      this.channelsName,
      this.renotedProfileImage,
      this.renotedUserName,
      this.renotedUserHandle,
      this.renotedImage,
      this.renotedId,
      this.renotedBody,
      this.renotedChannelId,
      this.renotedChannelName,
      this.noteTimeAgo,
      this.userFollowStatus,
      this.likeStatus,
      this.noteSavedStatus,
      this.noteRepliedStatus,
      this.noteRenotedStatus,
      this.totalNoteReply,
      this.totalNoteRepost,
      this.totalNoteLikes});

  UserRenotesModel.fromJson(Map<String, dynamic> json) {
    threadStart = json['thread_start'];
    threadLength = json['thread_length'];
    profileImage = json['profile_image'];
    userName = json['user_name'];
    userHandle = json['user_handle'];
    noteImage = json['note_image'];
    noteId = json['note_id'];
    noteBody = json['note_body'];
    channelsId = json['channels_id'];
    channelsName = json['channels_name'];
    renotedProfileImage = json['renoted_profile_image'];
    renotedUserName = json['renoted_user_name'];
    renotedUserHandle = json['renoted_user_handle'];
    renotedImage = json['renoted_image'];
    renotedId = json['renoted_id'];
    renotedBody = json['renoted_body'];
    renotedChannelId = json['renoted_channel_id'];
    renotedChannelName = json['renoted_channel_name'];
    noteTimeAgo = json['note_time_ago'];
    userFollowStatus = json['user_follow_status'];
    likeStatus = json['like_status'];
    noteSavedStatus = json['note_saved_status'];
    noteRepliedStatus = json['note_replied_status'];
    noteRenotedStatus = json['note_renoted_status'];
    totalNoteReply = json['total_note_reply'];
    totalNoteRepost = json['total_note_repost'];
    totalNoteLikes = json['total_note_likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thread_start'] = this.threadStart;
    data['thread_length'] = this.threadLength;
    data['profile_image'] = this.profileImage;
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['note_image'] = this.noteImage;
    data['note_id'] = this.noteId;
    data['note_body'] = this.noteBody;
    data['channels_id'] = this.channelsId;
    data['channels_name'] = this.channelsName;
    data['renoted_profile_image'] = this.renotedProfileImage;
    data['renoted_user_name'] = this.renotedUserName;
    data['renoted_user_handle'] = this.renotedUserHandle;
    data['renoted_image'] = this.renotedImage;
    data['renoted_id'] = this.renotedId;
    data['renoted_body'] = this.renotedBody;
    data['renoted_channel_id'] = this.renotedChannelId;
    data['renoted_channel_name'] = this.renotedChannelName;
    data['note_time_ago'] = this.noteTimeAgo;
    data['user_follow_status'] = this.userFollowStatus;
    data['like_status'] = this.likeStatus;
    data['note_saved_status'] = this.noteSavedStatus;
    data['note_replied_status'] = this.noteRepliedStatus;
    data['note_renoted_status'] = this.noteRenotedStatus;
    data['total_note_reply'] = this.totalNoteReply;
    data['total_note_repost'] = this.totalNoteRepost;
    data['total_note_likes'] = this.totalNoteLikes;
    return data;
  }
}
