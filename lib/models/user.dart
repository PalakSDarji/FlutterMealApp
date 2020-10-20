import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User{
  String email;
  String password;
  DateTime expiryDate;

  @JsonKey(name: 'localId')
  String userId;
  @JsonKey(name: 'idToken')
  String token;
  @JsonKey(name: 'expiresIn')
  String expiresIn;

  User(this.email, this.password, this.expiryDate, this.userId, this.token,
      this.expiresIn);

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  String toString() {
    return 'User{email: $email, password: $password, expiryDate: $expiryDate, userId: $userId, token: $token, expiresIn: $expiresIn}';
  }
}