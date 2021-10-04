
class User {
  final String? userId;
  final String? userName;
  final String? emailId;
  final String? password;
  User({
    this.userId,
    this.userName,
    this.emailId,
    this.password,
  });



  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: "U${map['Sr_No']}",
      userName: map['Name'],
      emailId: map['EmailId'],
      password: map['Password'],
    );
  }


}
