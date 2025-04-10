// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_base_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkBaseModel<T> _$NetworkBaseModelFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    NetworkBaseModel<T>(
      statusCode: (json['statusCode'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => NetworkErrorDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
      data: _$nullableGenericFromJson(json['data'], fromJsonT),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$NetworkBaseModelToJson<T>(
  NetworkBaseModel<T> instance,
  Object? Function(T value) toJsonT,
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('statusCode', instance.statusCode);
  writeNotNull('isSuccess', instance.isSuccess);
  writeNotNull('message', instance.message);
  writeNotNull('data', _$nullableGenericToJson(instance.data, toJsonT));
  writeNotNull('errors', instance.errors?.map((e) => e.toJson()).toList());
  return val;
}

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
