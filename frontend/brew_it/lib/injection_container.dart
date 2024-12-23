import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<Dio>(_createDio);
}

Dio _createDio() {
  final dio = Dio(BaseOptions(
    baseUrl: "http://127.0.0.1:8000/api",
  ));
  // dio.options.extra['withCredentials'] = true;
  // dio.httpClientAdapter = BrowserHttpClientAdapter(withCredentials: true);
  return dio;
}