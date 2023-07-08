class UserNotesModel {
  String? userId;
  String? noteId;
  String? userName;
  String? userHandle;
  Null? userProfile;
  String? noteBody;
  String? channelId;
  String? channelName;
  String? noteTimeAgo;
  int? totalNoteReply;
  int? totalNoteRepost;
  int? totalNoteLikes;

  UserNotesModel(
      {this.userId,
      this.noteId,
      this.userName,
      this.userHandle,
      this.userProfile,
      this.noteBody,
      this.channelId,
      this.channelName,
      this.noteTimeAgo,
      this.totalNoteReply,
      this.totalNoteRepost,
      this.totalNoteLikes});

  UserNotesModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    noteId = json['note_id'];
    userName = json['user_name'];
    userHandle = json['user_handle'];
    userProfile = json['user_profile'];
    noteBody = json['note_body'];
    channelId = json['channel_id'];
    channelName = json['channel_name'];
    noteTimeAgo = json['note_time_ago'];
    totalNoteReply = json['total_note_reply'];
    totalNoteRepost = json['total_note_repost'];
    totalNoteLikes = json['total_note_likes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['note_id'] = this.noteId;
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['user_profile'] = this.userProfile;
    data['note_body'] = this.noteBody;
    data['channel_id'] = this.channelId;
    data['channel_name'] = this.channelName;
    data['note_time_ago'] = this.noteTimeAgo;
    data['total_note_reply'] = this.totalNoteReply;
    data['total_note_repost'] = this.totalNoteRepost;
    data['total_note_likes'] = this.totalNoteLikes;
    return data;
  }
}
