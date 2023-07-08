class SavedNoteModel {
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
  String? noteTimeAgo;
  int? totalNoteReply;
  int? totalNoteRepost;
  int? totalNoteLikes;
  int? userFollowStatus;
  int? noteRepliedStatus;
  int? noteRenotedStatus;
  int? likeStatus;
  int? noteSavedStatus;
  String? renotedProfileImage;
  String? renoteUserName;
  String? renoteUserHandle;
  String? renotedImage;
  int? renoteId;
  String? renoteBody;
  int? renoteChannelId;
  String? renoteChannelName;

  SavedNoteModel(
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
      this.noteTimeAgo,
      this.totalNoteReply,
      this.totalNoteRepost,
      this.totalNoteLikes,
      this.userFollowStatus,
      this.likeStatus,
      this.noteRepliedStatus,
      this.noteRenotedStatus,
      this.noteSavedStatus,
      this.renotedProfileImage,
      this.renoteUserName,
      this.renoteUserHandle,
      this.renotedImage,
      this.renoteId,
      this.renoteBody,
      this.renoteChannelId,
      this.renoteChannelName});

  SavedNoteModel.fromJson(Map<String, dynamic> json) {
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
    noteTimeAgo = json['note_time_ago'];
    totalNoteReply = json['total_note_reply'];
    totalNoteRepost = json['total_note_repost'];
    totalNoteLikes = json['total_note_likes'];
    userFollowStatus = json['user_follow_status'];
    noteRepliedStatus = json['note_replied_status'];
    noteRenotedStatus = json['note_renoted_status'];
    likeStatus = json['like_status'];
    noteSavedStatus = json['note_saved_status'];
    renotedProfileImage = json['renoted_profile_image'];
    renoteUserName = json['renote_user_name'];
    renoteUserHandle = json['renote_user_handle'];
    renotedImage = json['renoted_image'];
    renoteId = json['renote_id'];
    renoteBody = json['renote_body'];
    renoteChannelId = json['renote_channel_id'];
    renoteChannelName = json['renote_channel_name'];
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
    data['note_time_ago'] = this.noteTimeAgo;
    data['total_note_reply'] = this.totalNoteReply;
    data['total_note_repost'] = this.totalNoteRepost;
    data['total_note_likes'] = this.totalNoteLikes;
    data['user_follow_status'] = this.userFollowStatus;
    data['like_status'] = this.likeStatus;
    data['note_replied_status'] = this.noteRepliedStatus;
    data['note_renoted_status'] = this.noteRenotedStatus;
    data['note_saved_status'] = this.noteSavedStatus;
    data['renoted_profile_image'] = this.renotedProfileImage;
    data['renote_user_name'] = this.renoteUserName;
    data['renote_user_handle'] = this.renoteUserHandle;
    data['renoted_image'] = this.renotedImage;
    data['renote_id'] = this.renoteId;
    data['renote_body'] = this.renoteBody;
    data['renote_channel_id'] = this.renoteChannelId;
    data['renote_channel_name'] = this.renoteChannelName;
    return data;
  }
}
