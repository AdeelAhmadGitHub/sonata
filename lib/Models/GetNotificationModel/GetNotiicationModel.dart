class GetNotificationModel {
  String? profileImage;
  String? notificationType;
  bool? isActive;
  String? notificationId;
  String? notePostedUserHandle;
  String? notificationUserName;
  String? noteId;
  String? notificationUserHandle;
  String? notificationTimeAgo;

  GetNotificationModel(
      {this.profileImage,
      this.notificationType,
      this.isActive,
      this.notificationId,
      this.notePostedUserHandle,
      this.notificationUserName,
      this.noteId,
      this.notificationUserHandle,
      this.notificationTimeAgo});

  GetNotificationModel.fromJson(Map<String, dynamic> json) {
    profileImage = json['profile_image']?.toString();
    notificationType = json['notification_type']?.toString();
    isActive = json['is_active'] as bool?;
    notificationId = json['notification_id']?.toString();
    notePostedUserHandle = json['note_posted_user_handle']?.toString();
    notificationUserName = json['notification_user_name']?.toString();
    noteId = json['note_id']?.toString();
    notificationUserHandle = json['notification_user_handle']?.toString();
    notificationTimeAgo = json['notification_time_ago']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_image'] = this.profileImage;
    data['notification_type'] = this.notificationType;
    data['is_active'] = this.isActive;
    data['notification_id'] = this.notificationId;
    data['note_posted_user_handle'] = this.notePostedUserHandle;
    data['notification_user_name'] = this.notificationUserName;
    data['note_id'] = this.noteId;
    data['notification_user_handle'] = this.notificationUserHandle;
    data['notification_time_ago'] = this.notificationTimeAgo;
    return data;
  }
}
