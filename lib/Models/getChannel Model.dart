class GetChannelMode {
  int? channelId;
  String? chanelName;

  GetChannelMode({this.channelId, this.chanelName});

  GetChannelMode.fromJson(Map<String, dynamic> json) {
    channelId = json['channel_id'];
    chanelName = json['chanel_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['channel_id'] = this.channelId;
    data['chanel_name'] = this.chanelName;
    return data;
  }
}
