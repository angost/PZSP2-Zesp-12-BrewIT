import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'dart:html';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<Dio>(_createDio);
}

Dio _createDio() {
  final dio = Dio(BaseOptions(
    baseUrl: "https://127.0.0.1:8000/api",
  ));

  dio.options.extra['withCredentials'] = true;

  // Dodanie interceptora do ustawienia X-CSRFTOKEN
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      // Pobierz token CSRF dynamicznie (np. z ciasteczek)
      final csrfToken = getCsrfToken();
      if (csrfToken != null) {
        options.headers['X-CSRFToken'] = csrfToken;
      } else {
        print('CSRF token not found!');
      }

      return handler.next(options);
    },
    onResponse: (response, handler) {
      return handler.next(response); // Przetwarzaj odpowiedź
    },
    onError: (DioError error, handler) {
      return handler.next(error); // Przetwarzaj błąd
    },
  ));

  return dio;
}

// Funkcja do pobrania tokena CSRF z ciasteczek przeglądarki
String? getCsrfToken() {
  final cookies = document.cookie?.split('; ') ?? [];
  for (final cookie in cookies) {
    if (cookie.startsWith('csrftoken=')) {
      return cookie.split('=')[1];
    }
  }
  return null;
}
