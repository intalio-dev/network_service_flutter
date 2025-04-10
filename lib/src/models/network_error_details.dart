import 'package:json_annotation/json_annotation.dart';

part 'network_error_details.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class NetworkErrorDetails {
  final String? errorCode;
  final String? message;
  final int? statusCode;

  const NetworkErrorDetails({
    this.errorCode,
    this.message,
    this.statusCode,
  });

  factory NetworkErrorDetails.fromJson(Map<String, dynamic> json) =>
      _$NetworkErrorDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkErrorDetailsToJson(this);
}
