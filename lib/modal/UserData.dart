class UserData {
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? photo;

  UserData({this.firstName, this.lastName, this.email, this.mobile, this.photo});

  Map<String, dynamic> toJson() => {'firstName': firstName, 'lastName': lastName, 'email': email, 'mobile': mobile, 'photo': photo};

  factory UserData.fromJson(Map<String, dynamic> json) =>
      UserData(firstName: json["firstName"], lastName: json["lastName"], email: json["email"], mobile: json["mobile"], photo: json["photo"]);
}
