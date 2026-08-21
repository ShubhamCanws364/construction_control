// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataResponse<TModel> _$DataResponseFromJson<TModel>(
  Map<String, dynamic> json,
  TModel Function(Object? json) fromJsonTModel,
) =>
    DataResponse<TModel>(
      isSuccess: json['isSuccess'] as bool?,
      error: json['error'] as String?,
      message: json['message'] as String?,
      data: _$nullableGenericFromJson(json['data'], fromJsonTModel),
      code: (json['code'] as num?)?.toInt(),
      apiStatus: json['apiStatus'] as bool?,
      mainData: _$nullableGenericFromJson(json['main_data'], fromJsonTModel),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$DataResponseToJson<TModel>(
  DataResponse<TModel> instance,
  Object? Function(TModel value) toJsonTModel,
) =>
    <String, dynamic>{
      if (instance.isSuccess case final value?) 'isSuccess': value,
      if (instance.error case final value?) 'error': value,
      if (instance.message case final value?) 'message': value,
      if (_$nullableGenericToJson(instance.data, toJsonTModel)
          case final value?)
        'data': value,
      if (_$nullableGenericToJson(instance.mainData, toJsonTModel)
          case final value?)
        'main_data': value,
      if (instance.code case final value?) 'code': value,
      if (instance.apiStatus case final value?) 'apiStatus': value,
      if (instance.token case final value?) 'token': value,
    };

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

Object? _$nullableGenericToJson<T>(
  T? input,
  Object? Function(T value) toJson,
) =>
    input == null ? null : toJson(input);
