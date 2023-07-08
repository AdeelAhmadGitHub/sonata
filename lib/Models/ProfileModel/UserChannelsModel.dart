class UserChannelsModel {
  List<JsonChannelsArray>? jsonChannelsArray;

  UserChannelsModel({this.jsonChannelsArray});

  UserChannelsModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      jsonChannelsArray = <JsonChannelsArray>[];
      json['data'].forEach((v) {
        jsonChannelsArray!.add(new JsonChannelsArray.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jsonChannelsArray != null) {
      data['data'] =
          this.jsonChannelsArray!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JsonChannelsArray {
  bool? defaultChannel;
  String? channelImage;
  int? channelId;
  String? chanelName;
  String? channelVisibility;
  String? channelCreateDate;
  int? totalNotesInChannel;
  int? totalRenotesInChannel;
  int? totalNoteReplyInChannel;
  int? totalLikesInChannel;
  int? totalChannelFollower;
  int? followStatus;

  JsonChannelsArray(
      {this.defaultChannel,
      this.channelImage,
      this.channelId,
      this.chanelName,
      this.channelVisibility,
      this.channelCreateDate,
      this.totalNotesInChannel,
      this.totalRenotesInChannel,
      this.totalNoteReplyInChannel,
      this.totalLikesInChannel,
      this.totalChannelFollower,
        this.followStatus,});

  JsonChannelsArray.fromJson(Map<String, dynamic> json) {
    defaultChannel = json['default_channel'];
    channelImage = json['channel_image'];
    channelId = json['channel_id'];
    chanelName = json['chanel_name'];
    channelVisibility = json['channel_visibility'];
    channelCreateDate = json['channel_create_date'];
    totalNotesInChannel = json['total_notes_in_channel'];
    totalRenotesInChannel = json['total_renotes_in_channel'];
    totalNoteReplyInChannel = json['total_note_reply_in_channel'];
    totalLikesInChannel = json['total_likes_in_channel'];
    totalChannelFollower = json['total_channel_follower'];
    followStatus = json['follow_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['default_channel'] = this.defaultChannel;
    data['channel_image'] = this.channelImage;
    data['channel_id'] = this.channelId;
    data['chanel_name'] = this.chanelName;
    data['channel_visibility'] = this.channelVisibility;
    data['channel_create_date'] = this.channelCreateDate;
    data['total_notes_in_channel'] = this.totalNotesInChannel;
    data['total_renotes_in_channel'] = this.totalRenotesInChannel;
    data['total_note_reply_in_channel'] = this.totalNoteReplyInChannel;
    data['total_likes_in_channel'] = this.totalLikesInChannel;
    data['total_channel_follower'] = this.totalChannelFollower;
    data['follow_status'] = this.followStatus;
    return data;
  }
}
