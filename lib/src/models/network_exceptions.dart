import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:network_service/src/models/network_error_details.dart';

import 'network_base_model.dart';

part 'network_exceptions.freezed.dart';

@freezed
abstract class NetworkExceptions with _$NetworkExceptions {
  const NetworkExceptions._();

  const factory NetworkExceptions.requestCancelled(
      NetworkErrorDetails errorDetails) = RequestCancelled;

  const factory NetworkExceptions.unauthorizedRequest(
      NetworkErrorDetails errorDetails) = UnauthorizedRequest;

  const factory NetworkExceptions.badRequest(NetworkErrorDetails errorDetails) =
      BadRequest;

  const factory NetworkExceptions.notFound(NetworkErrorDetails errorDetails) =
      NotFound;

  const factory NetworkExceptions.methodNotAllowed(
      NetworkErrorDetails errorDetails) = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable(
      NetworkErrorDetails errorDetails) = NotAcceptable;

  const factory NetworkExceptions.requestTimeout(
      NetworkErrorDetails errorDetails) = RequestTimeout;

  const factory NetworkExceptions.sendTimeout(
      NetworkErrorDetails errorDetails) = SendTimeout;

  const factory NetworkExceptions.conflict(NetworkErrorDetails errorDetails) =
      Conflict;

  const factory NetworkExceptions.internalServerError(
      NetworkErrorDetails errorDetails) = InternalServerError;

  const factory NetworkExceptions.notImplemented(
      NetworkErrorDetails errorDetails) = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable(
      NetworkErrorDetails errorDetails) = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection(
      NetworkErrorDetails errorDetails) = NoInternetConnection;

  const factory NetworkExceptions.formatException(
      NetworkErrorDetails errorDetails) = FormatException;

  const factory NetworkExceptions.unableToProcess(
      NetworkErrorDetails errorDetails) = UnableToProcess;

  const factory NetworkExceptions.defaultError(NetworkErrorDetails message) =
      DefaultError;

  const factory NetworkExceptions.unexpectedError(
      NetworkErrorDetails errorDetails) = UnexpectedError;

  static NetworkExceptions handleResponse(Response? response) {
    final NetworkBaseModel baseModel = NetworkBaseModel.fromJson(
      response?.data ?? {},
      (json) => json as Map<String, dynamic>?,
    );

    NetworkErrorDetails errorMessage = NetworkErrorDetails(
      statusCode: baseModel.statusCode ?? response?.statusCode,
      message: baseModel.errors?.first.message ??
          response?.statusMessage ??
          "Unknown error occurred",
      errorCode: baseModel.errors?.first.errorCode,
    );
    int? statusCode = baseModel.statusCode ?? response?.statusCode;

    if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return NetworkExceptions.badRequest(errorMessage);
        case 401:
          return NetworkExceptions.unauthorizedRequest(errorMessage);
        case 403:
          return NetworkExceptions.unauthorizedRequest(errorMessage);
        case 404:
          return NetworkExceptions.notFound(errorMessage);
        case 408:
          return NetworkExceptions.requestTimeout(errorMessage);
        case 409:
          return NetworkExceptions.conflict(errorMessage);
        case 500:
          return NetworkExceptions.internalServerError(errorMessage);
        case 503:
          return NetworkExceptions.serviceUnavailable(errorMessage);
        default:
          return NetworkExceptions.defaultError(errorMessage);
      }
    } else {
      return NetworkExceptions.unexpectedError(errorMessage);
    }
  }

  static NetworkExceptions getException(dynamic error) {
    NetworkErrorDetails dioError;
    if (error is DioException) {
      dioError = NetworkErrorDetails(
        message: error.message,
        errorCode: error.response?.statusMessage,
        statusCode: error.response?.statusCode,
      );
      switch (error.type) {
        case DioExceptionType.cancel:
          return NetworkExceptions.requestCancelled(dioError);
        case DioExceptionType.connectionTimeout:
          return NetworkExceptions.requestTimeout(dioError);
        case DioExceptionType.unknown:
          if (error.error.toString().contains('Failed host lookup')) {
            return NetworkExceptions.noInternetConnection(dioError);
          } else {
            return NetworkExceptions.unexpectedError(dioError);
          }
        case DioExceptionType.receiveTimeout:
          return NetworkExceptions.sendTimeout(dioError);
        case DioExceptionType.badResponse:
          if (error.response != null) {
            return NetworkExceptions.handleResponse(error.response);
          } else {
            return NetworkExceptions.unexpectedError(dioError);
          }
        case DioExceptionType.sendTimeout:
          return NetworkExceptions.sendTimeout(dioError);
        case DioExceptionType.badCertificate:
          return NetworkExceptions.notAcceptable(dioError);
        case DioExceptionType.connectionError:
          return NetworkExceptions.noInternetConnection(dioError);
        }
    } else if (error is SocketException) {
      dioError = NetworkErrorDetails(
        message: error.message,
        errorCode: error.message,
      );
      return NetworkExceptions.noInternetConnection(dioError);
    } else if (error.toString().contains("is not a subtype of")) {
      dioError = NetworkErrorDetails(
        message: error.toString(),
        errorCode: error.toString(),
      );
      return NetworkExceptions.unableToProcess(dioError);
    } else {
      dioError = NetworkErrorDetails(
        message: error.toString(),
        errorCode: error.toString(),
      );
      return NetworkExceptions.unexpectedError(dioError);
    }
  }

  NetworkErrorDetails get networkErrorDetails {
    return when(
      notImplemented: (NetworkErrorDetails errorDetails) => errorDetails,
      requestCancelled: (NetworkErrorDetails errorDetails) => errorDetails,
      internalServerError: (NetworkErrorDetails errorDetails) => errorDetails,
      notFound: (NetworkErrorDetails errorDetails) => errorDetails,
      serviceUnavailable: (NetworkErrorDetails errorDetails) => errorDetails,
      methodNotAllowed: (NetworkErrorDetails errorDetails) => errorDetails,
      badRequest: (NetworkErrorDetails errorDetails) => errorDetails,
      unauthorizedRequest: (NetworkErrorDetails errorDetails) => errorDetails,
      unexpectedError: (NetworkErrorDetails errorDetails) => errorDetails,
      requestTimeout: (NetworkErrorDetails errorDetails) => errorDetails,
      noInternetConnection: (NetworkErrorDetails errorDetails) => errorDetails,
      conflict: (NetworkErrorDetails errorDetails) => errorDetails,
      sendTimeout: (NetworkErrorDetails errorDetails) => errorDetails,
      unableToProcess: (NetworkErrorDetails errorDetails) => errorDetails,
      defaultError: (NetworkErrorDetails message) => message,
      formatException: (NetworkErrorDetails errorDetails) => errorDetails,
      notAcceptable: (NetworkErrorDetails errorDetails) => errorDetails,
    );
  }
}
