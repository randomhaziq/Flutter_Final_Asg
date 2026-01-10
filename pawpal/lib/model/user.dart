class User {
  String? userId;
  String? userName;
  String? userEmail;
  String? userPassword;
  String? userPhone;
  String? userRegDate;

  String? profileImage;

  User({
    this.userId,
    this.userName,
    this.userEmail,
    this.userPassword,
    this.userPhone,
    this.userRegDate,
    this.profileImage,  
  });

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['name'];
    userEmail = json['email'];
    userPassword = json['password'];
    userPhone = json['phone'];
    userRegDate = json['reg_date'];
    profileImage = json['profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = userName;
    data['email'] = userEmail;
    data['password'] = userPassword;
    data['phone'] = userPhone;
    data['reg_date'] = userRegDate;
    data['profile_image'] = profileImage;
    return data;
  }
}
