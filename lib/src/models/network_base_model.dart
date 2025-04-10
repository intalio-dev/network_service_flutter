import 'package:json_annotation/json_annotation.dart';
import 'package:network_service/src/models/network_error_details.dart';

part 'network_base_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class NetworkBaseModel<T> {
  final int? statusCode;
  final bool? isSuccess;
  final String? message;
  final T? data;
  final List<NetworkErrorDetails>? errors;

  NetworkBaseModel({
    this.statusCode,
    this.isSuccess,
    this.errors,
    this.data,
    this.message,
  });

  factory NetworkBaseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$NetworkBaseModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$NetworkBaseModelToJson(this, toJsonT);
}
