// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageResponse<TModel> _$PageResponseFromJson<TModel>(
  Map<String, dynamic> json,
  TModel Function(Object? json) fromJsonTModel,
) =>
    PageResponse<TModel>(
      totalRecords: (json['totalRecords'] as num?)?.toInt(),
      pageNo: (json['pageNo'] as num?)?.toInt(),
      pageSize: (json['pageSize'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
      main_data:
          (json['main_data'] as List<dynamic>?)?.map(fromJsonTModel).toList(),
      isSuccess: json['isSuccess'] as bool?,
      error: json['error'] as String?,
      message: json['message'] as String?,
      items: (json['items'] as List<dynamic>?)?.map(fromJsonTModel).toList(),
      code: (json['code'] as num?)?.toInt(),
      apiStatus: json['apiStatus'] as bool?,
    )..data = (json['data'] as List<dynamic>?)?.map(fromJsonTModel).toList();

Map<String, dynamic> _$PageResponseToJson<TModel>(
  PageResponse<TModel> instance,
  Object? Function(TModel value) toJsonTModel,
) =>
    <String, dynamic>{
      if (instance.totalRecords case final value?) 'totalRecords': value,
      if (instance.pageNo case final value?) 'pageNo': value,
      if (instance.pageSize case final value?) 'pageSize': value,
      if (instance.total case final value?) 'total': value,
      if (instance.isSuccess case final value?) 'isSuccess': value,
      if (instance.error case final value?) 'error': value,
      if (instance.message case final value?) 'message': value,
      if (instance.items?.map(toJsonTModel).toList() case final value?)
        'items': value,
      if (instance.data?.map(toJsonTModel).toList() case final value?)
        'data': value,
      if (instance.main_data?.map(toJsonTModel).toList() case final value?)
        'main_data': value,
      if (instance.code case final value?) 'code': value,
      if (instance.apiStatus case final value?) 'apiStatus': value,
    };
