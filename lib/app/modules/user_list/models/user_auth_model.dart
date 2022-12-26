class UserAuth {
  int? uid;
  UserContext? userContext;
  int? companyId;
  String? accessToken;
  int? expiresIn;
  String? refreshToken;
  int? refreshExpiresIn;

  UserAuth(
      {this.uid,
        this.userContext,
        this.companyId,
        this.accessToken,
        this.expiresIn,
        this.refreshToken,
        this.refreshExpiresIn});

  UserAuth.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    userContext = json['user_context'] != null
        ? UserContext.fromJson(json['user_context'])
        : null;
    companyId = json['company_id'];
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
    refreshExpiresIn = json['refresh_expires_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    if (userContext != null) {
      data['user_context'] = userContext!.toJson();
    }
    data['company_id'] = companyId;
    data['access_token'] = accessToken;
    data['expires_in'] = expiresIn;
    data['refresh_token'] = refreshToken;
    data['refresh_expires_in'] = refreshExpiresIn;
    return data;
  }
}

class UserContext {
  String? lang;
  String? tz;
  int? uid;

  UserContext({this.lang, this.tz, this.uid});

  UserContext.fromJson(Map<String, dynamic> json) {
    lang = json['lang'];
    tz = json['tz'];
    uid = json['uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lang'] = lang;
    data['tz'] = tz;
    data['uid'] = uid;
    return data;
  }
}
