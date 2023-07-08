class ThreadModel {
  String? channelId;
  String? threadBody;
  String? threadImage;

  ThreadModel({this.channelId, this.threadBody, this.threadImage});

  ThreadModel.fromJson(Map<String, dynamic> json) {
    channelId = json['channel_id'];
    threadBody = json['thread_body'];
    threadImage = json['thread_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel_id'] = this.channelId;
    data['thread_body'] = this.threadBody;
    data['thread_image'] = this.threadImage;
    return data;
  }
}
