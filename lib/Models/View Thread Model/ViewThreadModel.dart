class ViewThreadModel {
  String? profileImage;
  String? userName;
  String? userHandle;
  int? channelsId;
  String? channelsName;
  String? noteTimeAgo;
  int? threadSavedStatus;
  int? userFollowStatus;
  List<JsonThreadArray>? jsonThreadArray;

  ViewThreadModel(
      {this.profileImage,
      this.userName,
      this.userHandle,
      this.channelsId,
      this.channelsName,
      this.noteTimeAgo,
      this.threadSavedStatus,
      this.userFollowStatus,
      this.jsonThreadArray});

  ViewThreadModel.fromJson(Map<String, dynamic> json) {
    profileImage = json['profile_image'];
    userName = json['user_name'];
    userHandle = json['user_handle'];
    channelsId = json['channels_id'];
    channelsName = json['channels_name'];
    noteTimeAgo = json['note_time_ago'];
    threadSavedStatus = json['thread_saved_status'];
    userFollowStatus = json['user_follow_status'];
    if (json['json_thread_array'] != null) {
      jsonThreadArray = <JsonThreadArray>[];
      json['json_thread_array'].forEach((v) {
        jsonThreadArray!.add(new JsonThreadArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_image'] = this.profileImage;
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['channels_id'] = this.channelsId;
    data['channels_name'] = this.channelsName;
    data['note_time_ago'] = this.noteTimeAgo;
    data['thread_saved_status'] = this.threadSavedStatus;
    data['user_follow_status'] = this.userFollowStatus;
    if (this.jsonThreadArray != null) {
      data['json_thread_array'] =
          this.jsonThreadArray!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JsonThreadArray {
  String? noteImage;
  int? noteId;
  String? noteBody;
  int? totalNoteReply;
  int? totalNoteRepost;
  int? totalNoteLikes;
  int? totalInteractions;
  int? likeStatus;

  JsonThreadArray(
      {this.noteImage,
      this.noteId,
      this.noteBody,
      this.totalNoteReply,
      this.totalNoteRepost,
      this.totalNoteLikes,
      this.totalInteractions,
      this.likeStatus});

  JsonThreadArray.fromJson(Map<String, dynamic> json) {
    noteImage = json['note_image'];
    noteId = json['note_id'];
    noteBody = json['note_body'];
    totalNoteReply = json['total_note_reply'];
    totalNoteRepost = json['total_note_repost'];
    totalNoteLikes = json['total_note_likes'];
    totalInteractions = json['total_interactions'];
    likeStatus = json['like_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['note_image'] = this.noteImage;
    data['note_id'] = this.noteId;
    data['note_body'] = this.noteBody;
    data['total_note_reply'] = this.totalNoteReply;
    data['total_note_repost'] = this.totalNoteRepost;
    data['total_note_likes'] = this.totalNoteLikes;
    data['total_interactions'] = this.totalInteractions;
    data['like_status'] = this.likeStatus;
    return data;
  }
}
