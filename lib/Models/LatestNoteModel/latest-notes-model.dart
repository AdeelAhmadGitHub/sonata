class LatestNotesModel {
  String? profileImage;
  String? userName;
  String? userHandle;
  dynamic noteId;
  String? noteBody;

  LatestNotesModel(
      {this.profileImage,
      this.userName,
      this.userHandle,
      this.noteId,
      this.noteBody});

  LatestNotesModel.fromJson(Map<String, dynamic> json) {
    profileImage = json['profile_image'];
    userName = json['user_name'];
    userHandle = json['user_handle'];
    noteId = json['note_id'];
    noteBody = json['note_body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_image'] = this.profileImage;
    data['user_name'] = this.userName;
    data['user_handle'] = this.userHandle;
    data['note_id'] = this.noteId;
    data['note_body'] = this.noteBody;
    return data;
  }
}
