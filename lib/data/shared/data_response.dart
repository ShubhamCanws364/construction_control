
import 'package:json_annotation/json_annotation.dart';

part 'data_response.g.dart';
@JsonSerializable(genericArgumentFactories: true,includeIfNull: false,explicitToJson: true)
class DataResponse<TModel>{
  bool? isSuccess;
  String? error;
  String? message;
  TModel? data;
  TModel? mainData;
  int? code;
  bool? apiStatus;
  String? token;


  DataResponse({this.isSuccess, this.error, this.message,this.data,this.code, this.apiStatus,this.mainData, this.token,});

  factory DataResponse.fromJson(Map<String, dynamic> json, TModel Function(Object? json) fromJsonT,) => _$DataResponseFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object Function(TModel value) toJsonT) => _$DataResponseToJson(this, toJsonT);

}