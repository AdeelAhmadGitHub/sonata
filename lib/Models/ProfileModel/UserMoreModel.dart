class UserMoreModel {
  String? profileImage;
  String? userName;
  String? userHandle;
  int? noteId;
  String? noteImage;
  String? noteBody;
  int? channelsId;
  String? channelsName;
  String? noteTimeAgo;
  int? likeStatus;
  int? noteSavedStatus;
  int? noteRepliedStatus;
  int? noteRenotedStatus;
  int? totalNoteReply;
  int? totalNoteRepost;
  int? totalNoteLikes;

  UserMoreModel(
      {this.profileImage,
      this.userName,
      this.userHandle,
      this.noteId,
      this.noteImage,
      this.noteBody,
      this.channelsId,
      this.channelsName,
      this.noteTimeAgo,
      this.likeStatus,
      this.noteSavedStatus,
      this.noteRepliedStatus,
      this.noteRenotedStatus,
      this.totalNoteReply,
      this.totalNoteRepost,
      this.totalNoteLikes});

  UserMoreModel.fromJson(Map<String, dynamic> json) {
    profileImage = json['profile_image'];
    userName = json['user_name'];
    userHandle = json['user_handle'];
    noteId = json['note_id'];
    noteImage = json['note_image'];
    noteBody = json['note_body'];
    channelsId = json['channels_id'];
    channelsName = json['channels_name'];
    noteTimeAgo = json['note_time_ago'];
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
    data['profile_image'] = this.profileImage;
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['note_id'] = this.noteId;
    data['note_image'] = this.noteImage;
    data['note_body'] = this.noteBody;
    data['channels_id'] = this.channelsId;
    data['channels_name'] = this.channelsName;
    data['note_time_ago'] = this.noteTimeAgo;
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
