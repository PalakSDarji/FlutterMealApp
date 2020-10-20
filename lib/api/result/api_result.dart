import 'package:flutter/foundation.dart';
import 'package:flutter_meal_app/api/result/network_exceptions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_result.freezed.dart';

part 'api_result.g.dart';

@freezed
abstract class ApiResult<T> with _$ApiResult<T> {
  const factory ApiResult.success(
      {@required
      @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson)
          T data}) = Success<T>;

  const factory ApiResult.failure({@required NetworkExceptions error}) =
      Failure<T>;

  factory ApiResult.fromJson(Map<String, dynamic> json) =>
      _$ApiResultFromJson(json);
}

T _dataFromJson<T, S, U>(Map<String, dynamic> input, [S other1, U other2]) =>
    input['value'] as T;

Map<String, dynamic> _dataToJson<T, S, U>(T input, [S other1, U other2]) =>
    {'value': input};
