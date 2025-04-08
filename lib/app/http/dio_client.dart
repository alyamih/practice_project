import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio dio;
  factory DioClient() => _instance ?? (_instance = DioClient._());
  DioClient._() {
    dio = Dio()
      ..options.baseUrl = 'https://jsonplaceholder.typicode.com/'
      ..httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () => HttpClient()
          ..findProxy = ((Uri _) => 'PROXY 127.0.0.1:9090')
          ..badCertificateCallback =
              ((X509Certificate cert, String host, int port) => true),
      );
  }
}
