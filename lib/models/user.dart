import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User{
  String userId;
  String email;
  String password;
  String token;
  DateTime expiryDate;

  User(this.userId, this.email, this.password, this.token, this.expiryDate);

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}