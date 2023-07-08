class ViewNotesModel {
  bool? firstThread;
  int? threadLength;
  String? profileImage;
  String? userName;
  String? userHandle;
  String? noteImage;
  String? noteBody;
  int? noteId;
  int? renoteId;
  String? channelName;
  int? channelId;
  String? noteTimeAgo;
  int? likeStatus;
  int? noteRepliedStatus;
  int? noteRenotedStatus;
  int? userFollowStatus;
  int? totalNoteLikes;
  int? totalNoteReply;
  int? totalNoteRepost;

  //List<JsonRenoteArray>? jsonRenoteArray;
  JsonRenoteArray? jsonRenoteArray;
  List<JsonReplyArray>? jsonReplyArray;

  ViewNotesModel(
      {this.firstThread,
      this.threadLength,
      this.profileImage,
      this.userName,
      this.userHandle,
      this.noteImage,
      this.noteBody,
      this.noteId,
      this.renoteId,
      this.channelName,
      this.channelId,
      this.noteTimeAgo,
      this.likeStatus,
      this.noteRepliedStatus,
      this.noteRenotedStatus,
      this.userFollowStatus,
      this.totalNoteLikes,
      this.totalNoteReply,
      this.totalNoteRepost,
      this.jsonRenoteArray,
      this.jsonReplyArray});

  ViewNotesModel.fromJson(Map<String, dynamic> json) {
    firstThread = json['first_thread'];
    threadLength = json['thread_length'];
    profileImage = json['profile_image'];
    userName = json['user_name'];
    userHandle = json['user_handle'];
    noteImage = json['note_image'];
    noteBody = json['note_body'];
    noteId = json['note_id'];
    renoteId = json['renote_id'];
    channelName = json['channel_name'];
    channelId = json['channel_id'];
    noteTimeAgo = json['note_time_ago'];
    likeStatus = json['like_status'];
    noteRepliedStatus = json['note_replied_status'];
    noteRenotedStatus = json['note_renoted_status'];
    userFollowStatus = json['user_follow_status'];
    totalNoteLikes = json['total_note_likes'];
    totalNoteReply = json['total_note_reply'];
    totalNoteRepost = json['total_note_repost'];
    // if (json['json_renote_array'] != null) {
    //   jsonRenoteArray = <JsonRenoteArray>[];
    //   json['json_renote_array'].forEach((v) {
    //     jsonRenoteArray!.add(new JsonRenoteArray.fromJson(v));
    //   });
    // }

    json['json_renote_array'] != null
        ? jsonRenoteArray = JsonRenoteArray.fromJson(json['json_renote_array'].isEmpty?{}:json['json_renote_array'])
        : null;
    if (json['json_reply_array'] != null) {
      jsonReplyArray = <JsonReplyArray>[];
      json['json_reply_array'].forEach((v) {
        jsonReplyArray!.add(new JsonReplyArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_thread'] = this.firstThread;
    data['thread_length'] = this.threadLength;
    data['profile_image'] = this.profileImage;
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['note_image'] = this.noteImage;
    data['note_body'] = this.noteBody;
    data['note_id'] = this.noteId;
    data['renote_id'] = this.renoteId;
    data['channel_name'] = this.channelName;
    data['channel_id'] = this.channelId;
    data['note_time_ago'] = this.noteTimeAgo;
    data['like_status'] = this.likeStatus;
    data['note_replied_status'] = this.noteRepliedStatus;
    data['note_renoted_status'] = this.noteRenotedStatus;
    data['user_follow_status'] = this.userFollowStatus;
    data['total_note_likes'] = this.totalNoteLikes;
    data['total_note_reply'] = this.totalNoteReply;
    data['total_note_repost'] = this.totalNoteRepost;
    // if (this.jsonRenoteArray != null) {
    //   data['json_renote_array'] =
    //       this.jsonRenoteArray!.map((v) => v.toJson()).toList();
    // }
    if (this.jsonRenoteArray != null) {
      data['json_renote_array'] = this.jsonRenoteArray!.toJson();
    }
    if (this.jsonReplyArray != null) {
      data['json_reply_array'] =
          this.jsonReplyArray!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JsonRenoteArray {
  String? renotedProfileImage;
  String? renotedUserName;
  String? renotedUserHandle;
  int? renotedId;
  String? renotedImage;
  String? renotedBody;
  int? renotedChannelId;
  String? renotedChannelName;

  JsonRenoteArray(
      {this.renotedProfileImage,
      this.renotedUserName,
      this.renotedUserHandle,
      this.renotedId,
      this.renotedImage,
      this.renotedBody,
      this.renotedChannelId,
      this.renotedChannelName});

  JsonRenoteArray.fromJson(Map<String, dynamic> json) {
    renotedProfileImage = json['renoted_profile_image'];
    renotedUserName = json['renoted_user_name'];
    renotedUserHandle = json['renoted_user_handle'];
    renotedId = json['renoted_id'];
    renotedImage = json['renoted_image'];
    renotedBody = json['renoted_body'];
    renotedChannelId = json['renoted_channel_id'];
    renotedChannelName = json['renoted_channel_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['renoted_profile_image'] = this.renotedProfileImage;
    data['renoted_user_name'] = this.renotedUserName;
    data['renoted_user_handle'] = this.renotedUserHandle;
    data['renoted_id'] = this.renotedId;
    data['renoted_image'] = this.renotedImage;
    data['renoted_body'] = this.renotedBody;
    data['renoted_channel_id'] = this.renotedChannelId;
    data['renoted_channel_name'] = this.renotedChannelName;
    return data;
  }
}

class JsonReplyArray {
  String? respondentName;
  String? respondentHandle;
  String? replyingTo;
  String? respondentProfileImage;
  String? respondentNoteImage;
  int? respondentNoteId;
  String? respondentNoteBody;
  int? respondentChannelId;
  String? respondentNoteTimeAgo;
  int? respondentTotalNoteLikes;
  int? respondentTotalNoteReply;
  int? respondentTotalNoteRepost;
  int? likeStatus;

  JsonReplyArray(
      {this.respondentName,
      this.respondentHandle,
      this.replyingTo,
      this.respondentProfileImage,
      this.respondentNoteImage,
      this.respondentNoteId,
      this.respondentNoteBody,
      this.respondentChannelId,
      this.respondentNoteTimeAgo,
      this.respondentTotalNoteLikes,
      this.respondentTotalNoteReply,
      this.respondentTotalNoteRepost,
      this.likeStatus});

  JsonReplyArray.fromJson(Map<String, dynamic> json) {
    respondentName = json['respondent_name'];
    respondentHandle = json['respondent_handle'];
    replyingTo = json['replying_to'];
    respondentProfileImage = json['respondent_profile_image'];
    respondentNoteImage = json['respondent_note_image'];
    respondentNoteId = json['respondent_note_id'];
    respondentNoteBody = json['respondent_note_body'];
    respondentChannelId = json['respondent_channel_id'];
    respondentNoteTimeAgo = json['respondent_note_time_ago'];
    respondentTotalNoteLikes = json['respondent_total_note_likes'];
    respondentTotalNoteReply = json['respondent_total_note_reply'];
    respondentTotalNoteRepost = json['respondent_total_note_repost'];
    likeStatus = json['like_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['respondent_name'] = this.respondentName;
    data['respondent_handle'] = this.respondentHandle;
    data['replying_to'] = this.replyingTo;
    data['respondent_profile_image'] = this.respondentProfileImage;
    data['respondent_note_image'] = this.respondentNoteImage;
    data['respondent_note_id'] = this.respondentNoteId;
    data['respondent_note_body'] = this.respondentNoteBody;
    data['respondent_channel_id'] = this.respondentChannelId;
    data['respondent_note_time_ago'] = this.respondentNoteTimeAgo;
    data['respondent_total_note_likes'] = this.respondentTotalNoteLikes;
    data['respondent_total_note_reply'] = this.respondentTotalNoteReply;
    data['respondent_total_note_repost'] = this.respondentTotalNoteRepost;
    data['like_status'] = this.likeStatus;
    return data;
  }
}
