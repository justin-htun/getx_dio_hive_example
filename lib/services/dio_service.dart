import 'dart:developer';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../config/api_config.dart';
import '../constants/app_constants.dart';

class DIOService {
  DIOService._instance();

  static final DIOService _dioService = DIOService._instance();

  factory DIOService() => _dioService;

  final dio = createDio();

  static Dio createDio() {
    var dio = Dio(BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        receiveTimeout: 15000,
        // 15 seconds
        connectTimeout: 15000,
        sendTimeout: 15000,
        contentType: 'text/html'));
    dio.interceptors.addAll({
      AppInterceptors(dio),
      LogInterceptor(
          request: true,
          responseBody: true,
          requestBody: true,
          error: true,
          logPrint: (dioLog) {
            log('$dioLog');
          }),
      ChuckerDioInterceptor()
    });
    return dio;
  }
}

class AppInterceptors extends QueuedInterceptorsWrapper {
  final Dio dio;

  AppInterceptors(this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.path != "/api/auth/get_tokens") {
      var box = await Hive.openBox(AppConstants.general_box);
      options.headers['Access-Token'] = box.get(AppConstants.token_key);
    }

    return handler.next(options);
  }

  Future<void> retry(DioError error, Dio dio) async {}

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioErrorType.connectTimeout:
        return handler.next(err);
      case DioErrorType.sendTimeout:
        return handler.next(err);
      case DioErrorType.receiveTimeout:
        return handler.next(err);
      case DioErrorType.response:
        switch (err.response?.statusCode) {
          case 400:
            return handler.next(err);
            case 401:
            retry(err, dio);
            return handler.next(err);
            throw UnauthorizedException(err.requestOptions);
          case 404:
            return handler.next(err);
            throw NotFoundException(err.requestOptions);
          case 409:
            return handler.next(err);
            throw ConflictException(err.requestOptions);
          case 500:
            return handler.next(err);
            throw InternalServerErrorException(err.requestOptions);
        }
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        return handler.next(err);
        throw NoInternetConnectionException(err.requestOptions);
    }
    return handler.next(err);
  }
}

class BadRequestException extends DioError {
  BadRequestException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Invalid request';
  }
}

class InternalServerErrorException extends DioError {
  InternalServerErrorException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Unknown error occurred, please try again later.';
  }
}

class ConflictException extends DioError {
  ConflictException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioError {
  UnauthorizedException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'Access denied';
  }
}

class NotFoundException extends DioError {
  NotFoundException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioError {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class DeadlineExceededException extends DioError {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}
