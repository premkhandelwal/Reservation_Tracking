import 'dart:convert';

class User {
  final String? userId;
  final String? emailId;
  final String? password;
  User({
    this.userId,
    this.emailId,
    this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'Sr_No': userId,
      'EmailId': emailId,
      'Password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: "U${map['Sr_No']}",
      emailId: map['EmailId'],
      password: map['Password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
