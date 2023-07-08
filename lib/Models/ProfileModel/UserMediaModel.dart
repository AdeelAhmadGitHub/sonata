class UserMediaModel {
  String? profileImage;
  String? userName;
  String? userHandle;
  String? noteImage;
  int? noteId;
  String? noteBody;
  int? channelsId;
  String? channelsName;
  String? noteTimeAgo;
  int? totalNoteRepost;
  int? totalNoteReply;
  int? totalNoteLikes;
  int? likeStatus;
  int? noteSavedStatus;
  int? noteRepliedStatus;
  int? noteRenotedStatus;
  String? renotedProfileImage;
  String? renotedUserName;
  String? renotedUserHandle;
  int? renotedId;
  String? renotedBody;
  int? renotedChannelId;
  String? renotedChannelName;

  UserMediaModel(
      {this.profileImage,
      this.userName,
      this.userHandle,
      this.noteImage,
      this.noteId,
      this.noteBody,
      this.channelsId,
      this.channelsName,
      this.noteTimeAgo,
      this.totalNoteRepost,
      this.totalNoteReply,
      this.totalNoteLikes,
      this.likeStatus,
      this.noteSavedStatus,
      this.noteRepliedStatus,
      this.noteRenotedStatus,
      this.renotedProfileImage,
      this.renotedUserName,
      this.renotedUserHandle,
      this.renotedId,
      this.renotedBody,
      this.renotedChannelId,
      this.renotedChannelName});

  UserMediaModel.fromJson(Map<String, dynamic> json) {
    profileImage = json['profile_image'];
    userName = json['user_name'];
    userHandle = json['user_handle'];
    noteImage = json['note_image'];
    noteId = json['note_id'];
    noteBody = json['note_body'];
    channelsId = json['channels_id'];
    channelsName = json['channels_name'];
    noteTimeAgo = json['note_time_ago'];
    totalNoteRepost = json['total_note_repost'];
    totalNoteReply = json['total_note_reply'];
    totalNoteLikes = json['total_note_likes'];
    likeStatus = json['like_status'];
    noteSavedStatus = json['note_saved_status'];
    noteRepliedStatus = json['note_replied_status'];
    noteRenotedStatus = json['note_renoted_status'];
    renotedProfileImage = json['renoted_profile_image'];
    renotedUserName = json['renoted_user_name'];
    renotedUserHandle = json['renoted_user_handle'];
    renotedId = json['renoted_id'];
    renotedBody = json['renoted_body'];
    renotedChannelId = json['renoted_channel_id'];
    renotedChannelName = json['renoted_channel_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_image'] = this.profileImage;
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['note_image'] = this.noteImage;
    data['note_id'] = this.noteId;
    data['note_body'] = this.noteBody;
    data['channels_id'] = this.channelsId;
    data['channels_name'] = this.channelsName;
    data['note_time_ago'] = this.noteTimeAgo;
    data['total_note_repost'] = this.totalNoteRepost;
    data['total_note_reply'] = this.totalNoteReply;
    data['total_note_likes'] = this.totalNoteLikes;
    data['like_status'] = this.likeStatus;
    data['note_saved_status'] = this.noteSavedStatus;
    data['note_replied_status'] = this.noteRepliedStatus;
    data['note_renoted_status'] = this.noteRenotedStatus;
    data['renoted_profile_image'] = this.renotedProfileImage;
    data['renoted_user_name'] = this.renotedUserName;
    data['renoted_user_handle'] = this.renotedUserHandle;
    data['renoted_id'] = this.renotedId;
    data['renoted_body'] = this.renotedBody;
    data['renoted_channel_id'] = this.renotedChannelId;
    data['renoted_channel_name'] = this.renotedChannelName;
    return data;
  }
}
