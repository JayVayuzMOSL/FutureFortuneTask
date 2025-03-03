
// User Entity
class UserModel {
  final String uid;
  final String email;
  final String? password;

  UserModel({required this.uid, required this.email, this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      password: json['password']??''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'password': password??'',
    };
  }
}