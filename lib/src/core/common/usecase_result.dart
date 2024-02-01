import 'package:freezed_annotation/freezed_annotation.dart';

part 'usecase_result.freezed.dart';

@freezed
class UsecaseResult<T> with _$UsecaseResult<T> {
  const factory UsecaseResult.success({@required T? data}) = Success<T>;

  const factory UsecaseResult.failure({@required String? error}) = Failure<T>;
}
