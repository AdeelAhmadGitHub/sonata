class AuthModel {
  String? msg;

  AuthModel({this.msg});

  AuthModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['msg'] = msg;
    return data;
  }
}
