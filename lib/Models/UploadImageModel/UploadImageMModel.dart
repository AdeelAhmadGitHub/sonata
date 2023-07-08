class UploadImageModel {
  String? msg;
  String? profileImage;

  UploadImageModel({this.msg, this.profileImage});

  UploadImageModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['profile_image'] = this.profileImage;
    return data;
  }
}
