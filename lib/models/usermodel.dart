import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class UserModel {
  String userName;
  String email;
  String uid;
  String profilePic;
  bool isAuthenticated;
  UserModel({
    required this.userName,
    required this.email,
    required this.uid,
    required this.profilePic,
    required this.isAuthenticated,
  });

  UserModel copyWith({
    String? userName,
    String? email,
    String? uid,
    String? profilePic,
    bool? isAuthenticated,
  }) {
    return UserModel(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      profilePic: profilePic ?? this.profilePic,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userName': userName,
      'email': email,
      'uid': uid,
      'profilePic': profilePic,
      'isAuthenticated': isAuthenticated,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userName: map['userName'] as String,
      email: map['email'] as String,
      uid: map['uid'] as String,
      profilePic: map['profilePic'] as String,
      isAuthenticated: map['isAuthenticated'] as bool,
    );
  }
}
