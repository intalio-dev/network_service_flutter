// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_error_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkErrorDetails _$NetworkErrorDetailsFromJson(Map<String, dynamic> json) =>
    NetworkErrorDetails(
      errorCode: json['errorCode'] as String?,
      message: json['message'] as String?,
      statusCode: (json['statusCode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NetworkErrorDetailsToJson(NetworkErrorDetails instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('errorCode', instance.errorCode);
  writeNotNull('message', instance.message);
  writeNotNull('statusCode', instance.statusCode);
  return val;
}
