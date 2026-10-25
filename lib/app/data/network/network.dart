import 'dart:developer';
import 'package:daily_meal_and_grocery_app/app/routes/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'jwt_helper.dart';
import 'local_storage.dart';
import 'url.dart';

/// Standard response wrapper for API requests
class NetworkResponse<T> {
  final bool isSuccess;
  final int? statusCode;
  final T? responseData;
  final String errorMessage;
  final String? successMessage;

  const NetworkResponse({
    required this.isSuccess,
    this.statusCode,
    this.responseData,
    this.errorMessage = '',
    this.successMessage,
  });

  /// Returns the backend message (success message or error message)
  String get message => isSuccess ? (successMessage ?? '') : errorMessage;

  @override
  String toString() {
    return 'NetworkResponse(isSuccess: $isSuccess, statusCode: $statusCode, message: $message, responseData: $responseData)';
  }
}

/// Production-ready Dio Network Caller / Client
class NetworkCaller {
  static final NetworkCaller _instance = NetworkCaller._internal();
  factory NetworkCaller() => _instance;
  static NetworkCaller get instance => _instance;

  late final Dio _dio;
  Dio get dio => _dio;

  NetworkCaller._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Urls.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Setup interceptors
    _dio.interceptors.addAll([
      _authInterceptor(),
      if (kDebugMode) _loggingInterceptor(),
    ]);
  }

  // Auth / Header Interceptor
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) async {
        final bool requiresToken = options.extra['requiresToken'] ?? true;
        if (requiresToken && !options.headers.containsKey('Authorization')) {
          final token = await getToken();
          if (token != null && token.isNotEmpty) {
            // Check if JWT token is expired before sending
            if (JwtHelper.isExpired(token)) {
              await clearToken();
              if (Get.currentRoute != Routes.signin &&
                  Get.currentRoute != Routes.signup &&
                  Get.currentRoute != Routes.splash) {
                Get.offAllNamed(Routes.signin);
              }
              return handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.cancel,
                  error: 'Access token expired. Please sign in again.',
                ),
              );
            }
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          await clearToken();
          if (Get.currentRoute != Routes.signin &&
              Get.currentRoute != Routes.signup &&
              Get.currentRoute != Routes.splash) {
            Get.offAllNamed(Routes.signin);
          }
        }
        return handler.next(error);
      },
    );
  }

  // Pretty Logging Interceptor (Shows actual backend success/error messages)
  InterceptorsWrapper _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        log('➡️ [DIO REQUEST] [${options.method}] ${options.uri}');
        if (options.data != null) {
          log('📦 Request Body: ${options.data}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        final data = response.data;
        final backendMessage = (data is Map)
            ? (data['message']?.toString() ?? data['msg']?.toString())
            : null;

        log('✅ [DIO SUCCESS] [${response.statusCode}] ${response.requestOptions.uri}');
        if (backendMessage != null && backendMessage.isNotEmpty) {
          log('💬 Backend Message: $backendMessage');
        }
        if (data != null) {
          log('📄 Response Data: $data');
        }
        return handler.next(response);
      },
      onError: (DioException error, handler) {
        final data = error.response?.data;
        final backendMessage = _extractMessage(data);

        log('❌ [DIO ERROR] [${error.response?.statusCode ?? 'ERROR'}] ${error.requestOptions.uri}');
        if (backendMessage.isNotEmpty) {
          log('💬 Backend Error: $backendMessage');
        }
        if (data != null) {
          log('📄 Response Data: $data');
        } else if (error.message != null && error.message!.isNotEmpty) {
          log('⚠️ Error: ${error.message}');
        }
        return handler.next(error);
      },
    );
  }

  // Token Management Helpers (delegating to LocalStorage)
  static Future<void> saveToken(String token) async {
    await LocalStorage.saveToken(token);
  }

  static Future<String?> getToken() async {
    return await LocalStorage.getToken();
  }

  static Future<void> clearToken() async {
    await LocalStorage.clearAuthData();
  }

  // ---------------------------------------------------------------------------
  // HTTP METHODS
  // ---------------------------------------------------------------------------

  /// GET Request
  static Future<NetworkResponse<dynamic>> getRequest(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresToken = true,
  }) async {
    try {
      final finalOptions = (options ?? Options()).copyWith(
        extra: {'requiresToken': requiresToken, ...(options?.extra ?? {})},
      );
      final response = await _instance._dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: finalOptions,
        cancelToken: cancelToken,
      );
      final data = response.data;
      final successMsg = (data is Map)
          ? (data['message']?.toString() ?? data['msg']?.toString())
          : null;

      return NetworkResponse(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: data,
        successMessage: successMsg,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: 'Something went wrong: $e',
      );
    }
  }

  /// POST Request
  static Future<NetworkResponse<dynamic>> postRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresToken = true,
  }) async {
    try {
      final finalOptions = (options ?? Options()).copyWith(
        extra: {'requiresToken': requiresToken, ...(options?.extra ?? {})},
      );
      final response = await _instance._dio.post(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: finalOptions,
        cancelToken: cancelToken,
      );
      final data = response.data;
      final successMsg = (data is Map)
          ? (data['message']?.toString() ?? data['msg']?.toString())
          : null;

      return NetworkResponse(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: data,
        successMessage: successMsg,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: 'Something went wrong: $e',
      );
    }
  }

  /// PUT Request
  static Future<NetworkResponse<dynamic>> putRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresToken = true,
  }) async {
    try {
      final finalOptions = (options ?? Options()).copyWith(
        extra: {'requiresToken': requiresToken, ...(options?.extra ?? {})},
      );
      final response = await _instance._dio.put(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: finalOptions,
        cancelToken: cancelToken,
      );
      final data = response.data;
      final successMsg = (data is Map)
          ? (data['message']?.toString() ?? data['msg']?.toString())
          : null;

      return NetworkResponse(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: data,
        successMessage: successMsg,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: 'Something went wrong: $e',
      );
    }
  }

  /// PATCH Request
  static Future<NetworkResponse<dynamic>> patchRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresToken = true,
  }) async {
    try {
      final finalOptions = (options ?? Options()).copyWith(
        extra: {'requiresToken': requiresToken, ...(options?.extra ?? {})},
      );
      final response = await _instance._dio.patch(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: finalOptions,
        cancelToken: cancelToken,
      );
      final data = response.data;
      final successMsg = (data is Map)
          ? (data['message']?.toString() ?? data['msg']?.toString())
          : null;

      return NetworkResponse(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: data,
        successMessage: successMsg,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: 'Something went wrong: $e',
      );
    }
  }

  /// DELETE Request
  static Future<NetworkResponse<dynamic>> deleteRequest(
    String endpoint, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresToken = true,
  }) async {
    try {
      final finalOptions = (options ?? Options()).copyWith(
        extra: {'requiresToken': requiresToken, ...(options?.extra ?? {})},
      );
      final response = await _instance._dio.delete(
        endpoint,
        data: body,
        queryParameters: queryParameters,
        options: finalOptions,
        cancelToken: cancelToken,
      );
      final data = response.data;
      final successMsg = (data is Map)
          ? (data['message']?.toString() ?? data['msg']?.toString())
          : null;

      return NetworkResponse(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: data,
        successMessage: successMsg,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: 'Something went wrong: $e',
      );
    }
  }

  /// Multipart / File Upload Request
  static Future<NetworkResponse<dynamic>> multipartRequest(
    String endpoint, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    Options? options,
    CancelToken? cancelToken,
    bool requiresToken = true,
  }) async {
    try {
      final finalOptions = (options ?? Options()).copyWith(
        contentType: 'multipart/form-data',
        extra: {'requiresToken': requiresToken, ...(options?.extra ?? {})},
      );
      final response = await _instance._dio.post(
        endpoint,
        data: formData,
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        options: finalOptions,
        cancelToken: cancelToken,
      );
      final data = response.data;
      final successMsg = (data is Map)
          ? (data['message']?.toString() ?? data['msg']?.toString())
          : null;

      return NetworkResponse(
        isSuccess: true,
        statusCode: response.statusCode,
        responseData: data,
        successMessage: successMsg,
      );
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return NetworkResponse(
        isSuccess: false,
        errorMessage: 'Something went wrong: $e',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // HELPER ERROR EXTRACTORS
  // ---------------------------------------------------------------------------

  /// Extracts meaningful message from backend response body
  static String _extractMessage(dynamic data) {
    if (data == null) return '';
    if (data is Map) {
      if (data['message'] != null && data['message'].toString().trim().isNotEmpty) {
        return data['message'].toString();
      }
      if (data['msg'] != null && data['msg'].toString().trim().isNotEmpty) {
        return data['msg'].toString();
      }
      if (data['error'] != null) {
        if (data['error'] is String && data['error'].toString().trim().isNotEmpty) {
          return data['error'].toString();
        }
        if (data['error'] is Map) {
          final errMap = data['error'] as Map;
          return errMap['cause']?.toString() ??
              errMap['message']?.toString() ??
              errMap['name']?.toString() ??
              '';
        }
      }
      if (data['errors'] != null) {
        if (data['errors'] is List && (data['errors'] as List).isNotEmpty) {
          return (data['errors'] as List).first.toString();
        }
        return data['errors'].toString();
      }
    } else if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return '';
  }

  /// Handles DioException cleanly without verbose internal client error messages
  static NetworkResponse<dynamic> _handleDioError(DioException error) {
    String message = _extractMessage(error.response?.data);

    if (message.isEmpty) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          message = 'Connection timeout. Please check your internet connection.';
          break;
        case DioExceptionType.connectionError:
          message = 'No internet connection. Please check your network.';
          break;
        case DioExceptionType.cancel:
          message = 'Request was cancelled.';
          break;
        case DioExceptionType.badResponse:
          final code = error.response?.statusCode;
          if (code == 404) {
            message = 'Resource not found on server (404).';
          } else if (code == 401) {
            message = 'Invalid credentials or unauthorized (401).';
          } else if (code == 403) {
            message = 'Access forbidden (403).';
          } else if (code != null && code >= 500) {
            message = 'Internal server error ($code). Please try again later.';
          } else {
            message = 'Server responded with status $code.';
          }
          break;
        default:
          message = 'Something went wrong. Please try again.';
      }
    }

    return NetworkResponse(
      isSuccess: false,
      statusCode: error.response?.statusCode,
      responseData: error.response?.data,
      errorMessage: message,
    );
  }
}

/// Alias for developers preferring DioCaller
typedef DioCaller = NetworkCaller;
