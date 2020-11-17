import 'package:flutter/foundation.dart';

import 'http_service.dart';

import '../../utils/enums/endpoint_enum.dart';

class ApiService {
  final String _baseUrl =
      "https://mvzo6ikn6kswnep-db202010291259.adb.me-dubai-1.oraclecloudapps.com/ords/lms/";
  final HttpService _httpService = HttpService();

  ApiService._();

  /// Singleton instance of a ApiService class.
  static final instance = ApiService._();

  Future<List<dynamic>> getEndPointData(EndPoint endPoint, {String id=''}) async {
    final String url = _baseUrl + endPoint.getPath(id: id);
    final data = await _httpService.get(url);
    return data["items"];
  }

  String getUrl(EndPoint endPoint, String id) => _baseUrl + endPoint.getPath(id: id);

  Stream<List<T>> collectionStream<T>({
    @required EndPoint endPoint,
    String id='',
    @required T Function(Map<String, dynamic> data) builder,
  }) async* {
    final String url = getUrl(endPoint, id);

    //Entire map pf response
    final data =  await _httpService.get(url);

    //Items of table as json
    final List<dynamic> items = data['items'];

    //Streaming the deserialized objects
    yield items.map((dataMap) => builder(dataMap)).toList();
  }
}
